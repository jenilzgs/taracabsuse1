import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/onboard/onboarding_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<ConfigController>(
          builder: (configController) {
            return CustomBody(
                appBar: CustomAppBar(title: 'maintenance'.tr, showBackButton: false, centerTitle: true),
                body: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                    Image.asset(Images.maintenance, width: 200, height: 200),

                    Text('maintenance_mode'.tr, style: textMedium.copyWith(fontSize: 20, color: Theme.of(context).textTheme.bodyLarge!.color,)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text('maintenance_text'.tr, textAlign: TextAlign.center, style: textRegular,),

                    configController.loading? Center(child: Padding(
                      padding: EdgeInsets.only(top: Get.width/5),
                      child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,),
                    )):
                    Padding(padding: EdgeInsets.all(Get.width/5),
                      child: CustomButton(buttonText: 'retry'.tr, onPressed: () async{

                        await Get.find<ConfigController>().getConfigData().then((value){

                          if(Get.find<ConfigController>().config!.maintenanceMode != null && Get.find<ConfigController>().config!.maintenanceMode!){
                            showCustomSnackBar('try_few_minute_latter'.tr);
                          }else{
                            if(Get.find<AuthController>().isLoggedIn()) {
                              if(Get.find<LocationController>().getUserAddress() != null
                                  && Get.find<LocationController>().getUserAddress()!.address != null
                                  && Get.find<LocationController>().getUserAddress()!.address!.isNotEmpty) {

                                Get.find<ProfileController>().getProfileInfo().then((value) {
                                  if(value.statusCode == 200) {
                                    Get.find<AuthController>().updateToken();
                                    if(value.body['data']['is_profile_verified'] == 1) {
                                      Get.offAll(()=> const DashboardScreen());
                                     Get.find<RideController>().getCurrentRideStatus();
                                    }else {
                                      Get.offAll(() => const EditProfileScreen(fromLogin: true));
                                    }
                                  }
                                });

                              }else{
                                Get.offAll(() => const AccessLocationScreen());
                              }

                            }else{
                              if (Get.find<ConfigController>().showIntro()) {
                                Get.offAll(() => const OnBoardingScreen());
                              } else {
                                Get.offAll(() => const SignInScreen());
                              }
                            }
                          }

                        });
                      },),
                    )

                  ]),
                ));
          }
        ));
  }
}
