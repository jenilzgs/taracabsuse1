import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/view/screens/notification/model/notification_model.dart';
import 'package:ride_sharing_user_app/view/screens/notification/repository/notification_repo.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({required this.notificationRepo});



  bool isLoading = false;
  NotificationsModel? notificationModel;


  Future<void> getNotificationList(int offset, {bool reload = false}) async {
    isLoading = true;
      Response response = await notificationRepo.getNotificationList(offset);
      if (response.statusCode == 200) {
        if(offset == 1){
          notificationModel = NotificationsModel.fromJson(response.body);
        }else{
          notificationModel!.data!.addAll(NotificationsModel.fromJson(response.body).data!);
          notificationModel!.offset = NotificationsModel.fromJson(response.body).offset;
          notificationModel!.totalSize = NotificationsModel.fromJson(response.body).totalSize;
        }
        isLoading = false;
      } else {
        isLoading = false;
        ApiChecker.checkApi(response);
      }
      update();

  }



}