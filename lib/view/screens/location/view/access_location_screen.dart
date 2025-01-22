import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/pick_map_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_loader.dart';

class AccessLocationScreen extends StatelessWidget {
  const AccessLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'set_location'.tr),
        body: Center(child: GetBuilder<LocationController>(builder: (locationController) {
          return SizedBox(width: 700, child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(Images.mapLocationIcon, height: 240),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Text(
                  'find_driver_near_you'.tr,
                  textAlign: TextAlign.center,
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge, color:Get.isDarkMode ? Theme.of(context).primaryColorLight
                      : Theme.of(context).colorScheme.primary,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Text(
                    'please_select_you_location_to_start_finding_available_driver_near_you'.tr,
                    textAlign: TextAlign.center,
                    style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color:Get.isDarkMode ? Theme.of(context).primaryColorLight : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                const BottomButton(),

              ],
            ),
          ));
        })),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SizedBox(width: MediaQuery.of(context).size.width-40, child: Column(children: [

      CustomButton(
        buttonText: 'use_current_location'.tr,
        fontSize: Dimensions.fontSizeSmall,
        onPressed: () async {
          if(GetPlatform.isIOS) {
            saveAndNavigate();
          }else{
            Get.find<LocationController>().checkPermission(() async {
              saveAndNavigate();
            });
          }
        }, icon: Icons.my_location,
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      CustomButton(buttonText: 'set_from_map'.tr,
        fontSize: Dimensions.fontSizeSmall,
        onPressed: ()=> Get.to(() =>  const PickMapScreen( type: LocationType.accessLocation)),
      ),
      const SizedBox(height: Dimensions.paddingSizeSmall),

    ])));
  }

  void saveAndNavigate() async {
    Get.dialog(const CustomLoader(), barrierDismissible: false);
    Address? address = await Get.find<LocationController>().getCurrentLocation();
    if(address != null) {
      await Get.find<LocationController>().saveUserAddress(address);
      Get.find<BottomMenuController>().navigateToDashboard();
    }
  }

}

