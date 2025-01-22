import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/controller/coupon_controller.dart';
import 'package:ride_sharing_user_app/view/screens/payment/controller/payment_controller.dart';
import 'package:ride_sharing_user_app/view/screens/payment/widget/payment_item_info.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';

class TripFareSummery extends StatelessWidget {
  final bool fromPayment;
  final bool fromParcel;
  final double? tripFare;
  const TripFareSummery({super.key, this.fromPayment = false,  this.tripFare, required this.fromParcel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<CouponController>(
        builder: (couponController) {
          return GetBuilder<PaymentController>(
            builder: (tipsController) {
              double total = 0;
              if(fromPayment) {
                 total = rideController.finalFare!.paidFare!+double.parse(tipsController.tipAmount);
              }else{
                total = rideController.tripDetails?.paidFare??0;
              }
              return Container(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  color: fromPayment? null : Theme.of(context).primaryColor.withOpacity(0.15)),
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [
                  if(!fromPayment)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Image.asset(Images.profileMyWallet,height: 15,width: 15,),
                      const SizedBox(width: Dimensions.paddingSizeSmall,),
                      Text('fare_price'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                    ]),

                    Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        color:  Theme.of(context).primaryColor.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text(PriceConverter.convertPrice(tripFare!),
                        style: textBold.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).primaryColor),),
                    )
                  ]
                  ),


                  if(fromPayment)
                    PaymentItemInfo(icon: Images.farePrice,title: 'fare_price'.tr,amount: rideController.finalFare?.distanceWiseFare??0),
                  if(fromPayment && !fromParcel)
                    PaymentItemInfo(icon: Images.idleHourIcon,title: 'cancellation_price'.tr,amount: rideController.finalFare?.cancellationFee??0),
                  if(fromPayment && !fromParcel)
                    PaymentItemInfo(icon: Images.idleHourIcon,title: 'idle_price'.tr,amount: rideController.finalFare?.idleFee??0),
                  if(fromPayment && !fromParcel)
                    PaymentItemInfo(icon: Images.waitingPrice,title: 'delay_price'.tr,amount: rideController.finalFare?.delayFee??0),
                  if(fromPayment)
                  PaymentItemInfo(icon: Images.profileMyWallet,title: 'coupon_discount'.tr,amount: rideController.finalFare?.couponAmount??0, discount: true,),
                 if(fromPayment)
                  PaymentItemInfo(icon: Images.farePrice,title: 'vat_tax'.tr,amount: rideController.finalFare?.vatTax??0),
                  if(fromPayment && !fromParcel)
                    PaymentItemInfo(icon: Images.farePrice,title: 'tips'.tr,amount: double.parse(tipsController.tipAmount)),

                  if(fromPayment)
                  PaymentItemInfo(title: 'sub_total'.tr, amount: total, isSubTotal: true,),

                  if(!fromPayment)
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  if(!fromPayment)
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Expanded(
                      child: Row(children: [
                        Image.asset(Images.profileMyWallet,height: 15,width: 15,),
                        const SizedBox(width: Dimensions.paddingSizeSmall,),
                        Text('payment'.tr,style: textRegular.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeDefault),),
                      ]),
                    ),
                    GetBuilder<PaymentController>(
                      builder: (paymentController) {
                        return SizedBox(width: 170, child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                          child: DropdownButton<String>(
                            value: paymentController.paymentTypeIndex == 0 ? 'cash' :paymentController.paymentTypeIndex == 1 ? 'digital':'wallet',
                            items: paymentController.paymentTypeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.tr, style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                              );
                            }).toList(),
                            onChanged: (value) {
                              paymentController.setPaymentType(value == 'cash' ? 0 :value == 'digital' ? 1:2);
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ));
                      }
                    )],
                  ),
                ]),
              );
            }
          );
        }
      );
    });
  }
}
