import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/auth/model/sign_up_body.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response?> login({required String phone, required String password}) async {
    return await apiClient.postData(AppConstants.loginUri, {"phone_or_email": phone, "password": password});
  }

  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.logOutUri, {});}



  Future<Response?> registration({required SignUpBody signUpBody}) async {
    return await apiClient.postData(AppConstants.registration, signUpBody.toJson());
  }




  Future<Response?> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.forgetPassword,
        {"phone_or_email": phone});
  }

  Future<Response?> verifyOtp({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpVerification,
        {"phone_or_email": phone,
          "otp": otp
        });
  }





  Future<Response?> otpLogin({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.otpLogin,
        {"phone_or_email": phone,
          "otp": otp
        });
  }


  Future<Response?> resetPassword(String phoneOrEmail, String password) async {
    return await apiClient.postData(AppConstants.resetPassword,
      { "phone_or_email": phoneOrEmail,
        "password": password,},
    );
  }

  Future<Response?> changePassword(String oldPassword, String password) async {
    return await apiClient.postData(AppConstants.changePassword,
      { "password": oldPassword,
        "new_password": password,
      },
    );
  }

  Future<Response?> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }

    if(!GetPlatform.isWeb){

        FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);

    }
    return await apiClient.postData(AppConstants.fcmTokenUpdate, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    }catch(e) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }



  Future<Response?> forgetPassword(String? phone) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone});
  }

  Future<Response?> verifyToken(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone_or_email": phone.substring(1,phone.length-1), "otp": otp});
  }


  Future<Response?> checkEmail(String email) async {
    return await apiClient.postData(AppConstants.configUri, {"email": email});
  }

  Future<Response?> verifyEmail(String email, String token) async {
    return await apiClient.postData(AppConstants.configUri, {"email": email, "token": token});
  }



  Future<Response?> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.configUri, {"phone": phone, "otp": otp});
  }

  Future<bool?> saveUserToken(String token) async {
    Address? address;
    try {
      address = Address.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!));
      // ignore: empty_catches
    }catch(e) {}
    apiClient.updateHeader(token, address);
    return await sharedPreferences.setString(AppConstants.token, token);

  }


  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);

    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
   return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }



  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";

  }



  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.userAddress);
    return true;
  }
}
