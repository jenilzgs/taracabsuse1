import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class NotificationRepo {
  final ApiClient apiClient;
  NotificationRepo({required this.apiClient});

  Future<Response> getNotificationList(int offset) async {
    return await apiClient.getData('${AppConstants.notificationList}$offset');
  }


}