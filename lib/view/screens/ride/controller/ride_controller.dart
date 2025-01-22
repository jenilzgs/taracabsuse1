import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/auth/controller/auth_controller.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/home/controller/category_controller.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/model/parcel_estimated_fare_model.dart';
import 'package:ride_sharing_user_app/view/screens/payment/controller/payment_controller.dart';
import 'package:ride_sharing_user_app/view/screens/payment/payment_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/bidding_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/estimated_fare_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/final_fare_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/nearest_driver_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/remaining_distance_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/model/trip_details_model.dart';
import 'package:ride_sharing_user_app/view/screens/ride/repository/ride_repo.dart';


enum RideState{initial, riseFare, findingRider, acceptingRider, afterAcceptRider, otpSent, ongoingRide, completeRide}
enum RideType{car, bike, parcel, luxury}

class RideController extends GetxController implements GetxService {
  final RideRepo rideRepo;
  RideController({required this.rideRepo});

  RideState currentRideState = RideState.initial;
  RideType selectedCategory = RideType.car;
  TripDetails? tripDetails;
  double currentFarePrice = 0;
  int rideCategoryIndex = 0;
  bool isLoading = false;
  String estimatedDistance = '0';
  String estimatedDuration = '0';
  double estimatedFare = 0;
  List<FareModel> fareList = [];
  ParcelEstimatedFare? parcelEstimatedFare;
  String parcelFare = '0';
  String encodedPolyLine = '';
  bool loading = false;
  bool isEstimate = false;
  bool isSubmit = false;
  List<Nearest> nearestDriverList = [];
  FinalFare? finalFare;
  List<Bidding> biddingList = [];
  List<RemainingDistanceModel>? remainingDistanceModel = [];

  TextEditingController inputFarePriceController = TextEditingController(text: '0.00');
  TextEditingController noteController = TextEditingController();

  void initData() {
    currentRideState = RideState.initial;
    isLoading = false;
    loading = false;
    encodedPolyLine = '';
  }


  void updateRideCurrentState(RideState newState) {
    currentRideState = newState;
    update();
  }

  void updateSelectedRideType(RideType newType){
    selectedCategory= newType;
    update();
  }



  Future<void> setBidingAmount(String balance) async{
    if(balance.isNotEmpty){
      estimatedFare = double.parse(balance);
      parcelFare = balance;
    }
    update();
  }

  String categoryName = '';
  String selectedCategoryId = '';
  FareModel? selectedType;
  void setRideCategoryIndex(int newIndex){
    rideCategoryIndex = newIndex;
    categoryName = Get.find<CategoryController>().categoryList![rideCategoryIndex].id!;


    if(fareList.isNotEmpty){
      for(int i = 0; i< fareList.length; i++){
        if(fareList[i].vehicleCategoryId == categoryName){
          selectedType =  fareList[i];
          break;
        }
      }

      estimatedDistance = selectedType!.estimatedDistance!;
      estimatedDuration = selectedType!.estimatedDuration!;
      selectedCategoryId = selectedType!.vehicleCategoryId!;
      estimatedFare = selectedType!.estimatedFare!;
      currentFarePrice = estimatedFare;
    }

    update();
  }

  void resetControllerValue(){
    currentRideState = RideState.initial;
    selectedCategory = RideType.car;
    rideCategoryIndex = 0;
    update();
  }


  void clearRideDetails(){
    tripDetails = null;
    update();
  }


  @override
  onInit(){
    if(tripDetails != null && Get.find<AuthController>().getUserToken() != ''){
      startLocationRecord();
    }else{
      stopLocationRecord();
    }
    super.onInit();


  }



  Future<Response> getEstimatedFare(bool parcel) async {
    loading = true;
    isEstimate = true;
    update();
    parcelEstimatedFare = null;
    LocationController locController = Get.find<LocationController>();
    ParcelController parcelController = Get.find<ParcelController>();
    Address fromPosition = parcel ? locController.parcelSenderAddress! : locController.fromAddress!;
    Address toPosition = parcel ? locController.parcelReceiverAddress! : locController.toAddress!;

    Response? response = await rideRepo.getEstimatedFare(
      pickupLatLng: LatLng(fromPosition.latitude!, fromPosition.longitude!),
      destinationLatLng: LatLng(toPosition.latitude!, toPosition.longitude!),
      currentLatLng: LatLng(locController.initialPosition.latitude, locController.initialPosition.longitude),
      type: parcel ? 'parcel' : 'ride_request',
      pickupAddress : parcel ? parcelController.senderAddressController.text
          : locController.fromAddress!.address.toString(),
      destinationAddress: parcel ? parcelController.receiverAddressController.text
          : locController.toAddress!.address!,
      extraOne: locController.extraOneRoute,
      extraTwo: locController.extraTwoRoute,
      extraOneLatLng: locController.extraRouteAddress != null ? LatLng(
        locController.extraRouteAddress!.latitude!, locController.extraRouteAddress!.longitude!,
      ) : null,
      extraTwoLatLng: locController.extraRouteTwoAddress != null ? LatLng(
        locController.extraRouteTwoAddress!.latitude!, locController.extraRouteTwoAddress!.longitude!,
      ) : null,
      parcelWeight: Get.find<ParcelController>().parcelWeightController.text,
      parcelCategoryId: parcel ? parcelController.parcelCategoryList![parcelController.selectedParcelCategory].id : '',
    );

    if(response!.statusCode == 200) {
      loading = false;
      isEstimate = false;
      locController.pickupLocationController.clear();
      locController.destinationLocationController.clear();
      locController.extraRouteOneController.clear();
      locController.extraRouteTwoController.clear();


      if(parcel) {
        parcelEstimatedFare = ParcelEstimatedFare.fromJson(response.body);
        encodedPolyLine = ParcelEstimatedFare.fromJson(response.body).data!.encodedPolyline!;
        parcelFare = ParcelEstimatedFare.fromJson(response.body).data!.estimatedFare!.toString();
      }else{
        fareList = [];
        fareList.addAll(EstimatedFareModel.fromJson(response.body).data!);
        setRideCategoryIndex(rideCategoryIndex != 0?  rideCategoryIndex : 0);
        encodedPolyLine = fareList[rideCategoryIndex].polyline!;
        if(encodedPolyLine != '' && encodedPolyLine.isNotEmpty) {
          Get.find<MapController>().getPolyline();

        }
      }
    }else{
      loading = false;
      isEstimate = false;
      ApiChecker.checkApi(response);
      if(response.statusCode == 403 && !parcel) {
        getCurrentRideStatus(navigateToMap: false);
      }
    }

    update();
    return response;
  }

  Future<Response> submitRideRequest(String note, bool parcel, {String categoryId = ''}) async {
    isSubmit = true;
    update();

    LocationController locController = Get.find<LocationController>();
    Address pickUpPosition = parcel ? locController.parcelSenderAddress! : locController.fromAddress!;
    Address destinationPosition = parcel ? locController.parcelReceiverAddress! : locController.toAddress!;

    Response response = await rideRepo.submitRideRequest(
      pickupLat: pickUpPosition.latitude.toString(),
      pickupLng: pickUpPosition.longitude.toString(),
      destinationLat: destinationPosition.latitude.toString(),
      destinationLng: destinationPosition.longitude.toString(),
      customerCurrentLat: locController.initialPosition.latitude.toString(),
      customerCurrentLng: locController.initialPosition.longitude.toString(),
      type: parcel ? 'parcel' : 'ride_request',
      pickupAddress: parcel ? Get.find<ParcelController>().senderAddressController.text
          : locController.fromAddress!.address.toString(),
      destinationAddress: parcel ? Get.find<ParcelController>().receiverAddressController.text
          : locController.toAddress!.address!,
      vehicleCategoryId: parcel ? categoryId : selectedCategoryId,
      estimatedDistance: parcel ? parcelEstimatedFare!.data!.estimatedDistance!.toString() : estimatedDistance,
      estimatedTime: parcel ? parcelEstimatedFare!.data!.estimatedDuration!.replaceFirst('min', '') : estimatedDuration,
      estimatedFare: parcel ? parcelFare : estimatedFare.toString(),
      note: note,
      paymentMethod: Get.find<PaymentController>().paymentTypeList[Get.find<PaymentController>().paymentTypeIndex],
      encodedPolyline: parcel ? encodedPolyLine : fareList[rideCategoryIndex].polyline!,
      middleAddress: [locController.extraRouteAddress?.address ?? '', locController.extraRouteTwoAddress?.address ?? ''],
      entrance: locController.entranceController.text.toString(),
      extraOne: locController.extraOneRoute,
      extraTwo: locController.extraTwoRoute,
      extraLatOne: locController.extraRouteAddress != null ? locController.extraRouteAddress!.latitude.toString() : '',
      extraLngOne: locController.extraRouteAddress != null ? locController.extraRouteAddress!.longitude.toString() : '',
      extraLatTwo: locController.extraRouteTwoAddress != null ? locController.extraRouteTwoAddress!.latitude.toString() : '',
      extraLngTwo: locController.extraRouteTwoAddress != null ? locController.extraRouteTwoAddress!.longitude.toString() : '',
      areaId: parcel ? '' : fareList[rideCategoryIndex].areaId ?? '',
      senderName: Get.find<ParcelController>().senderNameController.text,
      senderPhone: Get.find<ParcelController>().senderContactController.text,
      senderAddress: Get.find<ParcelController>().senderAddressController.text,
      receiverName: Get.find<ParcelController>().receiverNameController.text,
      receiverPhone: Get.find<ParcelController>().receiverContactController.text,
      receiverAddress: Get.find<ParcelController>().receiverAddressController.text,
      parcelCategoryId: parcel ? Get.find<ParcelController>().parcelCategoryList![Get.find<ParcelController>().selectedParcelCategory].id : '',
      payer: Get.find<ParcelController>().payReceiver?'receiver':"sender",
      weight: Get.find<ParcelController>().parcelWeightController.text,
    );

    if(response.statusCode == 200 && response.body['data'] != null) {
      biddingList = [];
      tripDetails = TripDetailsModel.fromJson(response.body).data!;
      tripDetails!.id = response.body['data']['id'];
      encodedPolyLine = tripDetails!.encodedPolyline!;
      if(encodedPolyLine != '' && encodedPolyLine.isNotEmpty) {
        Get.find<MapController>().getPolyline();
      }
      Get.find<ParcelController>().receiverNameController.clear();
      Get.find<ParcelController>().receiverContactController.clear();
      Get.find<ParcelController>().receiverAddressController.clear();
      Get.find<ParcelController>().parcelWeightController.clear();

      isSubmit = false;
      noteController.clear();
    }else{
      isSubmit = false;
      ApiChecker.checkApi(response);
      if(response.statusCode == 403) {
        getCurrentRideStatus(navigateToMap: false);
      }
    }
    isLoading = false;
    update();
    return response;
  }

  void clearExtraRoute(){
    Get.find<LocationController>().extraOneRoute = false;
    Get.find<LocationController>().extraTwoRoute = false;
    Get.find<LocationController>().extraRouteAddress = null;
    Get.find<LocationController>().extraRouteTwoAddress = null;
  }

  Future<Response> getRideDetails(String tripId) async {
    isLoading = true;
    tripDetails = null;

    update();
    Response response = await rideRepo.getRideDetails(tripId);
    if (response.statusCode == 200) {
      Get.find<MapController>().notifyMapController();
      tripDetails = TripDetailsModel.fromJson(response.body).data!;
      estimatedDistance = tripDetails!.estimatedDistance!.toString();
      isLoading = false;
      encodedPolyLine = tripDetails!.encodedPolyline!;
    }
    update();
    return response;
  }
  bool runningTrip = false;

  Future<Response> getCurrentRideStatus({bool fromRefresh = false, bool navigateToMap = true}) async {
    runningTrip = true;
    Response response = await rideRepo.currentRideStatus();
    if (response.statusCode == 200 && response.body['data'] != null) {
      runningTrip = false;
      tripDetails = TripDetailsModel.fromJson(response.body).data!;
      estimatedDistance = tripDetails!.estimatedDistance!.toString();
      String currentRideStatus = tripDetails!.currentStatus!;
      encodedPolyLine = tripDetails!.encodedPolyline ?? '';
      if(encodedPolyLine.isNotEmpty) {
        Get.find<MapController>().getPolyline();
      }

      if(currentRideStatus == AppConstants.accepted || currentRideStatus == AppConstants.ongoing) {
        updateRideCurrentState(currentRideStatus == AppConstants.accepted ? RideState.otpSent : RideState.afterAcceptRider);
        Get.find<MapController>().notifyMapController();
        if(navigateToMap) {
          Get.offAll(() => const MapScreen(fromScreen: MapScreenType.splash));
        }
      }
      else if(currentRideStatus == AppConstants.pending) {
        Get.find<RideController>().updateRideCurrentState(RideState.findingRider);
        Get.find<RideController>().getBiddingList(tripDetails!.id!, 1);
        Get.find<MapController>().notifyMapController();
        if(navigateToMap) {
          Get.offAll(() => const MapScreen(fromScreen: MapScreenType.splash));
        }
      } else if (currentRideStatus == AppConstants.completed || currentRideStatus == AppConstants.cancelled) {
        getFinalFare(tripDetails!.id!);
        Get.off(() => const PaymentScreen());
      }
      else{
        if(Get.find<LocationController>().getUserAddress() != null) {
          if(!fromRefresh) {
            Get.offAll(() => const DashboardScreen());
          }
        }else{
          Get.offAll(() => const AccessLocationScreen());
        }
      }
    } else {
      runningTrip = false;
      tripDetails = null;
      if(Get.find<LocationController>().getUserAddress() != null) {
        if(!fromRefresh) {
          Get.offAll(() => const DashboardScreen());
        }
      } else {
        Get.to(() =>  const AccessLocationScreen());
      }
    }
    update();
    return response;
  }


  Future<Response> getCurrentRide({bool fromRefresh = false, bool navigateToMap = true}) async {
    Response response = await rideRepo.currentRideStatus();
    if (response.statusCode == 200 && response.body['data'] != null) {
      tripDetails = TripDetailsModel.fromJson(response.body).data!;
      estimatedDistance = tripDetails!.estimatedDistance!.toString();
      encodedPolyLine = tripDetails!.encodedPolyline ?? '';
      if(encodedPolyLine.isNotEmpty) {
        Get.find<MapController>().getPolyline();
      }
    }
    update();
    return response;
  }



  Future<Response> remainingDistance(String requestID) async {
    isLoading = true;
    Response response = await rideRepo.remainDistance(requestID);
    if (response.statusCode == 200) {
      remainingDistanceModel = [];
      for(var distance in response.body) {
        remainingDistanceModel!.add(RemainingDistanceModel.fromJson(distance));
      }

      if(remainingDistanceModel!.first.distance! <= AppConstants.coverageRadiusInMeter && tripDetails != null) {
        arrivalPickupPoint(tripDetails!.id!);
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> getBiddingList(String tripId, int offset) async {
    isLoading = true;

    Response response = await rideRepo.biddingList(tripId, offset);
    if (response.statusCode == 200) {
      biddingList = [];
      biddingList.addAll(BiddingModel.fromJson(response.body).data!);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> ignoreBidding(String bidId) async {
    isLoading = true;
    update();
    Response response = await rideRepo.ignoreBidding(bidId);
    if (response.statusCode == 200) {
      Get.back();
     getBiddingList('tripId', 1);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> getNearestDriverList(String  lat, String lng) async {
    Response response = await rideRepo.nearestDriverList(lat, lng);
    if (response.statusCode == 200) {
      nearestDriverList = [];
      nearestDriverList.addAll(NearestDriverModel.fromJson(response.body).data!);
      Get.find<MapController>().searchDeliveryMen();
    }else{
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Timer? _timer;
  void startLocationRecord() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if(Get.find<RideController>().tripDetails != null && Get.find<AuthController>().getUserToken() != ''){
        Get.find<RideController>().remainingDistance(Get.find<RideController>().tripDetails!.id!);
      }
    });
  }

  void stopLocationRecord() {
    _timer?.cancel();
  }

  Future<Response> tripAcceptOrRejected(String tripId, String type, String driverId) async {
    isLoading = true;
    update();
    Response response = await rideRepo.tripAcceptOrReject(tripId, type, driverId);
    if (response.statusCode == 200) {
      biddingList = [];
      showCustomSnackBar('trip_is_accepted'.tr, isError: false);
      Get.back();
      getRideDetails(tripId).then((value) {
        if(value.statusCode == 200){
          remainingDistance(tripDetails!.id!);
          updateRideCurrentState(RideState.otpSent);
          Get.find<MapController>().notifyMapController();
          Get.offAll(()=> const MapScreen(fromScreen: MapScreenType.ride));
        }
      });
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  void clearBiddingList(){
    biddingList = [];
    update();
}

  Future<Response> tripStatusUpdate(String tripId, String status, String message, {bool afterAccept = false}) async {
    isLoading = true;
    update();
    Response response = await rideRepo.tripStatusUpdate(tripId, status);
    if (response.statusCode == 200) {
      if(status == "cancelled" && !afterAccept){
        tripDetails = null;
      }
      showCustomSnackBar(message.tr, isError: false);
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> getFinalFare(String tripId) async {
    isLoading = true;
    update();
    Response response = await rideRepo.getFinalFare(tripId);
    if (response.statusCode == 200 ) {
      if(response.body['data'] != null){
        finalFare = FinalFareModel.fromJson(response.body).data!;
      }
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  bool isApplying = false;
  Future<Response> applyCoupon(String couponCode, String tripId) async {
    isApplying = true;
    update();
    Response response = await rideRepo.applyCoupon(couponCode, tripId);
    if (response.statusCode == 200) {
      getFinalFare(tripId);
      isApplying = false;
    }else{
      isApplying = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> removeCoupon(String tripId) async {
    isApplying = true;
    update();
    Response response = await rideRepo.removeCoupon(tripId);
    if (response.statusCode == 200) {
      getFinalFare(tripId);
      isApplying = false;
      showCustomSnackBar('coupon_removed_successfully'.tr, isError: false);

    }else{
      isApplying = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<Response> arrivalPickupPoint(String tripId) async {
    isLoading = true;
    Response response = await rideRepo.arrivalPickupPoint(tripId);
    if (response.statusCode == 200) {

    }else {
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();
    return response;
  }

  String driverLat = '0';
  String driverLng = '0';
  Future<void> detDriverLocation(String tripId) async {
    Response response = await rideRepo.arrivalPickupPoint(tripId);
    if (response.statusCode == 200) {
      driverLat = response.body['data']['latitude'];
      driverLng = response.body['data']['longitude'];
    }
    update();

  }
}