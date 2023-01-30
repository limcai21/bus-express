import 'dart:convert';

import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeUsername extends StatefulWidget {
  @override
  State<ChangeUsername> createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final formKey = GlobalKey<FormState>();
  var prefs;
  var usernameController = TextEditingController();

  checkUsernameExist(String username) {
    final checkUsername = prefs.getString(username);
    if (checkUsername != null) {
      return usernameExist;
    } else {
      return null;
    }
  }

  updateUsername() {
    final newUsername = usernameController.text;

    // GET CURRENT USER DATA
    Map<String, dynamic> currentUserData =
        jsonDecode(prefs.getString(currentLoginUsername));
    currentUserData['username'] = newUsername;
    prefs.setString(currentLoginUsername, jsonEncode(currentUserData));
    print("updated username");

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(FluentIcons.person_24_filled),
              labelText: 'Username',
              hintText: currentLoginUsername,
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
                  await updateUsername();
                  alertDialog(
                    emailUpdateTitle,
                    emailUpdateDescription,
                    context,
                  );
                }
              },
              child: Text('Change'),
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
