import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';

import '../authentication/regexValidation.dart';
import '../globals.dart';

class EnterAddress extends StatefulWidget {
  const EnterAddress(
      {Key? key, required this.onAddressSaved, required this.initialAddress})
      : super(key: key);

  final String initialAddress;
  final ValueChanged<String> onAddressSaved;

  @override
  State<EnterAddress> createState() => _EnterAddressState();
}

class _EnterAddressState extends State<EnterAddress> {
  bool isLoading = false;
  bool isResponseEmpty = true;
  bool hasResponded = false;
  bool isWaitingForLocation = false;
  bool addressChosen = false;

  List responses = [];

  TextEditingController textController = TextEditingController();

  Timer? typingTimer;

  @override
  void initState() {
    textController.text = widget.initialAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);

    String noRequest =
        FlutterI18n.translate(context, "EnterAddress.no_request");
    String noResponse =
        FlutterI18n.translate(context, "EnterAddress.no_response");
    String loadingText =
        FlutterI18n.translate(context, "EnterAddress.loading_text");

    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: [
            locationField(),
            isLoading
                ? const LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))
                : Container(
                    height: 0,
                  ),
            isResponseEmpty
                ? Padding(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    child: Center(
                        child: isLoading
                            ? Text(loadingText)
                            : Text(
                                hasResponded ? noResponse : noRequest,
                                textAlign: TextAlign.center,
                              )))
                : Container(
                    height: 0,
                  ),
            addressSearchResults(responses, textController),
          ],
        ),
      ),
    );
  }

  // shows all search results in a listview
  Widget addressSearchResults(
      List responses, TextEditingController textController) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: responses.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              onTap: () {
                String text = responses[index]['place'];

                textController.text = text;

                // hides keyboard when user taps on a tile
                FocusManager.instance.primaryFocus?.unfocus();

                // send address back to userprofile in userProfilePage.dart
                widget.onAddressSaved(text);

                setState(() {
                  this.responses = [];
                  addressChosen = true; // make sure user chooses valid address
                });
              },
              leading: const CircleAvatar(child: Icon(Icons.location_on)),
              title: Text(responses[index]['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(responses[index]['address'],
                  overflow: TextOverflow.ellipsis),
            ),
            const Divider(
              height: 1,
            ),
          ],
        );
      },
    );
  }

  Widget locationField() {
    return Card(
        clipBehavior: Clip.antiAlias,
        child: Container(
            padding: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                enabled: isWaitingForLocation ? false : true,
                controller: textController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      FontAwesomeIcons.mapLocationDot,
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                        onPressed: isWaitingForLocation
                            ? null
                            : () => _useCurrentLocationButtonHandler(),
                        icon: const Icon(Icons.my_location)),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: FlutterI18n.translate(
                        context, "UserProfilePage.address"),
                    errorStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    )),
                onChanged: _onChangeHandler,
                validator: (value) {
                  if (addressChosen == false &&
                      widget.initialAddress == value) {
                    addressChosen = true;
                  }
                  return RegexValidation()
                      .validateAddress(value, addressChosen);
                },
              ),
            )));
  }

  _onChangeHandler(value) {
    // when user is typing, it is loading
    setState(() {
      isLoading = true;
      addressChosen = false;
    });

    // waits for one second after user has stopped typing before
    // making requests. this prevents constant, unnecessary API requests
    if (typingTimer != null) {
      setState(() {
        typingTimer?.cancel();
      });
    }
    setState(() {
      typingTimer = Timer(const Duration(seconds: 1), () async {
        // get search results using Mapbox Search API
        List response = await getSearchResults(value);

        setState(() {
          responses = response;
          hasResponded = true;
          isResponseEmpty = responses.isEmpty;
          isLoading = false; // no longer loading since response has arrived
        });
      });
    });
  }

  _useCurrentLocationButtonHandler() async {
    // before location is retrieved, let user know app is loading
    setState(() {
      isLoading = true;
      isWaitingForLocation = true;
      textController.text = '';
      responses = [];
      isResponseEmpty = true;
    });

    // using geolocation to retrieve user's current location

    String address = '';

    LocationPermission permission = await Geolocator.checkPermission();
    // if the user denied the location service, the user is asked again
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    // if the user has permanently disabled location services, their settings
    // app is automatically opened for them to change it
    else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    }
    // anything other option would be the user granting permission
    else {
      // we try getting the user's current location
      try {
        Position userLocation = await Geolocator.getCurrentPosition();

        final List<Placemark> places = await placemarkFromCoordinates(
            userLocation.latitude, userLocation.longitude);

        address = '${places[0].street}, ${places[0].locality}, '
            '${places[0].administrativeArea} ${places[0].postalCode}, ${places[0].country}';
      } on Exception catch (e) {
        // even if there is an exception, we proceed since the user can
        // either try the button again or type the address
        print(e);
      }
    }

    // regardless if the user has disabled location services or if there
    // was an error in getting the user's current location, the button and
    // the text form field are re-enabled for the user to try again

    setState(() {
      // no longer loading
      isWaitingForLocation = false;
      isLoading = false;
      // replace text field with the user's address
      textController.text = address;
      // show results again in case user's address wasn't exact
      _onChangeHandler(textController.text);
    });
  }
}

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = Constants.mapBoxAccessToken;
String searchType = 'place%2Cpostcode%2Caddress';
String searchResultsLimit = '5';
String proximity =
    '${Constants.warehouseLocation.longitude}%2C${Constants.warehouseLocation.latitude}';
String country = 'ca';

Dio _dio = Dio();

// using DIO to make HTTP requests to MapBox Search API
Future requestSearchResults(String query) async {
  String url =
      '$baseUrl/$query.json?country=$country&limit=$searchResultsLimit&proximity=$proximity&types=$searchType&access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    return responseData.data;
  } on DioError catch (e) {
    // The request was made and the server responded with a status code
    // that falls out of the range of 2xx and is also not 304.
    if (e.response != null) {
      print(e.response!.data);
      print(e.response!.headers);
      print(e.response!.requestOptions);
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      print(e.requestOptions);
      print(e.message);
    }
  }
}

Future<List> getSearchResults(String query) async {
  List parsedResponses = [];

  // if the user has not entered anything, return empty list
  // trim() removes whitespaces
  if (query.trim() == '') return parsedResponses;

  // otherwise, request search results from MapBox Search API
  var response = await requestSearchResults(query);

  // filling list with results and returning it
  List features = response['features'];
  for (var feature in features) {
    Map response = {
      'name': feature['text'],
      'address': feature['place_name'].split('${feature['text']}, ')[1],
      'place': feature['place_name'],
      'location': LatLng(feature['center'][1], feature['center'][0])
    };
    parsedResponses.add(response);
  }
  return parsedResponses;
}
