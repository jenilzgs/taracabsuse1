import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class TripRepo {
  final ApiClient apiClient;
  TripRepo({required this.apiClient});

  Future<Response> getTripList(String tripType, int offset, String from, String to, String status) async {
    return await apiClient.getData('${AppConstants.tripList}?type=ride_request&limit=20&offset=$offset&filter=$status&start=$from&end=$to');
  }

}