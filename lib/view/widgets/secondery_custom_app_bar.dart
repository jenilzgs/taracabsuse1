import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class SecondaryCustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const SecondaryCustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
      title: Text(title.tr, style: textSemiBold.copyWith(
        fontSize: Dimensions.fontSizeLarge,
        color: Theme.of(context).primaryColor,
      ),maxLines: 2,textAlign: TextAlign.center,),

      centerTitle: true,
      excludeHeaderSemantics: true,
      leading:  Padding(
        padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSeven),
        child: GestureDetector(
          onTap: ()=> Get.back(),
          child: Card(
            child: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          ),
        ),
      ) ,

      elevation: 0,
    );
  }
  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 50);
}
