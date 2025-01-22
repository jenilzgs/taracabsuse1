
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/widget/custom_icon_card.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/parcel_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/ride_expendable_bottom_sheet.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_app_bar.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_body.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_button.dart';


enum MapScreenType{ride, splash, parcel, location}

class MapScreen extends StatefulWidget {
  final MapScreenType fromScreen;
  const MapScreen({super.key, required this.fromScreen});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey<ExpandableBottomSheetState>();


  @override
  void initState() {
    super.initState();
    Get.find<MapController>().setContainerHeight((widget.fromScreen == MapScreenType.parcel) ? 200 : 260, false);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    Get.find<MapController>().mapController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        CustomBody(
          appBar: CustomAppBar(
            title: 'the_deliveryman_need_you'.tr, centerTitle: true,
            onBackPressed: () {
              if(Navigator.canPop(context)) {
                Get.back();
              }else {
                Get.offAll(()=> const DashboardScreen());
              }
            },
          ),
          topMargin: 0,
          body: GetBuilder<MapController>(builder: (mapController) {
            return ExpandableBottomSheet(
              key: key,
              background: GetBuilder<RideController>(builder: (rideController) {
                return Stack(children: [

                  Padding(padding: EdgeInsets.only(bottom: mapController.sheetHeight - 20), child: GoogleMap(
                    mapType: MapType.terrain,
                    initialCameraPosition:  CameraPosition(
                      target:  rideController.tripDetails?.pickupCoordinates != null ? LatLng(
                        rideController.tripDetails!.pickupCoordinates!.coordinates![1],
                        rideController.tripDetails!.pickupCoordinates!.coordinates![0],
                      ): Get.find<LocationController>().initialPosition,
                      zoom: 16,),

                    onMapCreated: (GoogleMapController controller) {
                      mapController.mapController = controller;
                      mapController.getPolyline();
                      _mapController = controller;
                      _mapController!.setMapStyle(
                        Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                      );
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                    markers: Set<Marker>.of(mapController.markers),
                    polylines: Set<Polyline>.of(mapController.polylines.values),
                    zoomControlsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true)),

                  Positioned(bottom: 300,right: 0,
                    child: Align(alignment: Alignment.bottomRight,
                      child: GetBuilder<LocationController>(
                          builder: (locationController) {
                            return CustomIconCard(index: 5,icon: Images.currentLocation,
                                onTap: () async {
                                  await locationController.getCurrentLocation(mapController: _mapController);
                                  await _mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: Get.find<LocationController>().initialPosition, zoom: 16)));
                                });
                          }
                      ),
                    ),
                  ),
                ]);
              }),
              persistentContentHeight: mapController.sheetHeight,

              expandableContent: Column(mainAxisSize: MainAxisSize.min, children: [

                widget.fromScreen == MapScreenType.parcel ?
                GetBuilder<RideController>(
                  builder: (parcelController) {
                    return ParcelExpendableBottomSheet(expandableKey: key);
                  }
                ) : (widget.fromScreen == MapScreenType.ride || widget.fromScreen == MapScreenType.splash) ?

                GetBuilder<RideController>(
                    builder: (rideController) {
                      return RideExpendableBottomSheet(expandableKey: key);
                    }) : const SizedBox(),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),

              ]),
            );
          }),
        ),



        widget.fromScreen == MapScreenType.location ? Positioned(
          child: Align(alignment: Alignment.bottomCenter,
            child: SizedBox(height: 70, child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomButton(buttonText: 'set_location'.tr, onPressed: () => Get.back()),
            )),
          ),
        ) : const SizedBox(),

      ]),
    );
  }
}
