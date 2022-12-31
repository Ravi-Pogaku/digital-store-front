import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/controllers/userInfoForm.dart';
import 'package:zamazon/models/settings_BLoC.dart';

// newly registered user must enter their name and address

class NewUserInfoPage extends StatefulWidget {
  const NewUserInfoPage({Key? key}) : super(key: key);

  @override
  State<NewUserInfoPage> createState() => _NewUserInfoPageState();
}

class _NewUserInfoPageState extends State<NewUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    final containerTheme = Provider.of<SettingsBLoC>(context).isDarkMode
        ? Colors.grey[900]
        : Colors.white;

    return GestureDetector(
      onTap: () {
        // when user taps on screen, remove keyboard
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: containerTheme,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Enter Your Name And Shipping Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                        textAlign: TextAlign.center,
                      ),

                      // form for setting name and address
                      UserInfoForm(
                        buttonText: 'Confirm',
                        initialName: '',
                        initialAddress: '',
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
