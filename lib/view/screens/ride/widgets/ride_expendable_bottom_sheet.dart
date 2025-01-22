import 'dart:convert';

import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/ride_category.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/trip_fare_summery.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_swipable_button/swipeable_button_view.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_text_field.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/contact_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/fare_input_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/finding_rider_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/otp_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/view/screens/payment/payment_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/rise_fare_widget.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class RideExpendableBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const RideExpendableBottomSheet({super.key, required this.expandableKey});

  @override
  State<RideExpendableBottomSheet> createState() => _RideExpendableBottomSheetState();
}

class _RideExpendableBottomSheetState extends State<RideExpendableBottomSheet> {
  bool isFinished = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (carRideController) {
      return Container(width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Theme.of(context).canvasColor,
          borderRadius : const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.paddingSizeDefault),
            topRight : Radius.circular(Dimensions.paddingSizeDefault),),
          boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2))],),

          child: Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child : Column(mainAxisSize: MainAxisSize.min, children: [
                Container(height: 7, width: 70,
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  )),

                const Padding(padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
                ),
                GetBuilder<RideController>(builder: (rideController) {
                  return GetBuilder<LocationController>(builder: (locationController) {

                    String firstRoute = '';
                    String secondRoute = '';
                    List<dynamic> extraRoute = [];
                    if(rideController.tripDetails?.intermediateAddresses != null && rideController.tripDetails?.intermediateAddresses != '["",""]') {
                      extraRoute = jsonDecode(rideController.tripDetails!.intermediateAddresses!);
                      if(extraRoute.isNotEmpty) {
                        firstRoute = extraRoute[0].toString();
                      }
                      if(extraRoute.isNotEmpty && extraRoute.length > 1) {
                        secondRoute = extraRoute[1].toString();
                      }
                    }

                    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Column(mainAxisSize: MainAxisSize.min, children:  [

                        (rideController.currentRideState == RideState.initial) ? Column(mainAxisSize: MainAxisSize.min, children:  [

                          const RideCategoryWidget(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          RouteWidget(
                            totalDistance: rideController.fareList[rideController.rideCategoryIndex].estimatedDistance!,
                            fromAddress: locationController.fromAddress!.address!,
                            extraOneAddress: locationController.extraRouteAddress?.address ?? '',
                            extraTwoAddress: locationController.extraRouteTwoAddress?.address ?? '',
                            toAddress: locationController.toAddress!.address!,
                            entrance: locationController.entranceController.text,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          TripFareSummery(tripFare: rideController.estimatedFare, fromParcel: false),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomTextField(
                            prefix: false,
                            borderRadius: Dimensions.radiusSmall,
                            hintText: "add_note".tr,
                            controller: rideController.noteController,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          (Get.find<ConfigController>().config!.bidOnFare! )?
                          FareInputWidget(expandableKey: widget.expandableKey,
                            fromRide: true, fare: rideController.estimatedFare.toString(),
                          ) : rideController.isLoading ? SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0) :
                          rideController.isSubmit ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) :
                          CustomButton(buttonText: "find_rider".tr, onPressed: () {
                            rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
                              if(value.statusCode == 200) {
                                rideController.updateRideCurrentState(RideState.findingRider);
                                Get.find<MapController>().notifyMapController();
                              }
                            });
                          }),
                        ]) :

                        (rideController.currentRideState == RideState.riseFare) ? Column(children: [
                          TollTipWidget(title: 'trip_details'.tr),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          RouteWidget(
                            totalDistance: rideController.estimatedDistance,
                            fromAddress: locationController.fromAddress!.address!,
                            extraOneAddress: locationController.extraRouteAddress?.address ?? '',
                            extraTwoAddress: locationController.extraRouteTwoAddress?.address ?? '',
                            toAddress: locationController.toAddress!.address!,
                            entrance: locationController.entranceController.text),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                           RiseFareWidget(expandableKey: widget.expandableKey, fromPage: RiseFare.ride),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                        ]) :

                        (rideController.currentRideState == RideState.findingRider) ? const FindingRiderWidget(
                          fromPage: FindingRide.ride) :

                        (rideController.currentRideState == RideState.afterAcceptRider) ?rideController.tripDetails != null?
                        Column(children: [
                          TollTipWidget(title: 'rider_details'.tr),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),

                          ContactWidget(driverId: rideController.tripDetails?.driver?.id??'0',),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),

                          const ActivityScreenRiderDetails(),

                          const SizedBox(height: Dimensions.paddingSizeDefault,),

                          const EstimatedFareAndDistance(),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),


                          if(rideController.tripDetails != null)
                          RouteWidget(totalDistance: rideController.estimatedDistance,
                            fromAddress: rideController.tripDetails!.pickupAddress!,
                            toAddress: rideController.tripDetails!.destinationAddress!,
                            extraOneAddress: firstRoute,
                            extraTwoAddress: secondRoute,
                            entrance:  rideController.tripDetails!.entrance??''),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          if(rideController.tripDetails != null && rideController.tripDetails!.type == 'ride_request' && !rideController.tripDetails!.isPaused!)
                          Center(
                            child: SwipeableButtonView(
                              buttonText: 'cancel_ride'.tr,
                              buttonWidget: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                              activeColor: Theme.of(context).primaryColor,
                              isFinished: isFinished,
                              onWaitingProcess: () {
                                Future.delayed(const Duration(milliseconds: 700), () {
                                  setState(() {
                                    isFinished = true;
                                  });
                                });
                              },
                              onFinish: () async {
                                Get.dialog(GetBuilder<RideController>(
                                  builder: (rideController) {
                                    return ConfirmationDialog(
                                      isLoading: rideController.isLoading,
                                      icon: Images.completeIcon,
                                      description: 'are_you_sure'.tr,
                                      onYesPressed: () {
                                        rideController.tripStatusUpdate(rideController.tripDetails!.id!, 'cancelled', 'ride_request_cancelled_successfully', afterAccept: true).then((value) async {
                                          if(value.statusCode == 200){
                                            rideController.getFinalFare(rideController.tripDetails!.id!).then((value) {
                                              if(value.statusCode == 200){
                                                Get.find<RideController>().updateRideCurrentState(RideState.completeRide);
                                                Get.find<MapController>().notifyMapController();
                                                Get.off(() => const PaymentScreen());
                                              }
                                            });
                                          }
                                        });
                                      },
                                    );
                                  }
                                ), barrierDismissible: false);

                                setState(() {
                                  isFinished = false;
                                });
                              },
                            ),
                          )
                        ]) :
                        const Column(children: [BannerShimmer(), BannerShimmer(), BannerShimmer()]):

                        (rideController.currentRideState == RideState.otpSent) ? Column(children: [
                          TollTipWidget(title: 'rider_details'.tr),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),

                          const OtpWidget(fromPage: OtpPage.bike),
                          const SizedBox(height: Dimensions.paddingSizeDefault,),

                          ContactWidget(driverId: rideController.tripDetails!.driver!.id!,),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const ActivityScreenRiderDetails(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const EstimatedFareAndDistance(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          RouteWidget(totalDistance: rideController.tripDetails!.estimatedDistance.toString(),
                            fromAddress: rideController.tripDetails!.pickupAddress!,
                            toAddress: rideController.tripDetails!.destinationAddress!,
                            extraOneAddress: firstRoute,
                            extraTwoAddress: secondRoute,
                            entrance:  rideController.tripDetails!.entrance??''),
                          const SizedBox(height: Dimensions.paddingSizeDefault),


                          Center(
                            child: SwipeableButtonView(
                              buttonText: 'cancel_ride'.tr,
                              buttonWidget: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                              activeColor: Theme.of(context).primaryColor,
                              isFinished: isFinished,
                              onWaitingProcess: () {
                                Future.delayed(const Duration(seconds: 2), () {
                                  setState(() {
                                    isFinished = true;
                                  });
                                });
                              },
                              onFinish: () async {
                                Get.dialog(ConfirmationDialog(
                                  isLoading: rideController.isLoading,
                                  icon: Images.cancelIcon,
                                  description: 'are_you_sure'.tr,
                                  onYesPressed: () {
                                    rideController.tripStatusUpdate(rideController.tripDetails!.id!, 'cancelled', 'ride_request_cancelled_successfully');
                                    Get.find<MapController>().notifyMapController();
                                    Get.find<BottomMenuController>().navigateToDashboard();
                                  },
                                ), barrierDismissible: false);
                                setState(() {
                                  isFinished = false;
                                });
                              },
                            ),
                          ),

                        ]) :

                        (rideController.currentRideState == RideState.ongoingRide) ?
                        GestureDetector(
                          onTap: () {
                            showDialog(context: context, builder: (_) {
                              return ConfirmationDialog(icon: Images.endTrip,
                                description: 'end_this_trip_at_your_destination'.tr, onYesPressed: () async {
                                  Get.back();
                                  Get.dialog(const ConfirmationTripDialog(isStartedTrip: false,), barrierDismissible: false);
                                  await Future.delayed( const Duration(seconds: 5));
                                  rideController.updateRideCurrentState(RideState.completeRide);
                                  Get.find<MapController>().notifyMapController();
                                  Get.off(()=>const PaymentScreen());
                                },);
                            });
                          },
                          child: Column(children: [
                            TollTipWidget(title: 'trip_is_ongoing'.tr),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),
                            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                              child: Text.rich(TextSpan(
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)
                                ),
                                children:  [
                                  TextSpan(text: "the_car_just_arrived_at".tr,style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                  TextSpan(text: " ".tr),
                                  TextSpan(text: "your_destination".tr,style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor)),
                                ],
                              ),
                              ),
                            ),

                            const ActivityScreenRiderDetails(),
                            const SizedBox(height: Dimensions.paddingSizeDefault,),
                          ]),
                        ) : const SizedBox(),

                    ]),
                  );
                });
              }),
            ])
        ),
      );
    });
  }
}
