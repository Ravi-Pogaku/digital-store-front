import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';

class OrderTrackMap extends StatefulWidget {
  const OrderTrackMap({
    super.key,
    required this.deliveryAddress,
  });

  final String? deliveryAddress;

  @override
  State<OrderTrackMap> createState() => _OrderTrackMapState();
}

class _OrderTrackMapState extends State<OrderTrackMap> {
  late MapboxMapController mapboxMapController;

  @override
  void dispose() {
    mapboxMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserLatLng(widget.deliveryAddress!),
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: DefaultAppBar(
                title: Text(FlutterI18n.translate(context, "OrderMap.map_title")),
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              body: Stack(children: [
                MapboxMap(
                  doubleClickZoomEnabled: true,
                  accessToken: Constants.mapBoxAccessToken,
                  initialCameraPosition:
                      CameraPosition(target: snapshot.data!, zoom: 8),
                  onMapCreated: (MapboxMapController controller) async {
                    mapboxMapController = controller;
                  },
                  onStyleLoadedCallback: () async {
                    // adding a symbol to the warehouse location
                    await mapboxMapController.addSymbol(const SymbolOptions(
                      geometry: Constants.warehouseLocation,
                      iconSize: 0.1,
                      iconImage: "assets/icons/warehouse.png",
                    ));
                    //adding markers to delivery location
                    await mapboxMapController.addSymbol(
                      SymbolOptions(
                        geometry: snapshot.data,
                        iconSize: 0.1,
                        iconImage: "assets/icons/marker.png",
                      ),
                    );

                    // creating the route line
                    _addLine(false, snapshot.data!);
                  },
                  minMaxZoomPreference: const MinMaxZoomPreference(1, 15),
                ),
              ]),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _addLine(bool removeLayer, LatLng userLocation) async {
    // Add a route line between warehouse and user delivery location
    final response = await getRoute(userLocation);
    Map geometry = response['routes'][0]['geometry'];

    final fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ],
    };

    // Add new source and route
    await mapboxMapController.addSource(
        "fills", GeojsonSourceProperties(data: fills));
    await mapboxMapController.addLineLayer(
      "fills",
      "lines",
      LineLayerProperties(
        lineColor: Colors.blue.toHexStringRGB(),
        lineCap: "round",
        lineJoin: "round",
        lineWidth: 2,
      ),
    );
  }
}

// gets user's delivery location using geocoding
Future<LatLng> getUserLatLng(String address) async {
  final List<Location> locations = await locationFromAddress(address);

  return LatLng(locations[0].latitude, locations[0].longitude);
}

String baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
String accessToken =
    'pk.eyJ1IjoiZ293dGhhbXJhamVuZHJhMjciLCJhIjoiY2xhMzBkbmx5MDRzaTNvcnhjbm9nb24xNCJ9.hjfzhRWwIyOOUYSGVpS79Q';
String navType = 'driving';
LatLng source = Constants.warehouseLocation;

Dio _dio = Dio();

// gets the route from MapBox Directions API by sending a HTTP request using DIO
Future getRoute(LatLng destination) async {
  String url =
      '$baseUrl/$navType/${source.longitude},${source.latitude};${destination.longitude},${destination.latitude}?alternatives=true&continue_straight=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';
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
