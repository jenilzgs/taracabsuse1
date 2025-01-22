import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/main.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/map/controller/map_controller.dart';
import 'package:ride_sharing_user_app/view/screens/map/map_screen.dart';
import 'package:ride_sharing_user_app/view/screens/message/controller/message_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/controller/parcel_controller.dart';
import 'package:ride_sharing_user_app/view/screens/parcel/widgets/driver_request_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/payment/payment_screen.dart';
import 'package:ride_sharing_user_app/view/screens/payment/review_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/screens/ride/widgets/confirmation_trip_dialog.dart';
import 'package:ride_sharing_user_app/view/screens/splash/controller/config_controller.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // TODO: Route
        // try{
        //   if(payload != null && payload.isNotEmpty) {
        //     Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(payload)));
        //   }else {
        //     Get.toNamed(RouteHelper.getNotificationRoute());
        //   }
        // }catch (e) {}
        return;
      },
      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      AndroidInitializationSettings androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // TODO: Route
        // try{
        //   if(payload != null && payload.isNotEmpty) {
        //     Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(payload)));
        //   }else {
        //     Get.toNamed(RouteHelper.getNotificationRoute());
        //   }
        // }catch (e) {}
        return;
      },
      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageReceiver,
    );

    customPrint('onMessage: ${message.data}');
      if(message.data['action'] == "new_message_arrived"){
        Get.find<MessageController>().getConversation(message.data['type'], 1);
      }


    if(message.data['action'] == 'driver_assigned'){
      Get.back();
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']).then((value){
        if(value.statusCode == 200){
          Get.find<RideController>().updateRideCurrentState(RideState.otpSent);
          Get.find<MapController>().notifyMapController();
          Get.to(() => const MapScreen(fromScreen: MapScreenType.splash));
        }
      });
    }else if(message.data['action'] == 'otp_matched' && message.data['type'] == 'ride_request'){
      Get.find<MapController>().getPolyline();
      Get.find<RideController>().updateRideCurrentState(RideState.afterAcceptRider);
    }
    else if(message.data['action'] == 'trip_waited_message' && message.data['type'] == 'ride_request'){
      Get.find<RideController>().getRideDetails(message.data['ride_request_id']);
    }
    else if(message.data['action'] == 'otp_matched' && message.data['type'] == 'parcel'){
      Get.find<MapController>().getPolyline();
      Get.find<RideController>().updateRideCurrentState(RideState.afterAcceptRider);

      if(!Get.find<ParcelController>().payReceiver){
        Get.find<RideController>().getFinalFare(message.data['ride_request_id']).then((value) {
          if(value.statusCode == 200){
            Get.find<RideController>().updateRideCurrentState(RideState.completeRide);
            Get.find<MapController>().notifyMapController();
            Get.off(()=>const PaymentScreen(fromParcel: true,));
          }
        });
      }

    }
    else if(message.data['action'] == 'payment_successful'){
      if(Get.find<ConfigController>().config!.reviewStatus!){
        Get.off(()=> ReviewScreen(tripId: message.data['ride_request_id']));
        Get.find<RideController>().tripDetails = null;
      }else{
        Get.offAll(()=> const DashboardScreen());
        Get.find<RideController>().tripDetails = null;
      }

    }
    else if(message.data['action'] == 'ride_completed' &&  message.data['type'] == 'ride_request'){
      Get.dialog(const ConfirmationTripDialog(isStartedTrip: false,), barrierDismissible: false);
      Get.find<RideController>().getFinalFare(message.data['ride_request_id']).then((value) {
        if(value.statusCode == 200){
          Get.find<RideController>().updateRideCurrentState(RideState.completeRide);
          Get.find<MapController>().notifyMapController();
          Get.off(()=>const PaymentScreen());
        }
      });

    }

    else if(message.data['action'] == 'ride_completed' ||  message.data['action'] == 'parcel_completed'){
      Get.offAll(const DashboardScreen());
    }

    else if(message.data['action'] == 'ride_cancelled' &&  message.data['type'] == 'ride_request'){
      await Get.find<RideController>().getCurrentRideStatus(fromRefresh: true);
     Get.offAll(const DashboardScreen());

    }

    else if(message.data['action'] == 'driver_bid_received'){
      Get.find<RideController>().getBiddingList(message.data['ride_request_id'], 1).then((value){
        if(value.statusCode == 200){
          Get.back();
          showGeneralDialog(
            context: Get.context!,
            barrierDismissible: true,
            transitionDuration: const Duration(milliseconds: 500),
            barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
            barrierColor: Colors.black.withOpacity(0.5),
            pageBuilder: (context, _, __) {
              return DriverRideRequestDialog(tripId: message.data['ride_request_id']);
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ).drive(Tween<Offset>(
                  begin: const Offset(0, -1.0),
                  end: Offset.zero,
                )),
                child: child,
              );
            },
          );
        }
      });
    }


      NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
    });
  }

  static Future<void> hintForBetterServiceLocationTurnOn({String? body}) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(

      body??'When your\'re riding with ${AppConstants.appName}, your location is being collected for faster pick-ups and safety features. Manage permissions in your device\'s settings',
      htmlFormatBigText: true,
      contentTitle: 'Faster pick-ups, safer trips', htmlFormatContentTitle: true,
    );
    var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
        'hexaride', 'hexaride',
        channelDescription: 'progress channel description', styleInformation: bigTextStyleInformation,
        channelShowBadge: true,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: false,
        color: const Color(0xFF00A08D),
        );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(0, 'Faster pick-ups, safer trips',
        body??'When your\'re riding with ${AppConstants.appName}, your location is being collected for faster pick-ups and safety features. Manage permissions in your device\'s settings', platformChannelSpecifics,
        payload: 'item x');
  }

  // static Future<void> ongoingRideRequestProgress(int count, int i, {String? body, bool progress = true}) async {
  //
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'hexaride', 'hexaride',
  //       channelDescription: 'progress channel description',
  //       channelShowBadge: true,
  //       importance: Importance.max,
  //       priority: Priority.high,
  //       onlyAlertOnce: true,
  //       showProgress: progress,
  //       ongoing: true,
  //       color: const Color(0xFF00A08D),
  //       maxProgress: count,
  //       progress: i);
  //   var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  //   flutterLocalNotificationsPlugin.show(0, 'Your ride is ongoing',
  //       body??'Enjoy your ride', platformChannelSpecifics,
  //       payload: 'item x');
  // }


  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String title = message.data['title'];
    String body = message.data['body'];
    String? orderID = message.data['order_id'];
    String? image = (message.data['image'] != null && message.data['image'].isNotEmpty)
        ? message.data['image'].startsWith('http') ? message.data['image']
        : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}' : null;

    try{
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, image, fln);
    }catch(e) {
      await showBigPictureNotificationHiddenLargeIcon(title, body, orderID, null, fln);
      customPrint('Failed to show notification: ${e.toString()}');
    }
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String? orderID, String? image, FlutterLocalNotificationsPlugin fln) async {
    String? largeIconPath;
    String? bigPicturePath;
    BigPictureStyleInformation? bigPictureStyleInformation;
    BigTextStyleInformation? bigTextStyleInformation;
    if(image != null && !GetPlatform.isWeb) {
      largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
      bigPicturePath = largeIconPath;
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
        contentTitle: title, htmlFormatContentTitle: true,
        summaryText: body, htmlFormatSummaryText: true,
      );
    }else {
      bigTextStyleInformation = BigTextStyleInformation(
        body, htmlFormatBigText: true,
        contentTitle: title, htmlFormatContentTitle: true,
      );
    }
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '6amTech', '6amTech', priority: Priority.max, importance: Importance.max, playSound: true,
      largeIcon: largeIconPath != null ? FilePathAndroidBitmap(largeIconPath) : null,
      styleInformation: largeIconPath != null ? bigPictureStyleInformation : bigTextStyleInformation,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

}




Future<dynamic> myBackgroundMessageHandler(RemoteMessage remoteMessage) async {
  customPrint('onBackground: ${remoteMessage.data}');
  // var androidInitialize = new AndroidInitializationSettings('notification_icon');
  // var iOSInitialize = new IOSInitializationSettings();
  // var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, true);
}

Future<dynamic> myBackgroundMessageReceiver(NotificationResponse response) async {
  customPrint('onBackgroundClicked: ${response.payload}');
}