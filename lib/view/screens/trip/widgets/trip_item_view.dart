import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/date_converter.dart';
import 'package:ride_sharing_user_app/helper/price_converter.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/trip/trip_details_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class TripItemView extends StatelessWidget {
  final TripDetails tripDetails;
  final bool? isDetailsScreen;
  const TripItemView({super.key, required this.tripDetails, this.isDetailsScreen = false});

  @override
  Widget build(BuildContext context) {

    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return InkWell(onTap: () => Get.to(() => TripDetailsScreen(tripId: tripDetails.id!)),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

          Container(width: 80, height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.02),),
            child: Center(child: Column(children: [
              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                child: CustomImage(width: 80, height: 60,
                  image : tripDetails.vehicle != null? '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleModel!}/${tripDetails.vehicle!.model!.image!}' : '',
                  fit: BoxFit.cover)),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

              Text(tripDetails.vehicle != null ? tripDetails.vehicle!.vinNumber.toString() : '',
                style: textMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4)),
              ),
            ])),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tripDetails.pickupAddress ?? '',
              style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(tripDetails.destinationAddress ?? '',
              style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(DateConverter.localToIsoString(DateTime.parse(tripDetails.createdAt!)),
              style: textRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.4),),),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            tripDetails.estimatedFare!=null ? Text(PriceConverter.convertPrice(tripDetails.paidFare!),
              style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ) : const SizedBox(),

            Text(capitalize(tripDetails.currentStatus!),
              style: textMedium.copyWith(
                fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ])),
        ]),
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
