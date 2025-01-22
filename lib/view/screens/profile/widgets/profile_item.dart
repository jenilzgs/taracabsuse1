import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final Function()? onTap;
  final bool divider;
  const ProfileMenuItem({super.key, required this.title, required this.icon, this.onTap,this.divider = true});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      SizedBox(height: 50, child: ListTile(
        horizontalTitleGap: 5,
        leading: Image.asset(icon,width: 25,height: 25,fit: BoxFit.cover,color: Theme.of(context).primaryColor),
        title: Text(title.tr, style: textMedium),
        onTap: onTap,
      )),

      divider ? Divider(color: Theme.of(context).primaryColor.withOpacity(0.2),height: 16,thickness: 0.8) : const SizedBox(),

    ]);
  }
}