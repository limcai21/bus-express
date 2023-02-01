import 'dart:convert';
import 'package:bus_express/view/components/button/textButton.dart';
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
  SharedPreferences prefs;
  var usernameController = TextEditingController();

  updateUsername() async {
    final newUsername = usernameController.text;

    // GET CURRENT USER DATA
    Map<String, dynamic> currentUserData =
        jsonDecode(prefs.getString(currentLoginUsername));
    currentUserData['username'] = newUsername;
    await prefs.setString(newUsername, jsonEncode(currentUserData));
    await prefs.remove(currentLoginUsername);

    setState(() {
      currentLoginUsername = newUsername;
    });

    Navigator.pop(context);

    Navigator.pop(context);

    alertDialog(usernameUpdateTitle, usernameUpdateDescription, context);
  }

  loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
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
            decoration: InputDecoration(
              icon: Icon(FluentIcons.person_24_filled),
              labelText: 'Username',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return usernameEmptyNull;
              } else {
                if (value == currentLoginUsername) {
                  return usernameSameAsCurrent;
                } else {
                  return checkUsernameExist(value, prefs);
                }
              }
            },
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  alertDialog(
                    usernameCofirmUpdateTitle,
                    usernameCofirmUpdateDescription,
                    context,
                    additionalActions: customTextButton(
                      context,
                      "Change",
                      () async => await updateUsername(),
                    ),
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
