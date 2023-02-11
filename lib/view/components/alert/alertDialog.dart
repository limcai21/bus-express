import 'package:bus_express/model/constants.dart';
import 'package:flutter/material.dart';

alertDialog(
  String title,
  description,
  context, {
  TextButton additionalActions,
  String closeTitle = 'CLOSE',
  bool closeTwice = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: [
          additionalActions,
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              overlayColor: MaterialStateProperty.all(
                Color.lerp(Colors.white, primaryColor, 0.9),
              ),
            ),
            child: Text(
              closeTitle.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (closeTwice) Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
