import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/contact_widget.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/route_widget.dart';
import 'package:ride_sharing_user_app/view/screens/payment/payment_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';

class ParcelItem extends StatelessWidget {
  final TripDetails rideRequest;
  const ParcelItem({super.key, required this.rideRequest});

  @override
  Widget build(BuildContext context) {
    String firstRoute = '';
    String secondRoute = '';
    List<dynamic> extraRoute = [];
    if(rideRequest.intermediateAddresses != null && rideRequest.intermediateAddresses != '[[, ]]'){
      extraRoute = jsonDecode(rideRequest.intermediateAddresses!);

      if(extraRoute.isNotEmpty){
        firstRoute = extraRoute[0];
      }
      if(extraRoute.isNotEmpty && extraRoute.length>1){
        secondRoute = extraRoute[1];
      }

    }
    return GetBuilder<RideController>(
      builder: (rideController) {
        return InkWell(
          onTap: (){
            if(rideRequest.paymentStatus == 'paid'){
              rideController.getFinalFare(rideRequest.id!).then((value) {
                if(value.statusCode == 200){
                  rideController.getRideDetails(rideRequest.id!).then((value){
                    if(value.statusCode == 200){

                      Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                      Get.to(()=> const MapScreen(fromScreen: MapScreenType.parcel));
                    }
                  });

                }
              });

            }else{
              if(rideRequest.parcelInformation!.payer == 'sender' && rideRequest.driver != null){
                rideController.getFinalFare(rideRequest.id!).then((value) {
                  if(value.statusCode == 200){
                    rideController.getRideDetails(rideRequest.id!).then((value){
                      if(value.statusCode == 200){
                        Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.parcelOngoing);
                        Get.off(()=>const PaymentScreen(fromParcel: true));
                      }
                    });

                  }
                });
              }else{
                if(rideRequest.driver != null){
                  rideController.getRideDetails(rideRequest.id!).then((value){
                    if(value.statusCode == 200){
                      Get.find<MapController>().getPolyline();
                      rideController.updateRideCurrentState(RideState.afterAcceptRider);
                      Get.offAll(() => const MapScreen(fromScreen: MapScreenType.splash));
                    }
                  });
                }else{
                  rideController.getRideDetails(rideRequest.id!);
                  Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.findingRider);
                  Get.find<MapController>().notifyMapController();
                  Get.offAll(() => const MapScreen(fromScreen: MapScreenType.parcel));

                }

              }


            }
          },
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
            child: Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(color: Theme.of(Get.context!).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                  border: Border.all(color: Theme.of(Get.context!).primaryColor,width: .35),
                  boxShadow:[BoxShadow(color: Theme.of(Get.context!).primaryColor.withOpacity(.1),
                      blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]),
              child:  GestureDetector(onTap: () => Get.find<ParcelController>().updateParcelState(ParcelDeliveryState.otpSent),
                child:  Column(children:  [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Text('view_details'.tr),
                    rideController.isLoading?  SpinKitCircle(color: Theme.of(context).primaryColor, size: 40.0,):
                     Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).hintColor, size: Dimensions.iconSizeMedium)],),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  RouteWidget(totalDistance: "0",
                      fromParcelOngoing: true,
                      fromAddress: rideRequest.pickupAddress!,
                      toAddress: rideRequest.destinationAddress!,
                      extraOneAddress: firstRoute,
                      extraTwoAddress: secondRoute,
                      entrance: rideRequest.entrance??''),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(rideRequest.driver != null)
                  ContactWidget(driverId: rideRequest.driver?.id??""),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ]),
              )),
          ),
        );
      }
    );
  }
}
