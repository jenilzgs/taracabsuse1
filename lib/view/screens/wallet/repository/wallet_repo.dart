import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class WalletRepo{
  final ApiClient apiClient;

  WalletRepo({required this.apiClient});



  Future<Response?> getTransactionList(int offset) async {
    return await apiClient.getData('${AppConstants.transactionListUri}$offset');
  }

  Future<Response?> getLoyaltyPointList(int offset) async {
    return await apiClient.getData('${AppConstants.loyaltyPointListUri}$offset');
  }

  Future<Response?> convertPoint(String point) async {
    return await apiClient.postData(AppConstants.pointConvert,{
      'points' : point
    });
  }

}