import 'package:bus_express/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeContactNumber extends StatefulWidget {
  @override
  State<ChangeContactNumber> createState() => _ChangeContactNumberState();
}

class _ChangeContactNumberState extends State<ChangeContactNumber> {
  final formKey = GlobalKey<FormState>();
  String currentContactNumber = "";
  var contactNumberController = TextEditingController();
  var prefs;

  updateContactNumber() {
    final newContactNumber = contactNumberController.text;

    // GET CURRENT USER DATA
    var currentUserData = prefs.getStringList(currentLoginUsername);
    final password = currentUserData[0];
    final email = currentUserData[1];
    prefs.setStringList(
        currentLoginUsername, <String>[password, email, newContactNumber]);
    print("updated contact number");

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    loadPageData();
  }

  loadPageData() async {
    prefs = await SharedPreferences.getInstance();
    currentContactNumber =
        prefs.getStringList(currentLoginUsername)[2].toString();
    setState(() {
      currentContactNumber = currentContactNumber;
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
            controller: contactNumberController,
            keyboardType: TextInputType.phone,
            maxLength: contactNumberMaxLength,
            decoration: InputDecoration(
              icon: Icon(CustomIcons.mobile_phone),
              helperText: 'e.g: 912345678',
              labelText: 'Contact Number',
              hintText: currentContactNumber,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return contactNumberEmptyNull;
              } else if (!RegExp(contactNumberRegex).hasMatch(value)) {
                return contactNumberInvalid;
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
                  await updateContactNumber();
                  alertDialog(
                    contactNumberUpdateTitle,
                    contactNumberUpdateDescription,
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
