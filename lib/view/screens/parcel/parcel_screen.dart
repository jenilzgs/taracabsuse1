import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_view.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/dotted_border_card.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/parcel_category_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';

class ParcelScreen extends StatefulWidget {
  const ParcelScreen({super.key});

  @override
  State<ParcelScreen> createState() => _ParcelScreenState();
}

class _ParcelScreenState extends State<ParcelScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<ParcelController>().getParcelCategoryList(notify: true);
    Get.find<RideController>().initData();
    Get.find<LocationController>().initAddLocationData();
    Get.find<LocationController>().initParcelData();
    Get.find<ParcelController>().initParcelData();
    Get.find<MapController>().initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [

        CustomBody(
          appBar: CustomAppBar(title: 'parcel_delivery'.tr),
          body: const Padding(padding: EdgeInsets.all(Dimensions.paddingSizeDefault), child: Column(children:  [

            BannerView(),

            DottedBorderCard(),

            ParcelCategoryView(),

          ])),
        ),


        Positioned(
          bottom: Dimensions.paddingSizeDefault,
          left:  Dimensions.paddingSizeDefault,
          right:  Dimensions.paddingSizeDefault,
          child: CustomButton(
            buttonText: 'add_parcel'.tr,
            onPressed: () {
              if(Get.find<ParcelController>().parcelCategoryList == null || Get.find<ParcelController>().parcelCategoryList!.isEmpty) {
                showCustomSnackBar('no_parcel_category_found'.tr);
              }else {
                Get.to(() => const MapScreen(fromScreen: MapScreenType.parcel));
              }
            },
          ),
        ),

      ]),
    );
  }
}




