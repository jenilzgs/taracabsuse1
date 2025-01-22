import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/model/coupon_model.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class CouponWidget extends StatelessWidget {
  final Coupon coupon;
  const CouponWidget({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return InkWell(

      child: Padding(
        padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault,0),
        child: SizedBox(
          height: 150,
          width: Get.width,
          child: Stack(children: [


              Container(decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                child: Center(child: Padding(padding: const EdgeInsets.fromLTRB( Dimensions.paddingSizeSignUp, 0, Dimensions.paddingSizeSignUp, Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    SizedBox(width: Dimensions.couponIconSize, child: Image.asset(Images.coupon)),

                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeDefault),
                      child: DottedLine(direction: Axis.vertical,
                        lineLength: double.infinity,
                        lineThickness: 5.0,
                        dashLength: 7.0,
                        dashColor: Theme.of(context).hintColor.withOpacity(.25),
                        dashRadius: 0.0,
                        dashGapLength: 7.0,
                        dashGapColor: Colors.transparent,
                        dashGapRadius: 0.0)),

                      Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Column(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('${coupon.coupon} %OFF', style: textBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).textTheme.bodySmall!.color),),
                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            child: Text(coupon.name!, style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor))),

                          Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                              child: Text('${'code'.tr} : ${coupon.couponCode!}', style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).primaryColor))),
                          Text('${'expire_date'.tr}: ${coupon.endDate}', style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                        ]))),
                    ],),
                  )),
              ),


              Positioned(top: -5,right: Get.find<LocalizationController>().isLtr ? 15 : null, left: Get.find<LocalizationController>().isLtr? null : 15, child: Align(alignment: Alignment.topRight,
                  child: SizedBox(width: 70, child: CustomButton(height: 30,buttonText: 'copy'.tr,
                      onPressed: () async{
                    await Clipboard.setData(ClipboardData(text: coupon.couponCode!)).then((value) {
                      showCustomSnackBar('${'coupon_code_copied_successfully'.tr} ${coupon.couponCode}', isError: false);
                    });
                  })))),


            Positioned(top: 60,left: -18,
                child: Container(width: 35, height : 35,decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(100)
                ),)),
            Positioned(top: 60,right: -18,
                child: Container(width: 35, height : 35,decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(100)
                ),)),




            ],
          ),
        ),
      ),
    );
  }
}
