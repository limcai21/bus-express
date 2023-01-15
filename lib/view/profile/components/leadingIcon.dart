import 'package:flutter/material.dart';

leadingIcon(IconData icon, MaterialColor color) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      )
    ],
  );
}
