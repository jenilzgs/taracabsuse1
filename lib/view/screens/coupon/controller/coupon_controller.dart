import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/model/coupon_model.dart';
import 'package:ride_sharing_user_app/view/screens/coupon/repository/coupon_repo.dart';

class CouponController extends GetxController implements GetxService {
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});

  bool isLoading = false;
  CouponModel? couponModel = CouponModel();
  Future<Response> getCouponList(int offset) async {
    isLoading = true;
    update();
    Response response = await couponRepo.getCouponList(offset);
    if (response.statusCode == 200) {
      if(offset == 1){
        couponModel = CouponModel.fromJson(response.body);
      }else{
        couponModel!.data!.addAll(CouponModel.fromJson(response.body).data!);
        couponModel!.offset = CouponModel.fromJson(response.body).offset;
        couponModel!.totalSize = CouponModel.fromJson(response.body).totalSize;
      }
      isLoading = false;
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }
}