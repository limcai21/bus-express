import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alertDialog.dart';
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
    var currentUserData = prefs.getStringList(currentLoginUsername);
    final password = currentUserData[0];
    final contactNumber = currentUserData[2];
    prefs.setStringList(
        currentLoginUsername, <String>[password, newEmail, contactNumber]);
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
    currentUserEmail = prefs.getStringList(currentLoginUsername)[1].toString();
    setState(() {
      currentUserEmail = currentUserEmail;
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
              icon: Icon(Icons.email_rounded),
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
