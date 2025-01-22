import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/auth/otp_log_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_up_screen.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:ride_sharing_user_app/view/screens/html/html_viewer_screen.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();



  @override
  void initState() {
    super.initState();

    if(Get.find<AuthController>().getUserNumber().isNotEmpty) {
      phoneController.text =  Get.find<AuthController>().getUserNumber();
    }
    passwordController.text = Get.find<AuthController>().getUserPassword();

    if(passwordController.text.isNotEmpty) {
      Get.find<AuthController>().setRememberMe();
    }
    if(Get.find<ConfigController>().config!.countryCode != null){
      Get.find<AuthController>().countryDialCode = CountryCode.fromCountryCode(Get.find<ConfigController>().config!.countryCode!).dialCode!;

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [

                    Image.asset(Images.logoWithName, height: 75),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${'welcome_to'.tr} ${AppConstants.appName}',
                        style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeLarge),
                      ),
                      Image.asset(Images.hand, width: 40),
                    ])],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.06,),

                  Text(
                    'log_in'.tr,
                    style: textBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeOverLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    'log_in_message'.tr,
                    style: textMedium.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeDefault),maxLines: 2,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  CustomTextField(
                    hintText: 'phone'.tr,
                    inputType: TextInputType.phone,
                    countryDialCode: authController.countryDialCode,
                    prefixHeight: 70,
                    controller: phoneController,
                    focusNode: phoneNode,
                    nextFocus: passwordNode,
                    inputAction: TextInputAction.next,
                    onCountryChanged: (CountryCode countryCode) {
                      authController.countryDialCode = countryCode.dialCode!;
                      authController.setCountryCode(countryCode.dialCode!);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault,),
                  CustomTextField(
                    hintText: 'enter_password'.tr,
                    inputType: TextInputType.text,
                    prefixIcon: Images.lock,
                    prefixHeight: 70,
                    inputAction: TextInputAction.done,
                    isPassword: true,
                    controller: passwordController,
                    focusNode: passwordNode,
                  ),

                  Row(children: [
                    Expanded(child: ListTile(
                      onTap: () => authController.toggleRememberMe(),
                      title: Row(children: [
                        SizedBox(width: 20.0, child: Checkbox(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          value: authController.isActiveRememberMe,
                          onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                        )),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text('remember'.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      ]),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      horizontalTitleGap: 0,
                    )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgotPasswordScreen());
                        },
                        child: Text('forgot_password'.tr, style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,
                        )),
                      ),
                    ),
                  ]),

                  authController.isLoading ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) : CustomButton(
                    buttonText: 'log_in'.tr,
                    onPressed: () {
                      String phone = phoneController.text.trim();
                      String password = passwordController.text.trim();

                      if(!GetUtils.isPhoneNumber(authController.countryDialCode + phone)) {
                        showCustomSnackBar('phone_number_is_not_valid'.tr);
                      }else if(password.isEmpty) {
                        showCustomSnackBar('password_is_required'.tr);
                      }else if(password.length < 8) {
                        showCustomSnackBar('minimum_password_length_is_8'.tr);
                      }else {
                        authController.login(authController.countryDialCode, phone, password);
                      }
                    },
                    radius: 50,
                  ),

                  Row(children: [
                    const Expanded(child: Divider(thickness: .125,)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: 8),
                      child: Text('or'.tr ,style: textRegular.copyWith(color: Theme.of(context).hintColor),),
                    ),
                    const Expanded(child: Divider(thickness: .125,)),
                  ]),
                  CustomButton(
                    showBorder: true,
                    borderWidth: 1,
                    transparent: true,
                    buttonText: 'otp_login'.tr,
                    onPressed: () => Get.to(() => const OtpLoginScreen(fromSignIn: true)),
                    radius: 50,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${'do_not_have_an_account'.tr} ',
                        style: textMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).hintColor,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Get.to(() => const SignUpScreen());
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50,30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        ),
                        child: Text('sign_up'.tr, style: textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall,
                        )),
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1,),
                  InkWell(
                    onTap: ()=> Get.to(() =>  const HtmlViewerScreen()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("terms_and_condition".tr, style: textMedium.copyWith(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.fontSizeSmall,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ));
  }
}
