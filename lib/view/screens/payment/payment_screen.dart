import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/controller/coupon_controller.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/payment/controller/payment_controller.dart';
import 'package:ride_sharing_user_app/view/screens/payment/digital_payment_screen.dart';
import 'package:ride_sharing_user_app/view/screens/payment/widget/apply_coupon.dart';
import 'package:ride_sharing_user_app/view/screens/payment/widget/digital_card_payment_widget.dart';
import 'package:ride_sharing_user_app/view/screens/payment/widget/payment_type_item_widget.dart';
import 'package:ride_sharing_user_app/view/screens/payment/widget/tips_widget.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class PaymentScreen extends StatefulWidget {
  final bool fromParcel;
  const PaymentScreen({super.key,  this.fromParcel = false});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool collapsed = false;

  @override
  void initState() {
    super.initState();
    Get.find<PaymentController>().initPayment();
    Get.find<PaymentController>().setPaymentByName(Get.find<RideController>().tripDetails?.paymentMethod??'cash');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) async {
        Get.find<BottomMenuController>().navigateToDashboard();
        return;
      },
      child: Scaffold(
        body: GetBuilder<PaymentController>(builder: (paymentController) {
          return GetBuilder<RideController>(builder: (rideController) {

            String firstRoute = '';
            String secondRoute = '';
            List<dynamic> extraRoute = [];
            if(rideController.tripDetails?.intermediateAddresses != null && rideController.tripDetails?.intermediateAddresses != '["",""]'){
              extraRoute = jsonDecode(rideController.tripDetails!.intermediateAddresses!);

              if(extraRoute.isNotEmpty) {
                firstRoute = extraRoute[0];
              }
              if(extraRoute.isNotEmpty && extraRoute.length > 1) {
                secondRoute = extraRoute[1];
              }

            }
            return CustomBody(
              appBar: CustomAppBar(title: 'here_is_your_payment'.tr,
                onBackPressed: () => Get.find<BottomMenuController>().navigateToDashboard()),
              body: GetBuilder<CouponController>(builder: (couponController) {
                return SingleChildScrollView(child: Column(children: [

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Text('payment'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                      Container(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeThree),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall)),
                        child: Row(children: [
                          Text(paymentController.paymentType.tr, style: textMedium.copyWith(color: Theme.of(context).primaryColor)),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(Images.cash))]))])),

                  Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    Text('this_trip_is'.tr),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    if(rideController.finalFare != null && rideController.finalFare!.currentStatus != null)
                    Text(rideController.finalFare!.currentStatus!.capitalize!, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor))]),

                  (rideController.finalFare != null)?
                  Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                    child: Text(PriceConverter.convertPrice(rideController.finalFare!.paidFare! + double.parse(paymentController.tipAmount)),
                      style: textSemiBold.copyWith(fontSize: Dimensions.fontSizeOverLarge,
                        color: Theme.of(context).textTheme.bodyMedium!.color))) : const SizedBox(),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('your'.tr, style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('total_fare'.tr, style: textSemiBold.copyWith(color: Theme.of(context).primaryColor)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    Text('for_this_trip'.tr, style: textMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color))]),


                  Row(crossAxisAlignment: paymentController.paymentTypeIndex == 2 ? CrossAxisAlignment.end:CrossAxisAlignment.center, children: [
                    Expanded(child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentController.paymentTypeList.length,
                      itemBuilder: (context, index){
                        return PaymentTypeItem(
                          title: paymentController.paymentTypeList[index],
                          index: index,
                          selectedIndex: paymentController.paymentTypeIndex,
                        );})),


                    paymentController.paymentTypeIndex == 1 ? InkWell(
                      onTap: () => showDialog(context: context, builder: (_) => const TipsWidget()),
                      child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Container(decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.35),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),),
                          child: Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.iconSizeSmall, vertical: Dimensions.paddingSizeSmall),
                            child: Text((paymentController.tipAmount == '0' || paymentController.tipAmount.isEmpty) ?
                            'add_tips'.tr : '${'tips'.tr}: ${PriceConverter.convertPrice(double.parse(paymentController.tipAmount))}',
                              style: textSemiBold.copyWith(color: Theme.of(context).primaryColorDark),
                            ))))),
                    ) :

                    paymentController.paymentTypeIndex == 2 ? GetBuilder<ProfileController>(builder: (profileController) {
                        return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault), child: Text.rich(
                          TextSpan(children: [TextSpan(text: '${'available'.tr}: ', style: textRegular.copyWith(color: Theme.of(context).hintColor)),
                            TextSpan(text: PriceConverter.convertPrice(profileController.profileModel!.data!.wallet!.walletBalance!),
                              style: textSemiBold.copyWith(color: Theme.of(context).hintColor))])));}) : const SizedBox()]),

                  paymentController.paymentTypeIndex == 1 ?
                  GetBuilder<ConfigController>(
                    builder: (configController) {
                      return Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                        child: SizedBox(height: 105, child: ListView.builder(
                          itemCount: configController.config?.paymentGateways?.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                            return DigitalCardPaymentWidget(
                              digitalPaymentModel: configController.config!.paymentGateways![index], index: index,
                            );
                          },
                        )),
                      );
                    }
                  ) : const SizedBox(),


                  Padding(padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault),
                    child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(initiallyExpanded: true,
                        tilePadding: collapsed? EdgeInsets.zero: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        collapsedBackgroundColor: Theme.of(context).primaryColor.withOpacity(.4),
                        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('trip_details'.tr,
                          style: textMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge))]),
                        onExpansionChanged: (bool expanded){
                        setState(() {
                          collapsed = expanded;
                        });
                        },
                        children: [
                          const SizedBox(height: Dimensions.paddingSizeSmall,),
                          if(rideController.tripDetails != null)
                          RouteWidget(totalDistance: rideController.finalFare?.actualDistance?.toString()??'0',
                            fromAddress: rideController.tripDetails!.pickupAddress!,
                            toAddress: rideController.tripDetails!.destinationAddress!,
                            extraOneAddress: firstRoute,
                            extraTwoAddress: secondRoute,
                            entrance:  rideController.tripDetails!.entrance ?? '')])) ),
                  
                  




                  rideController.finalFare != null ? Column(children: [
                    TripFareSummery(fromPayment: true, tripFare: rideController.finalFare!.paidFare!, fromParcel: widget.fromParcel),

                    ApplyCoupon(tripId: rideController.finalFare!.id!),
                  ]) : const SizedBox(),

                ]));
              }),
            );
          });
        }),

        bottomNavigationBar: GetBuilder<PaymentController>(builder: (paymentController) {
          return Container(color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
            height: 80,
            child:paymentController.isLoading ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) : CustomButton(
              buttonText: 'pay_now'.tr,
              onPressed: () {
                if(paymentController.paymentTypeIndex == 1 && paymentController.paymentGatewayIndex != -1) {
                  Get.to(() => DigitalPaymentScreen(
                    tripId: Get.find<RideController>().finalFare!.id!,
                    paymentMethod: paymentController.gateWay,
                    fromParcel: widget.fromParcel,
                    tips: paymentController.tipAmount,
                  ));
                } if(paymentController.paymentTypeIndex == 1 && paymentController.paymentGatewayIndex == -1){
                  showCustomSnackBar('select_payment_method'.tr);
                }else if(paymentController.paymentTypeIndex == 0 || paymentController.paymentTypeIndex == 2) {
                  if(Get.find<RideController>().finalFare != null){
                    paymentController.paymentSubmit(Get.find<RideController>().finalFare!.id!,
                      paymentController.paymentTypeList[paymentController.paymentTypeIndex],
                      fromParcel: widget.fromParcel,
                    );
                  }

                }
              },
            ),
          );
        }),
      ),
    );
  }
}





