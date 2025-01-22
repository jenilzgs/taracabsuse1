import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.getZone}?lat=$lat&lng=$lng');
  }

  Future<Response> getAddressFromGeocode(LatLng? latLng) async {
    return await apiClient.getData('${AppConstants.geoCodeURI}?lat=${latLng!.latitude}&lng=${latLng.longitude}');
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.placeApiDetails}?placeid=$placeID');
  }

  Future<bool> saveUserAddress(Address? address) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token) ?? '', address,
    );
    if(address == null) {
      if(sharedPreferences.containsKey(AppConstants.userAddress)) {
        return await sharedPreferences.remove(AppConstants.userAddress);
      }else {
        return true;
      }
    }else {
      return await sharedPreferences.setString(AppConstants.userAddress, jsonEncode(address.toJson()));
    }
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

}
