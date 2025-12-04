import 'package:get/get.dart';
import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/features/verification/domein/models/verification_data_model.dart';
import 'package:sixam_mart/features/verification/domein/services/verification_service_interface.dart';

class VerificationController extends GetxController implements GetxService {
  final VerificationServiceInterface verificationServiceInterface;

  VerificationController({required this.verificationServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationCode = '';
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query, {bool canUpdate = true}) {
    _verificationCode = query;
    if(canUpdate){
      update();
    }
  }

  Future<ResponseModel> forgetPassword({String? phone, String? email}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.forgetPassword(phone: phone, email: email);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword({String? resetToken, String? phone, String? email, required String password, required String confirmPassword}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.resetPassword(resetToken: resetToken, phone: phone, email: email, password: password, confirmPassword: confirmPassword);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone({required VerificationDataModel data}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyPhone(data);
    if(responseModel.isSuccess && responseModel.authResponseModel != null && responseModel.authResponseModel!.isExistUser == null && responseModel.authResponseModel!.isPersonalInfo!) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyToken({String? phone, String? email}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyToken(phone: phone, email: email,token: _verificationCode);
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType, required String? token, required bool isSignUpPage, required bool isForgetPassPage}) async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await verificationServiceInterface.verifyFirebaseOtp(phoneNumber: phoneNumber, session: session, otp: otp, loginType: loginType, token: token, isSignUpPage: isSignUpPage, isForgetPassPage: isForgetPassPage);

    if (responseModel.isSuccess && isSignUpPage && !isForgetPassPage) {
      Get.find<ProfileController>().getUserInfo();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

}