import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/rider_details.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/choose_effificent_vehicle_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/contact_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/fare_input_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/finding_rider_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/otp_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/parcel_details_input_view.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/product_details_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/receiver_details_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/sender_receiver_info_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/who_will_pay_button.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/estimated_fare_and_distance.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/rise_fare_widget.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class ParcelExpendableBottomSheet extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  const ParcelExpendableBottomSheet({super.key, required this.expandableKey});

  @override
  State<ParcelExpendableBottomSheet> createState() => _ParcelExpendableBottomSheetState();
}

class _ParcelExpendableBottomSheetState extends State<ParcelExpendableBottomSheet> {
  @override
  void initState() {
    Get.find<ParcelController>().updatePaymentPerson(false, notify: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController) {
      return GetBuilder<RideController>(
        builder: (rideController) {
          return Container(width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor,
              borderRadius : const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.paddingSizeDefault),
                topRight : Radius.circular(Dimensions.paddingSizeDefault)),
              boxShadow: [BoxShadow(color: Theme.of(context).hintColor, blurRadius: 5, spreadRadius: 1, offset: const Offset(0,2))],),

            child: Padding(padding:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
              child : Column(mainAxisSize: MainAxisSize.min, children: [

                Container(height: 7, width: 70, decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),)),

                const Padding(padding:  EdgeInsets.fromLTRB(
                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeSmall,
                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeDefault),
                  child: SizedBox(),),

                GetBuilder<ParcelController>(builder: (parcelController) {
                  return Padding(padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
                    child: Column(mainAxisSize: MainAxisSize.min, children:  [

                      (parcelController.currentParcelState == ParcelDeliveryState.initial) ?
                      SenderReceiverInfoWidget(expandableKey: widget.expandableKey)
                      : (parcelController.currentParcelState == ParcelDeliveryState.addOtherParcelDetails) ?
                      ParcelDetailInputView(expandableKey: widget.expandableKey)
                      : (parcelController.currentParcelState == ParcelDeliveryState.parcelInfoDetails) ?
                      Column(mainAxisSize: MainAxisSize.min,children:  [

                        const TollTipWidget(title: "delivery_details", showInsight: false,),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        RouteWidget(totalDistance: Get.find<RideController>().parcelEstimatedFare!.data!.estimatedDistance!.toString(),
                          fromAddress: Get.find<ParcelController>().senderAddressController.text,
                          toAddress: Get.find<ParcelController>().receiverAddressController.text,
                          extraOneAddress: '', extraTwoAddress: '', entrance: '',
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),


                        const ProductDetailsWidget(),

                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        const WhoWillPayButton(),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        UserDetailsWidget(
                          name: parcelController.senderNameController.text,
                          contactNumber: parcelController.senderContactController.text,
                          type: 'sender'),

                        UserDetailsWidget(name: parcelController.receiverNameController.text,
                          contactNumber: parcelController.receiverContactController.text,
                          type: 'receiver'),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        const TollTipWidget(title: "terms_and_policy"),
                        const SizedBox(height: Dimensions.paddingSizeDefault,),

                        FareInputWidget(expandableKey: widget.expandableKey,fromRide: false,
                            fare: Get.find<RideController>().parcelEstimatedFare!.data!.estimatedFare.toString()),

                      ]) :

                      (parcelController.currentParcelState == ParcelDeliveryState.riseFare)?
                       RiseFareWidget(expandableKey: widget.expandableKey, fromPage: RiseFare.parcel) :
                      (parcelController.currentParcelState == ParcelDeliveryState.suggestVehicle)?
                      const ChooseEfficientVehicleWidget() :
                      (parcelController.currentParcelState == ParcelDeliveryState.findingRider)?
                      const FindingRiderWidget(fromPage: FindingRide.parcel) :
                      (parcelController.currentParcelState == ParcelDeliveryState.acceptRider)?
                      GestureDetector(onTap: () => Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent),
                        child:  Column(children:  [
                          const TollTipWidget(title: "rider_details",),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ContactWidget(driverId: rideController.tripDetails!.driver!.id!),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const ActivityScreenRiderDetails(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),


                          const EstimatedFareAndDistance(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomButton(buttonText: 'cancel_ride'.tr,
                            transparent: true,
                            borderWidth: 1,
                            showBorder: true,
                            radius: Dimensions.paddingSizeSmall,
                            borderColor: Theme.of(Get.context!).primaryColor,
                            onPressed: () {
                              parcelController.updateParcelState(ParcelDeliveryState.initial);
                              Get.find<MapController>().notifyMapController();
                            },
                          ),

                        ]),
                      ) : (parcelController.currentParcelState == ParcelDeliveryState.otpSent) ? GestureDetector(
                        onTap: () async {
                          Get.dialog(const ConfirmationTripDialog(isStartedTrip: true), barrierDismissible: false);
                          await Future.delayed( const Duration(seconds: 5));
                          parcelController.updateParcelState(ParcelDeliveryState.parcelOngoing);
                          Get.find<MapController>().notifyMapController();
                          Get.back();
                        },
                        child: Column(mainAxisSize: MainAxisSize.min,children: [
                          TollTipWidget(title: 'rider_details'.tr),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const OtpWidget(fromPage: OtpPage.bike),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          ContactWidget(driverId: rideController.tripDetails!.driver!.id!),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const ActivityScreenRiderDetails(),

                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const EstimatedFareAndDistance(),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          CustomButton(
                            buttonText: 'cancel_ride'.tr,
                            transparent: true,
                            borderWidth: 1,
                            showBorder: true,
                            radius: Dimensions.paddingSizeSmall,
                            borderColor: Theme.of(Get.context!).primaryColor,
                            onPressed: () {
                              parcelController.updateParcelState(ParcelDeliveryState.initial);
                              Get.find<MapController>().notifyMapController();
                            },
                          ),

                        ]),
                      ) : (parcelController.currentParcelState == ParcelDeliveryState.parcelOngoing) ? Column(children: [

                        TollTipWidget(title: 'trip_is_ongoing'.tr),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                          child: Text.rich(TextSpan(
                            style: textRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
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
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                      ]) : const SizedBox(),

                    ]),
                  );
                }),

              ]),
            ),
          );
        }
      );
    });
  }
}
