import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/authentication/authFunctions.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import '../authentication/regexValidation.dart';
import '../models/themeBLoC.dart';
import '../authentication/regexValidation.dart';
import '../themes.dart';

// Form for registering a new user to firebase.

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final _formKey = GlobalKey<FormState>();
  final _auth = Auth();
  final languages = ['en', 'fr', 'sp', 'cn', 'jp'];
  String? value;

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    final containerTheme = Provider.of<ThemeBLoC>(context).isDarkMode
        ? Colors.grey[900]
        : Colors.white;

    value = FlutterI18n.currentLocale(context)?.languageCode ?? 'en';

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: containerTheme,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.network(zamazonLogo),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    FlutterI18n.translate(context, "SignUpForm.greeting"),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    //Email Validator
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText:
                          FlutterI18n.translate(context, "SignUpForm.email"),
                    ),
                    onSaved: (email) {
                      _email = email;
                    },
                    validator: (value) {
                      return RegexValidation().validateEmail(value);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    //Password Validator
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.key),
                      errorMaxLines: 10,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText:
                          FlutterI18n.translate(context, "SignUpForm.password"),
                    ),
                    onSaved: (password) {
                      _password = password;
                    },
                    validator: (value) {
                      return RegexValidation().validatePassword(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrangeAccent),
                  child: TextButton(
                      //Confirmed sign up and return to home page as logged in user
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _auth.signUp(_email, _password).then((_) {
                            Navigator.pushNamed(context, "/NewUserInfoPage");
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black87,
                      ),
                      child: Text(
                          FlutterI18n.translate(context, "SignUpForm.sign_up"),
                          style: const TextStyle(fontSize: 30))),
                ),
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context, '/SignIn');
                  },
                  style: TextButton.styleFrom(
                    surfaceTintColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: Text(
                    FlutterI18n.translate(context, "SignUpForm.yes_account"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                DropdownButton<String>(
                    value: value,
                    iconSize: 30,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: languages.map(buildMenuLang).toList(),
                    onChanged: (value) async {
                      this.value = value;
                      Locale newLocale = Locale(value!);
                      await FlutterI18n.refresh(context, newLocale);
                      setState(() {});
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuLang(String lang) => DropdownMenuItem(
        value: lang,
        child: Text(
          lang,
          style: const TextStyle(fontSize: 20),
        ),
      );
}
