import 'package:flutter/material.dart';
import 'package:zamazon/controllers/userInfoForm.dart';

// newly registered user must enter their name and address

class NewUserInfoPage extends StatefulWidget {
  const NewUserInfoPage({Key? key}) : super(key: key);

  @override
  State<NewUserInfoPage> createState() => _NewUserInfoPageState();
}

class _NewUserInfoPageState extends State<NewUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // when user taps on screen, remove keyboard
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                          },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text(
                            'Skip for now',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),

                      const Text(
                        "Enter Your Name And Shipping Address",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                        textAlign: TextAlign.center,
                      ),

                      // form for setting name and address
                      const UserInfoForm(
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
