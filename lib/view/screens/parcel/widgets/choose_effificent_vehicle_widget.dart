import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/suggested_category_card.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class ChooseEfficientVehicleWidget extends StatefulWidget {

  const ChooseEfficientVehicleWidget({super.key});

  @override
  State<ChooseEfficientVehicleWidget> createState() => _ChooseEfficientVehicleWidgetState();
}

class _ChooseEfficientVehicleWidgetState extends State<ChooseEfficientVehicleWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ParcelController>(builder: (parcelController){
      return GetBuilder<RideController>(builder: (rideController) {
          return
          Column(mainAxisSize: MainAxisSize.min,
            children: [

              (parcelController.suggestedCategoryList != null && parcelController.suggestedCategoryList!.isNotEmpty) ?

              ListView.builder(shrinkWrap: true, padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: parcelController.suggestedCategoryList!.length,
                  itemBuilder: (context, index) {
                  return SuggestedCategoryCard(suggestedCategory: parcelController.suggestedCategoryList![index]);
              }) : const SizedBox(),

              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault), child: Text(
                'find_your_best_parcel_delivery_vehicles'.tr,style: textMedium.copyWith(color: Theme.of(context).primaryColor),
              )),

              Text(
                'find_your_best_parcel_delivery_vehicles_hint'.tr,
                style: textMedium.copyWith(color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),

              Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall), child: Text(
                'or'.tr,style: textMedium.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.fontSizeLarge),
              )),

              rideController.isSubmit? Center(child: SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,)):CustomButton(
                buttonText: 'choose_the_efficient_vehicles'.tr,
                fontSize: Dimensions.fontSizeDefault,
                onPressed: (){
                  rideController.submitRideRequest('', true).then((value) {
                    if(value.statusCode == 200) {
                      Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
                      Get.find<MapController>().notifyMapController();
                    }
                  });
                },
              ),
            ],
          );
        }
      );
    });
  }
}
