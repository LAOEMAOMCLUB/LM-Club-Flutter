// otpEvent helps to track all users actions to make API calls.

import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';

abstract class OtpEvent {
  OtpEvent._();

  factory OtpEvent.verifyOtp(ForgotPasswordModel model) => VerifyOtp(model);
  factory OtpEvent.forgotPassword(ForgotPasswordModel model) =>
      ForgotPassword(model);
}

class VerifyOtp extends OtpEvent {
  final ForgotPasswordModel model;
  VerifyOtp(this.model) : super._();
}

class ForgotPassword extends OtpEvent {
  final ForgotPasswordModel model;
  ForgotPassword(this.model) : super._();
}
