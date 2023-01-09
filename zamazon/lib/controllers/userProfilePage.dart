import 'package:flutter/material.dart';
import 'package:zamazon/authentication/authFunctions.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/models/userModel.dart';
import 'package:zamazon/controllers/userInfoForm.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, this.title});

  final String? title;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with AutomaticKeepAliveClientMixin {
  var userInfoStream = UserModel().getUserInformation();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      // default values to avoid null errors
      initialData: CusUser(),
      stream: userInfoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // if data still being retrieved, show loading circle
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        // if error, show loading circle and print error
        if (snapshot.hasError) {
          print('USER-PROFILE-PAGE ERROR: ${snapshot.error.toString()}');
          // if user quit out of the add info page on sign up
          // then initial a document with empty strings.
          Auth().addUserInfo('', '');
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        // data loaded successfully, this is the actual profile page.
        return GestureDetector(
          onTap: () {
            // when user taps on screen, remove keyboard and cursor
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // nice looking orange gradient with circle avatar and username
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  alignment: Alignment.center,
                  // orange gradient
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [
                        0.2,
                        0.4,
                        0.6,
                        0.8,
                        1.0,
                      ],
                      colors: [
                        Colors.green.shade100,
                        Colors.green.shade200,
                        Colors.green.shade300,
                        Colors.green.shade400,
                        Colors.green,
                      ],
                    ),
                    color: Colors.green[900],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),

                  // circle avatar and username
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // circle avatar with first letter of username
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Text(
                          (snapshot.data.name.isNotEmpty)
                              ? snapshot.data.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // username
                      Text(
                        (snapshot.data.name.isNotEmpty)
                            ? snapshot.data.name
                            : 'User',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                if (snapshot.data.name.isEmpty || snapshot.data.address.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'You must input this information to purchase products.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),

                // form for setting username and address
                UserInfoForm(
                  buttonText:
                      FlutterI18n.translate(context, "UserProfilePage.save"),
                  initialName: snapshot.data.name ?? '',
                  initialAddress: snapshot.data.address ?? '',
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
