import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/util/styles.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/tolltip_widget.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_swipable_button/swipeable_button_view.dart';

enum FindingRide{ride, parcel}

class FindingRiderWidget extends StatefulWidget {
  final FindingRide fromPage;
  const FindingRiderWidget({super.key, required this.fromPage});

  @override
  State<FindingRiderWidget> createState() => _FindingRiderWidgetState();
}

class _FindingRiderWidgetState extends State<FindingRiderWidget> {
  bool isFinished = false;
  bool showRiderRequest = false;
  double percent = 50.0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RideController>(builder: (rideController){
      return GetBuilder<ParcelController>(builder: (parcelController){
        return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Column(children: [

            TollTipWidget(title: rideController.selectedCategory == RideType.parcel ? 'deliveryman'
                  : rideController.selectedCategory==RideType.bike ? "rider" : "driver",),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),


            Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraLarge),
              child: Image.asset(Images.findingDeliveryman, width: 70)),

            Text(rideController.selectedCategory == RideType.parcel ? 'finding_deliveryman'.tr
                  : rideController.selectedCategory==RideType.bike ? "finding_rider".tr : "finding_driver".tr,
              style: textMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge,color: Theme.of(context).primaryColor)),
            const SizedBox(height: Dimensions.paddingSizeLarge * 2),


            Center(
              child: SwipeableButtonView(
                buttonText: 'cancel_searching'.tr,
                buttonWidget: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey,),
                activeColor: Theme.of(context).primaryColor,
                isFinished: isFinished,
                onWaitingProcess: () {
                  setState(() {
                    isFinished = true;
                  });
                },
                onFinish: () async {
                  Get.dialog(GetBuilder<RideController>(
                    builder: (rideController) {
                      return ConfirmationDialog(
                        icon: Images.cancelIcon,
                        isLoading: rideController.isLoading,
                        description: 'are_you_sure'.tr,
                        onYesPressed: () {
                          rideController.tripStatusUpdate(rideController.tripDetails!.id!,'cancelled','ride_request_cancelled_successfully').then((value){
                            if(value.statusCode == 200){
                              rideController.updateRideCurrentState(RideState.initial);
                              Get.find<MapController>().notifyMapController();
                              Get.find<BottomMenuController>().navigateToDashboard();
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
          ]),
        );
      });
    });
  }
}
