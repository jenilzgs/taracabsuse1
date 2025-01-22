import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/payment/controller/payment_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class SuccessfullyReviewedScreen extends StatefulWidget {
  const SuccessfullyReviewedScreen({super.key});

  @override
  State<SuccessfullyReviewedScreen> createState() => _SuccessfullyReviewedScreenState();
}

class _SuccessfullyReviewedScreenState extends State<SuccessfullyReviewedScreen> {
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PaymentController>(
          builder: (paymentController) {
            return CustomBody(
              appBar: CustomAppBar(title: 'thanks_for_your_review'.tr,),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [

                    SizedBox(height: Get.height/6,),
                    Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(.125),
                            borderRadius: BorderRadius.circular(100)
                        ),child: SizedBox(width: 50,child: Image.asset(paymentController.reviewTypeList[paymentController.reviewTypeSelectedIndex].icon!))),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),
                    Text('${'you_are'.tr} ${paymentController.reviewTypeList[paymentController.reviewTypeSelectedIndex].title!.tr}',
                      style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),

                    const SizedBox(height: Dimensions.paddingSizeDefault,),
                    Text('review_submitted_successful'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor))
                  ],),
                ),),
            );
          }
      ),

      bottomNavigationBar: Container(height: 90,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: CustomButton(buttonText: 'home'.tr, onPressed: (){
            Get.find<RideController>().resetControllerValue();
            Get.find<BottomMenuController>().navigateToDashboard();
          }),
        ),),

    );
  }
}






