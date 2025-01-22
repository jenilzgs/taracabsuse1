import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/theme/theme_controller.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/view/screens/home/widgets/banner_shimmer.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/widget/custom_title.dart';


class HomeMapView extends StatefulWidget {
  final String title;
  const HomeMapView({super.key, required this.title});

  @override
  HomeMapViewState createState() => HomeMapViewState();
}

class HomeMapViewState extends State<HomeMapView> {
  GoogleMapController? _mapController;
  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<MapController>(
      builder: (riderController) {

        return GetBuilder<LocationController>(
          builder: (locationController) {
            Completer<GoogleMapController> mapCompleter = Completer<GoogleMapController>();
            if(riderController.mapController != null) {
              mapCompleter.complete(riderController.mapController);
            }
            return riderController.nearestDeliveryManMarkers != null ? Padding(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, bottom: 100),
              child: Column(children: [
                  CustomTitle(title: widget.title.tr, color: Theme.of(context).textTheme.displayLarge!.color),

                  Container(height: 250, decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: GoogleMap(
                        mapType: MapType.terrain,
                        markers: riderController.nearestDeliveryManMarkers!.toSet(),
                        initialCameraPosition: CameraPosition(target: LatLng(
                          Get.find<LocationController>().getUserAddress()!.latitude!,
                          Get.find<LocationController>().getUserAddress()!.longitude!,
                        ), zoom: 16),
                        minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                        onMapCreated: (gController) {
                          _mapController = gController;
                          _mapController!.setMapStyle(
                            Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                          );
                          riderController.setMapController(gController);
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ) : const BannerShimmer();
          }
        );
      }
    );
  }

}
