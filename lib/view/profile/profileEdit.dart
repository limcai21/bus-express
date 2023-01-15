import 'package:flutter/material.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/profile/settings/changeContactNumber.dart';
import 'package:bus_express/view/profile/settings/changeEmail.dart';
import 'package:bus_express/view/profile/settings/changePassword.dart';

class ProfileEditForm extends StatelessWidget {
  String title;
  String subtitle;
  int index;
  ProfileEditForm(this.title, this.subtitle, this.index);

  @override
  Widget build(BuildContext context) {
    List pages = [ChangeEmail(), ChangePassword(), ChangeContactNumber()];

    return CustomScaffold(
      title,
      subtitle,
      Container(
        padding: const EdgeInsets.all(20),
        child: pages[index],
      ),
    );
  }
}
