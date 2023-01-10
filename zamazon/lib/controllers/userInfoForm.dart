import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import '../authentication/authFunctions.dart';
import '../authentication/regexValidation.dart';
import 'enterAddress.dart';

// Form for setting username and address

class UserInfoForm extends StatefulWidget {
  const UserInfoForm(
      {Key? key,
      required this.buttonText,
      required this.initialName,
      required this.initialAddress})
      : super(key: key);

  final String buttonText;
  final String initialName;
  final String initialAddress;

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = Auth();

  String? _name;
  String? _address;

  @override
  void initState() {
    super.initState();

    _name = widget.initialName;
    _address = widget.initialAddress;
  }

  // callback used in enterAddress.dart to set the address here.
  void setAddress(String address) {
    setState(() {
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        // height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: widget.initialName,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText:
                        FlutterI18n.translate(context, "UserProfilePage.name"),
                    errorStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                    errorMaxLines: 3,
                  ),
                  onSaved: (value) {
                    _name = value;
                  },
                  validator: (value) {
                    return RegexValidation().validateName(value);
                  },
                ),
              ),
            ),
            EnterAddress(
              onAddressSaved: setAddress,
              initialAddress: widget.initialAddress,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.85, 50)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      _auth.addUserInfo(_name!, _address!);

                      // if used for registration form
                      if (widget.buttonText == 'Confirm') {
                        showSnackBar(
                          context,
                          FlutterI18n.translate(
                              context, "UserProfilePage.registered"),
                        );

                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);

                        // else used for profile page
                      } else {
                        showSnackBar(
                          context,
                          FlutterI18n.translate(
                              context, "UserProfilePage.updated"),
                        );
                      }
                    }
                  },
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
