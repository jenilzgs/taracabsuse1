import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class FareInputWidget extends StatefulWidget {
  final GlobalKey<ExpandableBottomSheetState> expandableKey;
  final bool fromRide;
  final String fare;
  const FareInputWidget({super.key, required this.fromRide, required this.fare, required this.expandableKey});

  @override
  State<FareInputWidget> createState() => _FareInputWidgetState();
}

class _FareInputWidgetState extends State<FareInputWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
      return GetBuilder<ParcelController>(builder: (parcelController) {
        return Row(children: [

          Expanded(child: GestureDetector(
            onTap: () {
              if(widget.fromRide) {
                Get.find<RideController>().updateRideCurrentState(RideState.riseFare);
              }
              Get.find<MapController>().notifyMapController();
            },
            child: Container(height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                border: Border.all(color: Theme.of(context).primaryColor,width: 1),
              ),
              child: Center(child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [

                Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall), child: Text(
                  'fare'.tr, overflow: TextOverflow.ellipsis,
                  style: textRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.9),
                  ),
                ))),

                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall), child: Text(
                  PriceConverter.convertPrice(double.tryParse(widget.fare)!),
                  style: textMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.9),
                  ),
                )),

              ])),
            ),
          )),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          (rideController.isSubmit || parcelController.getSuggested) ?  Center(
            child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0),
          ) : Expanded(child:  rideController.isSubmit ?  Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)) :
          CustomButton(
            buttonText: widget.fromRide ? 'find_rider'.tr : 'find_deliveryman'.tr,
            onPressed: () {
              if(widget.fromRide) {
                rideController.submitRideRequest(rideController.noteController.text, false).then((value) {
                  if(value.statusCode == 200) {
                    rideController.updateRideCurrentState(RideState.findingRider);
                    Get.find<MapController>().notifyMapController();
                  }
                });
              }else {
                parcelController.getSuggestedCategoryList().then((value) {
                  if(value.statusCode == 200){
                    Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.suggestVehicle);
                  }
                });
              }
              Get.find<MapController>().notifyMapController();
            },
            fontSize: Dimensions.fontSizeDefault,
          )),
        ]);
      });
    });
  }
}
