import 'package:flutter/material.dart';

import '../../custom_icons_icons.dart';

class CustomScaffold extends StatelessWidget {
  String title;
  String subtitle;
  Widget body;
  List<Widget> actionBtn;

  CustomScaffold(this.title, this.subtitle, this.body, {this.actionBtn});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(CustomIcons.arrow_left),
        //   onPressed: () => Navigator.pop(context),
        // ),
        elevation: 0,
        actions: actionBtn,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            color: Theme.of(context).primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[300]),
                )
              ],
            ),
          ),
          body,
        ],
      ),
    );
  }
}
