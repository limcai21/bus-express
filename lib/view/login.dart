import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      "Login",
      "Sign in to see all your saved bus stops",
      LoginForm(),
      2,
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var prefs;

  checkUsernameAndPassword() async {
    final prefs = await SharedPreferences.getInstance();

    final username = usernameController.text;
    final password = passwordController.text;

    final List<String> getUserData = prefs.getStringList(username);
    if (getUserData != null) {
      final checkPassowrd = getUserData[0];

      if (password != checkPassowrd) {
        alertDialog(loginFailTitle, loginFailDescription, context);
      } else {
        print("login successful");
        setState(() {
          isUserLogin = true;
          currentLoginUsername = username;
        });
        Navigator.pop(context);
      }
    } else {
      alertDialog(loginFailTitle, loginFailDescription, context);
    }
  }

  @override
  void initState() {
    super.initState();
    loadPageData();
  }

  loadPageData() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                icon: Icon(CustomIcons.profile_filled),
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Username';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(CustomIcons.lock_filled),
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState.validate()) {
                  checkUsernameAndPassword();
                }
              },
              child: Text('Login'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
