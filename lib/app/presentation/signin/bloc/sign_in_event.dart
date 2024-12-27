// signInEvent  helps to track all users actions to make API calls.

import 'package:lm_club/app/models/auth/request_model/login_req_model.dart';

abstract class SignInEvent {
  SignInEvent._();
  factory SignInEvent.signInUser(LoginReqModel userData) =>
      SignInUsingEmail(userData);
}

class SignInUsingEmail extends SignInEvent {
  final LoginReqModel userData;
  SignInUsingEmail(this.userData) : super._();
}
