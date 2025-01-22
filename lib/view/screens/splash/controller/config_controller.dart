import 'package:get/get.dart';
import 'package:ride_sharing_user_app/view/screens/splash/model/config_model.dart';
import 'package:ride_sharing_user_app/view/screens/splash/repo/config_repo.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';

class ConfigController extends GetxController implements GetxService {
  final ConfigRepo configRepo;
  ConfigController({required this.configRepo});

  ConfigModel? _config;

  ConfigModel? get config => _config;

  bool loading = false;
  Future<Response> getConfigData({bool reload= false}) async {
    loading = true;
    if(loading){
      update();
    }
    Response response = await configRepo.getConfigData();
    if(response.statusCode == 200) {
      loading = false;
      _config = ConfigModel.fromJson(response.body);
    }else {loading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;

  }

  Future<bool> initSharedData() {
    return configRepo.initSharedData();
  }

  Future<bool> removeSharedData() {
    return configRepo.removeSharedData();
  }

  bool showIntro() {
    return configRepo.showIntro()!;

  }
  void disableIntro() {
    configRepo.disableIntro();
  }

}