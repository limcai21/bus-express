import 'package:flutter/material.dart';

alertSimpleDialog(String title, List<Widget> children, context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        title: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        children: children,
      );
    },
  );
}
