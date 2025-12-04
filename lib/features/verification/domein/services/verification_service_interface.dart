import 'package:sixam_mart/common/models/response_model.dart';
import 'package:sixam_mart/features/verification/domein/models/verification_data_model.dart';

abstract class VerificationServiceInterface{
  Future<ResponseModel> forgetPassword({String? phone, String? email});
  Future<ResponseModel> resetPassword({String? resetToken, String? phone, String? email, required String password, required String confirmPassword});  Future<ResponseModel> verifyPhone(VerificationDataModel data);
  Future<ResponseModel> verifyToken({String? phone, String? email, required String token});
  Future<ResponseModel> verifyFirebaseOtp({required String phoneNumber, required String session, required String otp, required String loginType, required String? token, required bool isSignUpPage, required bool isForgetPassPage});
}