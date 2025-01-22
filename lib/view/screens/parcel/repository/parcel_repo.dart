import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ParcelRepo {
  final ApiClient apiClient;
  ParcelRepo({required this.apiClient});

  Future<Response> getParcelCategory() async {
    return await apiClient.getData(AppConstants.parcelCategoryUri);
  }

  Future<Response> getSuggestedVehicleCategory(String weight) async {
    return await apiClient.getData('${AppConstants.suggestedVehicleCategory}$weight');
  }

  Future<Response> getOnGoingParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelOngoingList);
  }
  Future<Response> getUnpaidParcelList(int offset) async {
    return await apiClient.getData(AppConstants.parcelUnpaidList);
  }
}