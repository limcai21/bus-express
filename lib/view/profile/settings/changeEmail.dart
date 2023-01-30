import 'dart:convert';

import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeEmail extends StatefulWidget {
  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final formKey = GlobalKey<FormState>();
  var prefs;
  String currentUserEmail = "";
  var emailController = TextEditingController();

  updateEmail() {
    final newEmail = emailController.text;

    // GET CURRENT USER DATA
    Map<String, dynamic> currentUserData =
        jsonDecode(prefs.getString(currentLoginUsername));
    currentUserData['email'] = newEmail;
    prefs.setString(currentLoginUsername, jsonEncode(currentUserData));
    print("updated email");

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadPageData();
  }

  loadPageData() async {
    prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData =
        jsonDecode(prefs.getString(currentLoginUsername));
    setState(() {
      currentUserEmail = userData['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(FluentIcons.mail_24_filled),
              helperText: 'e.g: email@busexpress.com',
              labelText: 'Email',
              hintText: currentUserEmail,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return emailEmptyNull;
              } else if (!RegExp(emailRegex).hasMatch(value)) {
                return emailInvalid;
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  await updateEmail();
                  alertDialog(
                    emailUpdateTitle,
                    emailUpdateDescription,
                    context,
                  );
                }
              },
              child: Text('Update'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
