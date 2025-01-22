import 'package:get/get.dart';
import 'package:ride_sharing_user_app/data/api_checker.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';
import 'package:ride_sharing_user_app/view/screens/auth/model/sign_up_body.dart';
import 'package:ride_sharing_user_app/view/screens/auth/repository/auth_repo.dart';
import 'package:ride_sharing_user_app/view/screens/auth/sign_in_screen.dart';
import 'package:ride_sharing_user_app/view/screens/dashboard/controller/bottom_menu_controller.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/reset_password_screen.dart';
import 'package:ride_sharing_user_app/view/screens/forgot_password/verification_screen.dart';
import 'package:ride_sharing_user_app/view/screens/profile/controller/profile_controller.dart';
import 'package:ride_sharing_user_app/view/screens/profile/edit_profile_screen.dart';
import 'package:ride_sharing_user_app/view/screens/ride/controller/ride_controller.dart';
import 'package:ride_sharing_user_app/view/widgets/custom_snackbar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  String _verificationCode = '';
  bool _isActiveRememberMe = false;
  bool otpVerifying = false;
  String countryDialCode = '+63';
  bool get isLoading => _isLoading;
  String get verificationCode => _verificationCode;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void setCountryCode( String countryCode){
    countryDialCode  = countryDialCode;
    update();
  }

  Future<void> login(String countryCode, String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.login(phone: countryCode+phone, password: password);
    if(response!.statusCode == 200){
      _isLoading = false;
      setUserToken(response.body['data']['token']);
      updateToken();
      await Get.find<ProfileController>().getProfileInfo();
      _navigateLogin(phone, password);
    }else if(response.statusCode == 202) {
      _isLoading = false;
      if(response.body['data']['is_phone_verified'] == 0) {
        Get.to(() =>  VerificationScreen(number: countryCode + phone, fromOtpLogin: true));
      }
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();

  }

  Future<void> logOut() async {
    Response? response = await authRepo.logOut();
    if(response!.statusCode == 200){
      Get.back();
      Get.offAll(const SignInScreen());
      showCustomSnackBar('successfully_logout'.tr, isError: false);
      clearSharedData();
    }else{
      ApiChecker.checkApi(response);
    }
    update();

  }

  Future<void> register(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.registration(signUpBody: signUpBody);
    if(response!.statusCode == 200){
      login('',signUpBody.phone!, signUpBody.password!);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();

  }

  void _navigateLogin(String phone, String password){
    if (_isActiveRememberMe) {
      saveUserNumberAndPassword(phone, password);
    } else {
      clearUserNumberAndPassword();
    }
    Get.find<BottomMenuController>().resetNavBar();
    Get.find<BottomMenuController>().navigateToDashboard();
  }

  Future<Response> sendOtp(String phone) async{
    _isLoading = true;
    update();
    Response? response = await authRepo.sendOtp(phone: phone);
    if(response!.statusCode == 200){
      _isLoading = false;
      showCustomSnackBar('otp_sent_successfully'.tr, isError: false);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
    return response;
  }

  Future<Response> otpVerification(String phone, String otp, {bool accountVerification = false}) async{
    otpVerifying = true;
    update();
    Response? response = await authRepo.verifyOtp(phone: phone, otp: otp);
    if(response!.statusCode == 200) {
      otpVerifying = false;
      if(response.body['response_code'] == 'otp_mismatch_404') {
        ApiChecker.checkApi(response);
      } else {
        _verificationCode = '';
        updateVerificationCode('');
        if(accountVerification) {
          setUserToken(response.body['data']['token']);
          updateToken();
          await Get.find<ProfileController>().getProfileInfo();
          if(response.body['data']['is_profile_verified'] == 0) {
            Get.offAll(() => const EditProfileScreen(fromLogin: true));
          }else {
            Get.find<BottomMenuController>().navigateToDashboard();
          }
        }else{
          otpVerifying = false;
          Get.to(() =>  ResetPasswordScreen(phoneNumber: phone));
        }
      }
    }else{
      otpVerifying = false;
      ApiChecker.checkApi(response);
    }
    otpVerifying = false;
    update();
    return response;
  }

  Future<Response> otpLogin(String phone, String otp, {bool fromOtpLogin = false}) async{
    _isLoading = true;
    update();
    Response? response = await authRepo.otpLogin(phone: phone, otp: otp);
    if(response!.statusCode == 200){
      updateToken();
      Map map = response.body;
      String token = '';
      token = map['data']['token'];
      setUserToken(token);
      _isLoading = false;
      if(fromOtpLogin) {
        Get.find<BottomMenuController>().navigateToDashboard();
      }else{
        Get.to(() =>  ResetPasswordScreen(phoneNumber: phone));
      }

    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
    return response;
  }

  Future<void> forgetPassword(String phone) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.forgetPassword(phone);
    if (response!.statusCode  == 200) {
      _isLoading = false;
      customSnackBar('successfully_sent_otp'.tr, isError: false);
    }else{
      _isLoading = false;
      customSnackBar('invalid_number'.tr);
    }
    update();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<void> resetPassword(String phone, String password) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.resetPassword(phone, password);
    if (response!.statusCode == 200) {

      customSnackBar('password_change_successfully'.tr, isError: false);
      Get.offAll(()=> const SignInScreen());
    }else{
      customSnackBar(response.body['message']);
    }
    _isLoading = false;
    update();
  }

  Future<void> changePassword(String password, String newPassword) async {
    _isLoading = true;
    update();
    Response? response = await authRepo.changePassword(password, newPassword);
    if (response!.statusCode == 200) {
      Get.back();
      customSnackBar('password_change_successfully'.tr, isError: false);
    }else{
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    update();
  }

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future <bool> clearSharedData() async {
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  Future <void> setUserToken(String token) async{
    authRepo.saveUserToken(token);
  }

}