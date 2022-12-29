import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/authentication/authFunctions.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/authentication/regexValidation.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/languageDropDownMenu.dart';
import '../models/themeBLoC.dart';

// Form for signing in/ signing up. Same form is used for both, the functionality
// is changed with if statements and ternary operators based on the title of
// the widget, either 'Sign In' or 'Sign Up'

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key, this.title}) : super(key: key);

  // used to determine which page to show, 'Sign In' or 'Sign Up'
  final String? title;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final _auth = Auth();
  // used to change the functionality of the page between sign in and sign up
  // true by default to show sign-in page, false = sign-up page.
  bool isSigningIn = true;
  String? currentLanguage;

  String? _email;
  String? _password;

  // callback? (idk if this is the correct term)
  // used in languageDropDownMenu.dart
  void changeLanguage(String selectedLanguage) {
    setState(() {
      currentLanguage = selectedLanguage;
    });
  }

  // Input decoration builder for the email and password fields
  InputDecoration buildInputDecor(Icon icon, String label) => InputDecoration(
        prefixIcon: icon,
        errorMaxLines: 10,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        labelText: FlutterI18n.translate(context, label),
      );

  @override
  Widget build(BuildContext context) {
    // either light or dark mode
    final containerTheme = Provider.of<ThemeBLoC>(context).isDarkMode
        ? Colors.grey[900]
        : Colors.white;

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: width * 0.9,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: containerTheme,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.15),
                // LOGO IMAGE
                Image.network(zamazonLogo),

                // GREETING TEXT
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    (isSigningIn)
                        ? FlutterI18n.translate(context, "SignInForm.greeting")
                        : FlutterI18n.translate(context, "SignUpForm.greeting"),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),

                // EMAIL FIELD
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: buildInputDecor(
                      const Icon(Icons.email),
                      "SignInForm.email",
                    ),
                    onSaved: (email) {
                      _email = email!.trim();
                    },
                    validator: (value) {
                      return RegexValidation().validateEmail(value);
                    },
                  ),
                ),

                // PASSWORD FIELD
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    //Password Validator
                    obscureText: true,
                    decoration: buildInputDecor(
                      const Icon(Icons.key),
                      "SignInForm.password",
                    ),
                    onSaved: (password) {
                      _password = password!.trim();
                    },
                    validator: (value) {
                      return RegexValidation().validatePassword(value);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                // SIGN IN BUTTON
                Container(
                  width: width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrangeAccent),
                  child: TextButton(
                      //Confirmed sign up and return to home page as logged in user
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (isSigningIn) {
                            trySignIn(context);
                          } else {
                            trySignUp(context);
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black87,
                      ),
                      child: Text(
                          (isSigningIn)
                              ? FlutterI18n.translate(
                                  context, "SignInForm.sign_in")
                              : FlutterI18n.translate(
                                  context, "SignUpForm.sign_up"),
                          style: const TextStyle(fontSize: 30))),
                ),

                // CHANGE SIGN IN <-> SIGN UP PAGE BUTTON
                TextButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _formKey.currentState!.reset();
                    setState(() {
                      // change between sign in and sign up
                      isSigningIn = !isSigningIn;
                    });
                  },
                  style: TextButton.styleFrom(
                    surfaceTintColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: Text(
                    (isSigningIn)
                        ? FlutterI18n.translate(
                            context, "SignInForm.no_account")
                        : FlutterI18n.translate(
                            context, "SignUpForm.yes_account"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                // CHOOSE LANGUAGE DROP DOWN MENU
                LanguageDropDownMenu(
                  currentLanguage: currentLanguage,
                  changeLanguage: changeLanguage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void trySignIn(BuildContext context) async {
    try {
      await _auth.signIn(_email, _password);
      if (!mounted) return;
      showSnackBar(context,
          FlutterI18n.translate(context, "SignInForm.snackbar_greeting"));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context,
          FlutterI18n.translate(context, "SignInForm.snackbar_incorrect"));
      print(e);
    }
  }

  void trySignUp(BuildContext context) async {
    try {
      await _auth.signUp(_email, _password);
      if (!mounted) return;
      // if signup is successful, ask them for their name and address.
      Navigator.pushNamed(context, "/NewUserInfoPage");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e);
    }
  }
}
