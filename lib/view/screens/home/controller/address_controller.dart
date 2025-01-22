import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';
import 'package:ride_sharing_user_app/view/screens/home/repository/address_repo.dart';


class AddressController extends GetxController implements GetxService {
  final AddressRepo addressRepo;
  AddressController({required this.addressRepo});

  List<Address>? addressList;

  bool isLoading = false;
  int? _currentIndex = 0;
  int? get currentIndex => _currentIndex;

  List<AddressTypeModel> addressTypeList = [
    AddressTypeModel('home', Images.homeOutline),
    AddressTypeModel('office', Images.office),
    AddressTypeModel('others', Images.other),
    ];

  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;
  String  selectAddress = 'home';

  void updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    selectAddress = addressTypeList[_selectAddressIndex].title;
    if(notify) {
      update();
    }
  }

  Future<void> addNewAddress(Address address, {bool updateAddress = false}) async {
    isLoading = true;
    update();
    Response? response;
    if(updateAddress){
      response = await addressRepo.updateAddress(address);
    }else{
      response = await addressRepo.addNewAddress(address);
    }
    if(response!.statusCode == 200) {
      getAddressList(1);
      Get.back();
      isLoading = false;
      showCustomSnackBar('address_added_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();

  }

  Future<void> getAddressList(int offset) async {
    isLoading = true;

    Response? response = await addressRepo.getAddressList(offset);
    if(response!.statusCode == 200 && response.body['data'] != null){
      addressList = [];
      isLoading = false;
      addressList!.addAll(AddressModel.fromJson(response.body).data!);
    }else{
      isLoading = false;
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();

  }

  Future<void> deleteAddress(String addressId) async {
    isLoading = true;
    update();
    Response? response = await addressRepo.deleteAddress(addressId);
    if(response!.statusCode == 200){
      Get.back();
      isLoading = false;
      getAddressList(1);
      showCustomSnackBar('address_deleted_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    isLoading = false;
    update();

  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }
}


class AddressTypeModel{
  final String title;
  final String icon;

  AddressTypeModel(this.title, this.icon);
}