import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/driver_request_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/no_data_screen.dart';

class BiddingListScreen extends StatelessWidget {
  final String tripId;
  final bool fromList;
  const BiddingListScreen({super.key, required this.tripId, this.fromList = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RideController>(
        builder: (rideController) {
          return CustomBody(
            appBar: CustomAppBar(title: 'bidding_list'.tr,),
            body: rideController.biddingList.isNotEmpty?
            DriverRideRequestDialog(tripId: tripId, fromList: fromList):
            const NoDataScreen(title : 'no_bid_request_found'),
          );
        }
      ),
    );
  }
}
