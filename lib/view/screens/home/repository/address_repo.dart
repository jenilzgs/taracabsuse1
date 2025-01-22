import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';
import 'package:ride_sharing_user_app/view/screens/home/model/address_model.dart';


class AddressRepo{
  final ApiClient apiClient;

  AddressRepo({required this.apiClient});




  Future<Response?> addNewAddress(Address address) async {
    return await apiClient.postData(AppConstants.addNewAddress, address.toJson());
  }
  Future<Response?> updateAddress(Address address) async {
    Map<String, dynamic> fields = {};
    fields.addAll(<String, dynamic>{
      'latitude': address.latitude,
      'longitude' : address.longitude,
      'address': address.address,
      'address_label': address.addressLabel,
      'id': address.id,
      'street': address.street,
      'contact_person_name': address.contactPersonName,
      'contact_person_phone': address.contactPersonPhone,
      'zone_id' : address.zoneId,
      "_method" : "put"
    });
    return await apiClient.postData(AppConstants.updateAddress, fields);
  }


  Future<Response?> getAddressList(int offset) async {
    return await apiClient.getData('${AppConstants.getAddressList}$offset');
  }

  Future<Response?> deleteAddress(String addressId) async {
    return await apiClient.postData(AppConstants.deleteAddress,{
      '_method' : "delete",
      "address_id" : addressId
    });
  }


}