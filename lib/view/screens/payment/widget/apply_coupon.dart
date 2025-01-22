import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/localization/localization_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';

class ApplyCoupon extends StatefulWidget {
  final String tripId;
  const ApplyCoupon({super.key, required this.tripId});

  @override
  State<ApplyCoupon> createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  TextEditingController couponInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
        builder: (rideController) {
          couponInputController.text = rideController.finalFare?.coupon?.couponCode??'';
          return Padding(padding: const EdgeInsets.only(left:Dimensions.paddingSizeDefault,right:Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault),
            child: Container(height: 50, width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.9))),
              child: Row(children: [
                Expanded(child: SizedBox(height: 50,
                    child: Padding(padding:  EdgeInsets.only(left: Get.find<LocalizationController>().isLtr? Dimensions.paddingSizeSmall:0, right: Get.find<LocalizationController>().isLtr? 0 : Dimensions.paddingSizeSmall, bottom: 5),
                      child: Center(
                        child: TextField(controller: couponInputController, decoration: InputDecoration(
                            hintText: 'have_a_coupon'.tr,
                            hintStyle: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                            filled: false,
                            border: InputBorder.none,
                            enabled: rideController.finalFare?.couponAmount == 0,
                            contentPadding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall)
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                !rideController.isApplying ?
                InkWell(onTap: () {
                  if(rideController.finalFare!.couponAmount! > 0){
                    rideController.removeCoupon(widget.tripId).then((value) {
                      if(value.statusCode == 200){
                        couponInputController.clear();
                      }
                    });
                  }else{
                    if(couponInputController.text.isNotEmpty) {
                      rideController.applyCoupon(couponInputController.text.trim(), widget.tripId);
                    }
                  }
                }, child: Container(width: 100,height: 60,
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                        borderRadius:  BorderRadius.only(
                            topLeft: Get.find<LocalizationController>().isLtr?  const Radius.circular(0): const Radius.circular(Dimensions.paddingSizeExtraSmall),
                            bottomLeft: Get.find<LocalizationController>().isLtr? const Radius.circular(0):  const Radius.circular(Dimensions.paddingSizeExtraSmall),
                            bottomRight: Get.find<LocalizationController>().isLtr? const Radius.circular(Dimensions.paddingSizeExtraSmall) : const Radius.circular(0),
                            topRight: Get.find<LocalizationController>().isLtr? const Radius.circular(Dimensions.paddingSizeExtraSmall): const Radius.circular(0))),
                    child: Center(child:rideController.finalFare!.couponAmount! > 0?
                    const Icon(Icons.clear, color: Colors.white,) :
                    Text('apply'.tr, style: textRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault))))) :

                Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: SizedBox(width: 30,height: 30,child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)),
                ),
              ]),
            ),
          );
        }
    );
  }
}
