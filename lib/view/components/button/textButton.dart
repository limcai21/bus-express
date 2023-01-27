import 'package:bus_express/model/constants.dart';
import 'package:bus_express/view/profile/company/components/contactFunctions.dart';
import 'package:flutter/material.dart';

customTextButton(context, String title, Function onPress) {
  return TextButton(
    onPressed: onPress,
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(
        Color.lerp(Colors.white, primaryColor, 0.1),
      ),
    ),
    child: Text(
      title.toUpperCase(),
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
  );
}

feedbackTextButton(String emailSubject, context) {
  return customTextButton(
    context,
    "Feedback",
    () => launchEmail(
      companyFeedbackEmail,
      emailSubject,
    ),
  );
}
