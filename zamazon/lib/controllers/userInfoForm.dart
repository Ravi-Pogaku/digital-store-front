import 'package:flutter/material.dart';

import '../authentication/authFunctions.dart';
import '../authentication/regexValidation.dart';
import 'enterAddress.dart';

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

  // gets address back from address search from enterAddress.dart
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
        child: (widget.initialName != 'Default')
            ? Column(
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextFormField(
                          initialValue: widget.initialName,
                          //Name Validator
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: "Name",
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
                  ),
                  EnterAddress(
                    onAddressSaved: setAddress,
                    initialAddress: widget.initialAddress,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.85, 50)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            _auth.addUserInfo(_name!, _address!);

                            if (widget.buttonText == 'Confirm') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                  "User Registered, Welcome!",
                                  style: TextStyle(fontSize: 20),
                                )),
                              );

                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Information Updated!")));
                            }
                          }
                        },
                        child: Text(widget.buttonText)),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
