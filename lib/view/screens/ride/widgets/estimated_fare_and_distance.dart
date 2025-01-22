import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/fare_widget.dart';


class EstimatedFareAndDistance extends StatelessWidget {
  final bool fromPickLocation;
  const EstimatedFareAndDistance({super.key, this.fromPickLocation = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController) {
        return rideController.remainingDistanceModel != null && rideController.remainingDistanceModel!.isNotEmpty ? Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            color: Theme.of(context).primaryColor.withOpacity(0.15)),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            FareWidget(title: 'distance_away'.tr,
              value: (rideController.remainingDistanceModel != null && rideController.remainingDistanceModel!.isNotEmpty)
                  ? rideController.remainingDistanceModel![0].distanceText ?? '0' : '0'),
            FareWidget(title: 'estimated_time'.tr,
              value: (rideController.remainingDistanceModel != null && rideController.remainingDistanceModel!.isNotEmpty)
                  ?  (rideController.remainingDistanceModel![0].duration)?? '0' : '0'),
            if(rideController.tripDetails != null)
            FareWidget(title: 'fare_price'.tr,
              value: PriceConverter.convertPrice(fromPickLocation ? rideController.estimatedFare
                  : rideController.tripDetails!.actualFare!)),
          ]),
        ): const SizedBox();
      }
    );
  }
}
