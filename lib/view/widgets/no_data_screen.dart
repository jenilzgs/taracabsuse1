import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';



class NoDataScreen extends StatelessWidget {
  final String? title;
  const NoDataScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Image.asset(Images.noDataFound, width: 100, height: 100, color: Theme.of(context).primaryColor),

            Text(title != null? title!.tr : 'no_data_found'.tr,
                style: textRegular.copyWith(color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center)])));
  }
}
