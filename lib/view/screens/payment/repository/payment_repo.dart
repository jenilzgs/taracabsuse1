
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class PaymentRepo {
  final ApiClient apiClient;

  PaymentRepo({required this.apiClient});


  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment
    });
  }

  Future<Response> paymentSubmit(String tripId, String paymentMethod ) async {
    return await apiClient.getData('${AppConstants.paymentUri}?trip_request_id=$tripId&payment_method=$paymentMethod');
  }


}