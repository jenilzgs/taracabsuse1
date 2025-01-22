import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ride_sharing_user_app/data/api_client.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

class ProfileRepo {
  final ApiClient apiClient;
  ProfileRepo({required this.apiClient});

  Future<Response?> getProfileInfo() async {
    return await apiClient.getData(AppConstants.profileInfo);
  }

  Future<Response?> updateProfileInfo(String firstName, String lastname, String identification, String idType, XFile? profile, List<MultipartBody>? identityImage) async {
    Map<String, String> fields = <String, String> {
      '_method': 'put',
      'first_name': firstName,
      'last_name': lastname,
      "identification_number" : identification,
      "identification_type" : idType
    };
    return await apiClient.postMultipartData(
      AppConstants.updateProfileInfo,
      fields,
      MultipartBody('profile_image',profile),
      identityImage!,
    );
  }

}