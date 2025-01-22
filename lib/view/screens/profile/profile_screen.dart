import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/html/html_viewer_screen.dart';
import 'package:ride_sharing_user_app/view/screens/trip/trip_screen.dart';
import 'package:ride_sharing_user_app/view/screens/address/my_address.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/coupon_screen.dart';
import 'package:ride_sharing_user_app/view/screens/message/message_list.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/widgets/profile_item.dart';
import 'package:ride_sharing_user_app/view/screens/settings/setting_screen.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/screens/support/support_screen.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/wallet_screen.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(builder: (profileController) {
        return CustomBody(
          appBar: CustomAppBar(title: 'profile'.tr,showBackButton: false),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children:  [
              Stack(clipBehavior: Clip.none, children: [
                Container(height: 175, width: Get.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                color:Get.isDarkMode? Theme.of(context).scaffoldBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: Row( children: [
                        Container(decoration: BoxDecoration(shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1)),
                          child: ClipRRect(borderRadius: BorderRadius.circular(50),
                            child:  CustomImage(height: 70, width: 70,
                            image: profileController.profileModel?.data?.profileImage != null?
                            '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImage}/${profileController.profileModel?.data?.profileImage??''}':'',
                            placeholder: Images.personPlaceholder, fit: BoxFit.contain))),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(profileController.customerName(), style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                          Row(children: [
                            Text("${'level'.tr} : ${ profileController.profileModel?.data!.level?.name??'0'}",
                              style: textBold.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(width: 5),
                            SizedBox(width: 15, height : 15, child: CustomImage(image: "${AppConstants.baseUrl}/storage/app/public/customer/level/${profileController.profileModel?.data!.level?.image}"))
                          ]),

                          Row(children: [
                            Text('${"your_rating".tr} :'.tr,
                              style: textBold.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                            Text(profileController.profileModel?.data!.userRating??"0",
                              style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,letterSpacing: 3,
                                color: Theme.of(context).hintColor)),
                            const Icon(Icons.star,size: 12,color: Colors.amber),
                          ]),
                      ]),


                    ]),
                  ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _buildColumnItem('total_ride','${profileController.profileModel?.data?.totalRideCount??0}', context),
                      Container(width: 1,height: 40,color: Theme.of(context).primaryColor),
                      _buildColumnItem('total_point','${profileController.profileModel?.data?.loyaltyPoints??0}', context),
                    ]),

                ]),
                  ),

                Positioned(child: Align(alignment: Alignment.topRight, child: InkWell(
                    onTap: () => Get.to(() => const EditProfileScreen()),
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(width: 20,child: Image.asset(Images.editIcon))),
                )))

                ]),

                ProfileMenuItem(title: 'profile', icon: Images.profileProfile,
                  onTap: () => Get.to(() => const EditProfileScreen())),

                ProfileMenuItem(title: 'my_address', icon: Images.location,
                  onTap: () => Get.to(() => const MyAddressScreen())),

                ProfileMenuItem(title: 'message', icon: Images.profileMessage,
                  onTap: () => Get.to(() => const MessageListScreen())),

                ProfileMenuItem(title: 'my_wallet', icon: Images.profileMyWallet,
                  onTap: () => Get.to(() => const WalletScreen())),

                ProfileMenuItem(title: 'coupon', icon: Images.paymentAndVoucher,
                  onTap: () => Get.to(() => const CouponScreen())),

                ProfileMenuItem(title: 'my_trips', icon: Images.profileMyTrip,
                  onTap: () => Get.to(() => const TripScreen(fromProfile: true))),

                ProfileMenuItem(title: 'help_support', icon: Images.profileHelpSupport,
                  onTap: () => Get.to(() => const HelpAndSupportScreen())),

                ProfileMenuItem(title: 'settings', icon: Images.profileSetting,
                  onTap: () => Get.to(() => const SettingScreen())),


                ProfileMenuItem(title: 'privacy_policy', icon: Images.privacyPolicy,
                    onTap: () => Get.to(() =>  HtmlViewerScreen(isPolicy: true, image: Get.find<ConfigController>().config?.privacyPolicy?.image??'',))),

                ProfileMenuItem(title: 'terms_and_condition', icon: Images.termsAndCondition,
                    onTap: () => Get.to(() =>  HtmlViewerScreen(image: Get.find<ConfigController>().config?.termsAndConditions?.image??''))),

                ProfileMenuItem(title: 'legal', icon: Images.privacyPolicy,
                    onTap: () => Get.to(() =>  HtmlViewerScreen(isLegal: true, image: Get.find<ConfigController>().config?.legal?.image??''))),


                ProfileMenuItem(title: 'logout', icon: Images.profileLogout, divider: false,
                  onTap: () {showDialog(context: context, builder: (_) {
                    return ConfirmationDialog(
                      icon: Images.profileLogout,
                      description: 'do_you_want_to_log_out_this_account'.tr, onYesPressed: () {
                      Get.find<AuthController>().logOut();

                        },
                      );
                    });
                  },
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge * 4),

              ]),
            ),
          );
        }),
      );
  }

  Column _buildColumnItem(String title,String value,BuildContext context) {
    return Column(children: [
      Text(value,style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeExtraLarge)),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      Text(title.tr,style: textMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
    ]);
  }

}




