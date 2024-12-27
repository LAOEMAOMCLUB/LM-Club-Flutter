// forgotPasswordEventPage helps to track all users actions to make API calls.

import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';

abstract class ForgotPasswordEvent {
  ForgotPasswordEvent._();
  factory ForgotPasswordEvent.forgotPassword(ForgotPasswordModel model) =>
      ForgotPassword(model);
  factory ForgotPasswordEvent.resetPassword(ForgotPasswordModel model) =>
      ResetPassword(model);
}

class ForgotPassword extends ForgotPasswordEvent {
  final ForgotPasswordModel model;
  ForgotPassword(this.model) : super._();
}

class ResetPassword extends ForgotPasswordEvent {
  final ForgotPasswordModel model;
  ResetPassword(this.model) : super._();
}
