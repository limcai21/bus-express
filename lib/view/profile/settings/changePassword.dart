import 'dart:convert';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final retypeNewPasswordController = TextEditingController();
  bool isCurrentPasswordCorrect = false;
  String currentPassword = "";
  var prefs;

  checkCurrentPasswordForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: currentPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(FluentIcons.lock_closed_24_regular),
              hintText: '',
              labelText: 'Current Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return currentPasswordEmptyNull;
              } else if (currentPassword != value) {
                return currentPasswordIncorrect;
              }
              return null;
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState.validate()) {
                  setState(() {
                    isCurrentPasswordCorrect = true;
                  });
                }
              },
              child: Text('Next'),
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

  changePasswordForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: newPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(FluentIcons.lock_closed_24_filled),
              hintText: '',
              labelText: 'New Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return newPasswordEmptyNull;
              } else if (newPasswordController.text !=
                  retypeNewPasswordController.text) {
                return newPasswordAndRetypeNewPasswordDifferent;
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: retypeNewPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              icon: Icon(FluentIcons.lock_closed_24_filled),
              hintText: '',
              labelText: 'Retype New Password',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return retpyeNewPasswordEmptyNull;
              } else if (newPasswordController.text !=
                  retypeNewPasswordController.text) {
                return newPasswordAndRetypeNewPasswordDifferent;
              }
              return null;
            },
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  await updatePassword();
                  await alertDialog(
                    passwordChangedTitle,
                    passwordChangedDescription,
                    context,
                  );
                }
              },
              child: Text('Change Password'),
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

  loadPageData() async {
    prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> userData =
        jsonDecode(prefs.getString(currentLoginUsername));
    setState(() {
      currentPassword = userData['password'];
    });
  }

  updatePassword() async {
    final newPassword = newPasswordController.text;

    setState(() {
      isUserLogin = false;
    });

    // GET CURRENT USER DATA
    Map<String, dynamic> currentUserData =
        jsonDecode(prefs.getString(currentLoginUsername));
    currentUserData['password'] = newPassword;
    await prefs.setString(currentLoginUsername, jsonEncode(currentUserData));
    print("updated password");

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadPageData();
  }

  @override
  Widget build(BuildContext context) {
    return isCurrentPasswordCorrect
        ? changePasswordForm()
        : checkCurrentPasswordForm();
  }
}
