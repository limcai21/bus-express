import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/components/loadingAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      'Sign Up',
      'Save all you favourite bus stop',
      SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  var prefs;

  checkUsernameExist(String username) {
    final List<String> checkUsername = prefs.getStringList(username);
    if (checkUsername != null) {
      return usernameExist;
    } else {
      return null;
    }
  }

  checkRetypePasswordAndPasswordAreSame() {
    final password =
        passwordController.text != null ? passwordController.text : "";
    final retypePassword = retypePasswordController.text != null
        ? retypePasswordController.text
        : "";
    if (password != retypePassword) {
      return passwordAndRetypePasswordDifferent;
    }
  }

  registerUser() async {
    loadingAlert(context);

    final username = usernameController.text;
    final email = emailController.text;
    final contactNumber = contactNumberController.text;
    final password = passwordController.text;

    if (checkUsernameExist(username) != usernameExist) {
      await prefs
          .setStringList(username, <String>[password, email, contactNumber]);
    } else {
      print("exist");
    }

    // REMOVE LOADING
    Navigator.pop(context);

    // GO TO PREVIOUS SCREEN
    Navigator.pop(context);
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
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.person_rounded),
                  labelText: 'Username',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return usernameEmptyNull;
                  } else {
                    return checkUsernameExist(value);
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(Icons.email_rounded),
                  labelText: 'Email',
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
              TextFormField(
                controller: contactNumberController,
                keyboardType: TextInputType.phone,
                maxLength: contactNumberMaxLength,
                decoration: InputDecoration(
                  icon: Icon(Icons.phone_rounded),
                  labelText: 'Contact Number',
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
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_rounded),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return passwordEmptyNull;
                  } else {
                    return checkRetypePasswordAndPasswordAreSame();
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: retypePasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_rounded),
                  labelText: 'Retype Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return retpyePasswordEmptyNull;
                  } else {
                    return checkRetypePasswordAndPasswordAreSame();
                  }
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    await registerUser();
                    await alertDialog(
                      "Completed!",
                      'Sign up successfully.\nYou can now sign in',
                      context,
                    );
                  }
                },
                child: Text('Sign Up'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
