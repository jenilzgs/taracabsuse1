import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/controller/trip_controller.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/rider_info.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/trip_details.dart';
import 'package:ride_sharing_user_app/view/screens/trip/widgets/trip_item_view.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_loader.dart';

class TripDetailsScreen extends StatefulWidget {
  final String tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {

  @override
  void initState() {
    Get.find<RideController>().getRideDetails(widget.tripId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        appBar: CustomAppBar(title: 'trip_details'.tr, showBackButton: true, centerTitle: true),
        body: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: GetBuilder<TripController>(builder: (activityController) {

            return GetBuilder<RideController>(
              builder: (rideController) {
                return rideController.tripDetails != null?
                SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    TripItemView(tripDetails: rideController.tripDetails!,isDetailsScreen: true,),
                    const SizedBox(height: Dimensions.paddingSizeSmall,),


                    TripDetailWidget(tripDetails: rideController.tripDetails!),

                    if(rideController.tripDetails?.driver != null)
                     RiderInfo(tripDetails: rideController.tripDetails!),
                    const SizedBox(height: Dimensions.paddingSizeDefault,),

                  ]),
                ): const CustomLoader();
              }
            );
          }),
        ),
      ),
    );
  }
}