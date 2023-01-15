import 'package:flutter/material.dart';

alertDialog(
  String title,
  description,
  context, {
  TextButton additionalActions,
  String closeTitle = 'CLOSE',
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 3, 20, 20),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: <Widget>[
          additionalActions,
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
            child: Text(
              closeTitle.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
