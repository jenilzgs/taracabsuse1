import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/model/loyalty_point_model.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/model/transaction_model.dart';
import 'package:ride_sharing_user_app/view/screens/wallet/repository/wallet_repo.dart';

class WalletController extends GetxController implements GetxService{
  final WalletRepo walletRepo;

  WalletController({required this.walletRepo});

  TextEditingController inputController = TextEditingController();
  FocusNode inputNode = FocusNode();

  bool isLoading = false;

  bool isConvert = false;
  void toggleConvertCard(bool value){
    isConvert = value;
    update();
  }

  TransactionModel? transactionModel;
  Future<Response> getTransactionList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.getTransactionList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        transactionModel = TransactionModel.fromJson(response.body);
      }else{
        transactionModel!.data!.addAll(TransactionModel.fromJson(response.body).data!);
        transactionModel!.offset = TransactionModel.fromJson(response.body).offset;
        transactionModel!.totalSize = TransactionModel.fromJson(response.body).totalSize;
      }

    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }


  LoyaltyPointModel? loyaltyPointModel;
  Future<Response> getLoyaltyPointList(int offset) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.getLoyaltyPointList(offset);
    if (response!.statusCode == 200) {
      isLoading = false;
      if(offset == 1){
        loyaltyPointModel = LoyaltyPointModel.fromJson(response.body);
      }else{
        loyaltyPointModel!.data!.addAll(LoyaltyPointModel.fromJson(response.body).data!);
        loyaltyPointModel!.offset = LoyaltyPointModel.fromJson(response.body).offset;
        loyaltyPointModel!.totalSize = LoyaltyPointModel.fromJson(response.body).totalSize;
      }
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }



  Future<Response> convertPoint(String point) async {
    isLoading = true;
    update();
    Response? response = await walletRepo.convertPoint(point);
    if (response!.statusCode == 200) {
     Get.find<ProfileController>().getProfileInfo();
     getTransactionList(1);
      isLoading = false;
      showCustomSnackBar('pont_converted_successfully'.tr, isError: false);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

}