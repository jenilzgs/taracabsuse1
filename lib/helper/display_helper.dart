import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/responsive_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

void customPrint(String message) {
  if(kDebugMode) {
    print(message);
  }
}

void showCustomSnackBar(String message, {bool isError = true, bool getXSnackBar = false, int seconds = 3}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall).copyWith(
      right: ResponsiveHelper.isDesktop ? Get.context!.width*0.7 : Dimensions.paddingSizeSmall,
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
    content: Text(message, style: textMedium.copyWith(color: Colors.white)),
  ));
}
