import 'dart:convert';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class RideRepo {
  final ApiClient apiClient;
  RideRepo({required this.apiClient});


  Future<Response?> getEstimatedFare(
      {required LatLng pickupLatLng,
      required LatLng destinationLatLng,
      required LatLng currentLatLng,
      required String type,
      required String pickupAddress,
      required String destinationAddress,
        LatLng? extraOneLatLng = const LatLng(0, 0),
        LatLng? extraTwoLatLng = const LatLng(0, 0),
        bool extraOne = false, bool extraTwo = false,
        String? parcelWeight,
        String? parcelCategoryId,
      }) async {
    return await apiClient.postData(AppConstants.estimatedFare, {
      "pickup_coordinates" : '[${pickupLatLng.latitude},${pickupLatLng.longitude}]',
      "destination_coordinates" : '[${destinationLatLng.latitude},${destinationLatLng.longitude}]',
      "type" : type,
      "pickup_address": pickupAddress,
      "destination_address": destinationAddress,
      "intermediate_coordinates": (extraOne && !extraTwo) ? '[[${extraOneLatLng?.latitude},${extraOneLatLng?.longitude}]]': (extraOne && extraTwo)
          ? '[[${extraOneLatLng?.latitude},${extraOneLatLng?.longitude}],[${extraTwoLatLng?.latitude}, ${extraTwoLatLng?.longitude}]]' : '',
      'parcel_weight' : parcelWeight,
      "parcel_category_id" : parcelCategoryId
    });
  }

  Future<Response> submitRideRequest(
      {required String pickupLat,
        required String pickupLng,
        required String destinationLat,
        required String destinationLng,
        required String customerCurrentLat,
        required String customerCurrentLng,
        required String vehicleCategoryId,
        required String estimatedDistance,
        required String estimatedTime,
        required String estimatedFare,
        required String note,
        required String paymentMethod,
        required String type,
        required String pickupAddress,
        required String destinationAddress,
        required String encodedPolyline,
        required List<String> middleAddress,
        required String entrance,
        String? areaId,
        String extraLatOne = '',
        String extraLngOne = '',
        String extraLatTwo = '',
        String extraLngTwo = '',
        bool extraOne = false,
        bool extraTwo = false,
        String? senderName,
        String? senderPhone,
        String? senderAddress,
        String? receiverName,
        String? receiverPhone,
        String? receiverAddress,
        String? parcelCategoryId,
        String? weight,
        String? payer,
      }) async {
    return await apiClient.postData(AppConstants.rideRequest, {
      "pickup_coordinates" : '[$pickupLat,$pickupLng]',
      "destination_coordinates" : '[$destinationLat,$destinationLng]',
      "customer_coordinates": '[$customerCurrentLat,$customerCurrentLng]',
      "customer_request_coordinates": '[$customerCurrentLat,$customerCurrentLng]',
      "vehicle_category_id" : vehicleCategoryId,
      "estimated_distance": estimatedDistance.replaceAll('km', ''),
      "estimated_time": estimatedTime.replaceAll('min', ''),
      "estimated_fare": estimatedFare,
      "note" : note,
      "payment_method" : paymentMethod,
      "type" : type,
      "pickup_address": pickupAddress,
      "destination_address": destinationAddress,
      "intermediate_addresses" : jsonEncode(middleAddress),
      "entrance": entrance,
      "intermediate_coordinates": (extraOne && !extraTwo)?'[[$extraLatOne,$extraLngOne]]':(extraOne && extraTwo)?'[[$extraLatOne,$extraLngOne],[$extraLatTwo, $extraLngTwo]]': null,
      "area_id" : areaId,
      "sender_name" : senderName,
      "sender_phone" : senderPhone,
      "sender_address": senderAddress,
      "receiver_name": receiverName,
      "receiver_phone": receiverPhone,
      "receiver_address" : receiverAddress,
      "parcel_category_id" : parcelCategoryId,
      "weight" : weight,
      "payer" : payer,
      "encoded_polyline" : encodedPolyline,
    });
  }
  Future<Response> getRideDetails(String tripId) async {
    return await apiClient.getData('${AppConstants.tripDetails}$tripId');
  }
  Future<Response> tripStatusUpdate(String id, String status) async {
    return await apiClient.postData('${AppConstants.updateTripStatus}$id',
        {
          "status": status,
          "_method" : 'put'
        });
  }

  Future<Response> remainDistance(String requestID) async {
    return await apiClient.postData(AppConstants.remainDistance, {"trip_request_id": requestID});
  }

  Future<Response> biddingList(String tripId, int offset) async {
    return await apiClient.getData('${AppConstants.biddingList}$tripId?limit=10&offset=$offset');
  }

  Future<Response> nearestDriverList(String  lat, String lng) async {
    return await apiClient.getData('${AppConstants.nearestDriverList}?latitude=$lat&longitude=$lng');
  }

  Future<Response> tripAcceptOrReject(String tripId, String type, String driverId) async {
    return await apiClient.postData(AppConstants.tripAcceptOrReject,{
      "trip_request_id": tripId,
      "action" : type,
      "driver_id" : driverId
    });
  }

  Future<Response> ignoreBidding(String biddingId) async {
    return await apiClient.postData(AppConstants.ignoreBidding, {
      "_method" : 'put',
      "bidding_id" : biddingId
    });
  }

  Future<Response> currentRideStatus() async {
    return await apiClient.getData(AppConstants.currentRideStatus);
  }

  Future<Response> getFinalFare(String id) async {
    return await apiClient.getData('${AppConstants.finalFare}?trip_request_id=$id');
  }

  Future<Response> arrivalPickupPoint(String tripId) async {
    return await apiClient.postData(AppConstants.arrivalPickupPoint,
        {
          "trip_request_id" : tripId,
          "_method" : "put"
        });
  }

  Future<Response> getDriverLocation(String tripId) async {
    return await apiClient.getData('${AppConstants.arrivalPickupPoint}=$tripId');
  }

  Future<Response?> getDirection({required LatLng pickupLatLng, required LatLng destinationLatLng, required LatLng extraOneLatLng, required LatLng extraTwoLatLng}) async {
    return await apiClient.getData('/api/get-direction?origin=${pickupLatLng.latitude}'
        ',${pickupLatLng.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}'
        '&waypoints=${extraOneLatLng.latitude},${extraOneLatLng.longitude}|${extraTwoLatLng.latitude},${extraTwoLatLng.longitude}');
  }

  Future<Response> applyCoupon(String couponCode, String tripId) async {
    return await apiClient.postData(AppConstants.applyCoupon,

        {
          "_method":"put",
          "trip_request_id": tripId,
          "coupon_code" : couponCode
        });
  }

  Future<Response> removeCoupon(String tripId) async {
    return await apiClient.postData(AppConstants.removeCoupon,

        {
          "_method":"put",
          "trip_request_id": tripId,
        });
  }

}