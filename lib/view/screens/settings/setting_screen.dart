import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/language_model.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/reset_password_screen.dart';
import 'package:ride_sharing_user_app/view/screens/settings/widget/theme_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'settings'.tr, showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Row(children: [
                  Image.asset(Images.languageSetting,scale: 2),
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  Text('language'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                ]),

                GetBuilder<LocalizationController>(builder: (localizationController) {
                  return DropdownButton<Locale>(
                    isDense: true,
                    style: textMedium.copyWith(color: Theme.of(context).primaryColor),
                    value: localizationController.locale,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    elevation: 1,
                    selectedItemBuilder: (context) {
                      return AppConstants.languages.map<Widget>((LanguageModel language) {
                        return Center(child: Text(
                          language.languageName,
                          style: textRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                        ));
                      }).toList();
                    },
                    items: AppConstants.languages.map((LanguageModel language) {
                      return DropdownMenuItem<Locale>(
                        value: Locale(language.languageCode, language.countryCode),
                        child: Text(language.languageName.tr, style: textRegular.copyWith(
                          color: localizationController.locale.languageCode == language.languageCode
                            ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                      );
                    }).toList(),
                    onChanged: (Locale? newValue) {
                      Get.find<LocalizationController>().setLanguage(newValue!);
                    },
                  );
                }),

              ]),
            ),

            ListTile(
              title: Text('theme'.tr,style: textRegular.copyWith()),
              leading: Image.asset(Images.themeLogo, width: 20),
            ),

            GetBuilder<ThemeController>(builder: (themeController) {
              return Padding(
                padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ThemeButton(isDarkTheme: false, isSelected: !themeController.darkTheme),
                  const SizedBox(width: Dimensions.paddingSizeLarge),
                  ThemeButton(isDarkTheme: true, isSelected: themeController.darkTheme),
                ]),
              );
            }),

            ListTile(
              onTap: () => Get.to(() =>  const ResetPasswordScreen(fromChangePassword: true, phoneNumber: '')),
              title: Text('change_password'.tr,style: textMedium),
              leading: Image.asset(Images.password, width: 20, height: 20, color: Theme.of(context).primaryColor),
            ),

          ]),
        ),
      ),
    );
  }
}
