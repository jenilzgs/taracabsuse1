import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';

class MapController extends GetxController implements GetxService {

  Set<Marker>? nearestDeliveryManMarkers;
  bool _isLoading = false;
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = HashSet<Marker>();
  GoogleMapController? mapController;

  bool get isLoading => _isLoading;

  @override
  void onInit() {
    initializeData();
    super.onInit();
  }

  void initializeData() {
    markers = {};
    polylines = {};
    _isLoading = false;
  }

  void notifyMapController() {
    update();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getPolyline() async {
    if(Get.find<RideController>().encodedPolyLine.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      List<LatLng> result = decodeEncodedPolyline(Get.find<RideController>().encodedPolyLine);
      if (result.isNotEmpty) {
        for (var point in result) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        _addPolyLine(polylineCoordinates);
        setFromToMarker(
          LatLng(result[0].latitude, result[0].longitude),
          LatLng(result[result.length-1].latitude, result[result.length-1].longitude),
        );
      }
    }
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 5,
      color: Theme.of(Get.context!).primaryColor,
    );
    polylines[id] = polyline;
    update();
  }

  Future <void> searchDeliveryMen() async {
    final Uint8List carMarkerIcon = await convertAssetToUnit8List(Images.carTop, width: 65);
    final Uint8List bikeMarkerIcon = await convertAssetToUnit8List(Images.bikeTop, width: 65);
    nearestDeliveryManMarkers = {};
    for(int i = 0; i < Get.find<RideController>().nearestDriverList.length; i++) {

      MarkerId markerId = MarkerId('rider_$i');
      nearestDeliveryManMarkers!.add(Marker(
        markerId: markerId,
        visible: true,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        position: LatLng(double.parse(Get.find<RideController>().nearestDriverList[i].latitude!), double.parse(Get.find<RideController>().nearestDriverList[i].longitude!)),
        icon: BitmapDescriptor.fromBytes(Get.find<RideController>().nearestDriverList[i].category == 'motor_bike'? bikeMarkerIcon : carMarkerIcon),
      ));

    }
    update();
  }

  double sheetHeight = 0;
  void setContainerHeight(double height , bool notify){
    sheetHeight = height;
    if(notify){
      update();
    }

  }

  void setFromToMarker(LatLng from, LatLng to) async{
    markers = HashSet();
    Uint8List fromMarker = await convertAssetToUnit8List(Images.fromIcon, width: 125);
    Uint8List toMarker = await convertAssetToUnit8List(Images.targetLocationIcon, width: 100);

    markers.add(Marker(
      markerId: const MarkerId('from'),
      position: from,
      anchor: const Offset(0.4, 0.7),
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetails?.pickupAddress ?? '',
        snippet: 'pick_up_location'.tr,
      ),
      icon:  BitmapDescriptor.fromBytes(fromMarker),
    ));

    markers.add(Marker(
      markerId: const MarkerId('to'),
      position: to,
      anchor: const Offset(0.4, 0.8),
      infoWindow:  InfoWindow(
        title:  Get.find<RideController>().tripDetails?.destinationAddress ?? '',
        snippet: 'destination'.tr,
      ),
      icon:  BitmapDescriptor.fromBytes(toMarker),
    ));

    // if(Get.find<RideController>().tripDetails != null) {
    //   markers.add(Marker(
    //     markerId: const MarkerId('car'),
    //     position: Get.find<LocationController>().initialPosition,
    //     icon:  BitmapDescriptor.fromBytes(car),
    //   ));
    // }

    try {
      LatLngBounds? bounds;
      if(mapController != null) {
        if (from.latitude < to.latitude) {
          bounds = LatLngBounds(southwest: from, northeast: to);
        }else {
          bounds = LatLngBounds(southwest: to, northeast: from);
        }
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );
      double bearing = Geolocator.bearingBetween(from.latitude, from.longitude, to.latitude, to.longitude);
      mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: bearing, target: centerBounds, zoom: 16,
      )));
      zoomToFit(mapController, bounds, centerBounds, bearing, padding: 0.5);
    }catch(e) {
      // debugPrint('jhkygutyv' + e.toString());
    }

    update();
  }

  void updateMarkerAndCircle(Position? newLocalData) async {
    markers.removeWhere((marker) => marker.markerId.value == "car");

    Uint8List car = await convertAssetToUnit8List(Get.find<RideController>().tripDetails?.vehicleCategory?.type == 'car'?  Images.carTop: Images.bikeTop, width: 75);
    LatLng latlng = LatLng(newLocalData!.latitude, newLocalData.longitude);
    if(Get.find<RideController>().tripDetails != null) {
      markers.add( Marker(
          markerId: const MarkerId("car"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(car)));
    }

    update();
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format:ui. ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, double bearing, {double padding = 0.5}) async {
    bool keepZoomingOut = true;

    while(keepZoomingOut) {

      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          bearing: bearing,
        )));
        break;
      }
      else {
        // Zooming out by 0.1 zoom level per iteration
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

}