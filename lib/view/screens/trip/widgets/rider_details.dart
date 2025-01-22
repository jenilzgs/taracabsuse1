import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_image.dart';

class ActivityScreenRiderDetails extends StatelessWidget {
  const ActivityScreenRiderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(
      builder: (rideController) {

        String ratting = rideController.tripDetails?.driverAvgRating != null
            ? double.parse(rideController.tripDetails!.driverAvgRating!).toStringAsFixed(1) : "0";

        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Text('rider_details'.tr,style: textBold.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColor),),),

          Row(children: [
            Expanded(child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                  child: CustomImage(height: 50, width: 50,
                    image: rideController.tripDetails?.driver != null ? '${Get.find<ConfigController>().config!.imageBaseUrl!.profileImageDriver}'
                        '/${rideController.tripDetails!.driver!.profileImage}' : '')),
                const SizedBox(width: Dimensions.paddingSizeSmall,),


                Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      rideController.tripDetails?.driver != null ? Text('${rideController.tripDetails!.driver!.firstName!} ${rideController.tripDetails!.driver!.lastName!}',
                        style: textMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).primaryColorDark),
                        overflow: TextOverflow.ellipsis,
                      ) : const SizedBox(),
                      Text.rich(TextSpan(style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8),), children:  [

                          WidgetSpan(child: Icon(Icons.star,color: Theme.of(context).colorScheme.primaryContainer,size: 15,),
                            alignment: PlaceholderAlignment.middle),

                          TextSpan(text: ratting,
                              style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        ],
                      )),
                    ],
                  ),
                )
                ],
              ),
            ),

            rideController.tripDetails?.vehicle != null ? Expanded(child: Row(children: [

              ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusOverLarge),
                child: CustomImage(height: 50, width: 50,
                  image:rideController.tripDetails!.vehicle != null?
                  '${Get.find<ConfigController>().config!.imageBaseUrl!.vehicleModel!}/${rideController.tripDetails!.vehicle!.model!.image!}' : '',)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Flexible(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text(rideController.tripDetails!.vehicle != null ? rideController.tripDetails!.vehicle!.model!.name! : '',
                  style: textMedium.copyWith(fontSize: Dimensions.fontSizeDefault,color: Theme.of(context).primaryColorDark),
                  overflow: TextOverflow.ellipsis,),

                Text.rich(TextSpan(style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                    color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)), children:  [
                    TextSpan(text: rideController.tripDetails!.vehicle!.licencePlateNumber,
                      style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  ],
                ), overflow: TextOverflow.ellipsis),
              ])),

            ])) : const SizedBox(),

          ]),
        ]);
      }
    );
  }
}
