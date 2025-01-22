import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ride_sharing_user_app/util/images.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:ride_sharing_user_app/view/screens/location/controller/location_controller.dart';
import 'package:ride_sharing_user_app/view/screens/location/view/access_location_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/confirmation_dialog.dart';

class BottomMenuController extends GetxController implements GetxService{

  int _currentTab = 0;
  int get currentTab => _currentTab;

  void resetNavBar() {
    _currentTab = 0;
  }

  void setTabIndex(int index) {
    _currentTab = index;
     update();
  }

  void navigateToDashboard() {
    _currentTab = 0;
    if(Get.find<LocationController>().getUserAddress() != null) {
      Get.offAll(const DashboardScreen());
    }else {
      Get.offAll(const AccessLocationScreen());
    }
  }

  void exitApp() {
    Get.dialog(ConfirmationDialog(
      icon: Images.profileLogout,
      description: 'do_you_want_to_exit_the_app'.tr,
      onYesPressed:() => SystemNavigator.pop(),
    ), barrierDismissible: false);
  }

}
