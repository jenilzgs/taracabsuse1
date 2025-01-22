import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showActionButton;
  final Function()? onBackPressed;
  final bool centerTitle;
  final double? fontSize;
  final bool isHome;
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle= false,
    this.showActionButton= true,  
    this.isHome = false,
    this.fontSize});

  @override
  Widget build(BuildContext context) {

    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: isHome ? () => Get.to(() => const AccessLocationScreen()) : null,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [


            Text(title.tr, style: textRegular.copyWith(
              fontSize: fontSize ?? (isHome ?  Dimensions.fontSizeLarge : Dimensions.fontSizeLarge),
              color: Colors.white), maxLines: 1,textAlign: TextAlign.start, overflow: TextOverflow.ellipsis),




            isHome ? GetBuilder<LocationController>(builder: (locationController) {
              return Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                child: Row(children:  [const Icon(Icons.place_outlined,color: Colors.white, size: 20),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: Text(locationController.getUserAddress()?.address ?? '', maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall)))]));}) : const SizedBox.shrink()
          ]),
        ),

        centerTitle: centerTitle,
        excludeHeaderSemantics: true,
        titleSpacing: 0,
        leading: showBackButton ? IconButton(icon: const Icon(Icons.arrow_back),
          color: Colors.white, onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),) :


        SizedBox(child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Image.asset(Images.icon))),
        elevation: 0));
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 150);
}