import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/models/userModel.dart';
import 'package:zamazon/authentication/regexValidation.dart';
import 'package:zamazon/authentication/authFunctions.dart';
import 'package:zamazon/controllers/userInfoForm.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, this.title});

  final String? title;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //to avoid NoSuchMethodError before the stream is ready
      initialData: CusUser(),
      stream: UserModel().getUserInformation(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return GestureDetector(
          onTap: () {
            // when user taps on screen, remove keyboard
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    alignment: Alignment.center,
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
                          Colors.orange.shade100,
                          Colors.orange.shade200,
                          Colors.orange.shade300,
                          Colors.orange.shade400,
                          Colors.orange,
                        ],
                      ),
                      color: Colors.orange[900],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            snapshot.data.name[0],
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data.name,
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  UserInfoForm(
                      buttonText: "Save",
                      initialName: snapshot.data.name,
                      initialAddress: snapshot.data.address)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
