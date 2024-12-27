// homeUseCasePage here we can bind model and responsemodel to show data ,message and error.

import 'package:lm_club/app/domain/auth/auth_repository.dart';
import 'package:lm_club/app/models/auth/request_model/broadcast_model.dart';
import 'package:lm_club/app/models/auth/request_model/business_broadcast_request_model.dart';
import 'package:lm_club/app/models/auth/request_model/business_enroll_model.dart';
import 'package:lm_club/app/models/auth/request_model/business_user_request.dart';
import 'package:lm_club/app/models/auth/request_model/coupons_model.dart';
import 'package:lm_club/app/models/auth/request_model/enroll_model.dart';
import 'package:lm_club/app/models/auth/request_model/forgot_password_model.dart';
import 'package:lm_club/app/models/auth/request_model/login_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/profile_req_model.dart';
import 'package:lm_club/app/models/auth/request_model/readOrdelete_model.dart';
import 'package:lm_club/app/models/auth/request_model/sharePost_broadCast_model.dart';
import 'package:lm_club/app/models/auth/request_model/userDetails_model.dart';
import 'package:lm_club/app/models/auth/response_model/account_delete.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_plan_response.dart';
import 'package:lm_club/app/models/auth/response_model/broadcast_response.dart';
import 'package:lm_club/app/models/auth/response_model/categories_response.dart';
import 'package:lm_club/app/models/auth/response_model/choose_plan_response.dart';
import 'package:lm_club/app/models/auth/response_model/coupons_response.dart';
import 'package:lm_club/app/models/auth/response_model/enroll_response.dart';
import 'package:lm_club/app/models/auth/response_model/forgot_password_response.dart';
import 'package:lm_club/app/models/auth/response_model/generatedResponse_model.dart';
import 'package:lm_club/app/models/auth/response_model/login_response.dart';
import 'package:lm_club/app/models/auth/response_model/myShareBroadCast_response.dart';
import 'package:lm_club/app/models/auth/response_model/notifications_response.dart';
import 'package:lm_club/app/models/auth/response_model/plan_details.dart';
import 'package:lm_club/app/models/auth/response_model/readOrdeleteNotification.dart';
import 'package:lm_club/app/models/auth/response_model/referEarn_response.dart';
import 'package:lm_club/app/models/auth/response_model/referalCode_response.dart';
import 'package:lm_club/app/models/auth/response_model/savedBeehive_response.dart';
import 'package:lm_club/app/models/auth/response_model/sharePostResponse.dart';
import 'package:lm_club/app/models/auth/response_model/shareTypeBroadCast_response.dart';
import 'package:lm_club/app/models/auth/response_model/viewBroadcast_response.dart';
import 'package:lm_club/app/models/auth/response_model/widgets_response.dart';
import '../../../models/auth/request_model/beehive_model.dart';
import '../../../models/auth/request_model/saveOrLike_model.dart';
import '../../../models/auth/response_model/beehiveUpload_response.dart';
import '../../../models/auth/response_model/beehive_response.dart';
import '../../../models/auth/response_model/checkout_response.dart';
import '../../../models/auth/response_model/cities_response.dart';
import '../../../models/auth/response_model/myPostbeehive_response.dart';
import '../../../models/auth/response_model/saveOrLikePost_response.dart';
import '../../../models/auth/response_model/state_response.dart';
import '../../../models/auth/response_model/user_details.dart';

class HomeUsecase {
  final AuthRepository _authRepository;

  HomeUsecase(this._authRepository);

  Future<EnrollResModel> enroll(EnrollModel userData) {
    return _authRepository.enroll(userData);
  }

  Future<CheckoutResponse> checkout(Map<String, dynamic> checkout) {
    return _authRepository.checkOut(checkout);
  }

  Future<CheckoutResponse> broadcastCheckOut(Map<String, dynamic> checkout) {
    return _authRepository.broadcastCheckOut(checkout);
  }

  Future<UploadBroadCastResponse> uploadBroadcast(BroadcastModel model) {
    return _authRepository.uploadBroadcast(model);
  }

  Future<UploadBroadCastResponse> editBusinessBroadcast(
      BusinessBroadcastModel model) {
    return _authRepository.updateDraftBusinessBroadcast(model);
  }

  Future<UploadBroadCastResponse> uploadBusinessBroadcast(
      BusinessBroadcastModel model) {
    return _authRepository.uploadBusinessBroadcast(model);
  }

  Future<BroadcastDetailsResponse> getBroadcasts(Map<String, dynamic> model) {
    return _authRepository.getBroadcasts(model);
  }

  Future<BroadcastPlanResponse> getBroadcastPlans() {
    return _authRepository.getBroadcastPlans();
  }

  Future<EnrollResModel> addCoupon(CouponsModel model) {
    return _authRepository.addCoupon(model);
  }

  Future<CouponsResponse> getCoupons() {
    return _authRepository.getCoupons();
  }

  Future<ChoosePlanResponse> getAllPlans() {
    return _authRepository.getAllPlans();
  }

  Future<LoginResponseModel> login(LoginReqModel userData) {
    return _authRepository.login(userData);
  }

  Future<UserDetailsResponse> getUserDetails(String id) {
    return _authRepository.getUserDetails(id);
  }

  Future<UserDetailsResponse> updateUserDetails(UserDetailsRequestModel model) {
    return _authRepository.updateUserDetails(model);
  }

  Future<UserDetailsResponse> updateBusinessUserDetails(
      BusinessUserDetailsRequestModel model) {
    return _authRepository.updateBusinessUserDetails(model);
  }

  Future<PlanDetailsResponse> getplan(String id) {
    return _authRepository.getplan(id);
  }

  Future<WidgetsResponse> getWidgets(String id) {
    return _authRepository.getWidgets(id);
  }

  Future<CitiesResponse> getCities(StateData stateId) {
    return _authRepository.getCities(stateId);
  }

  Future<StateResponse> getStates() {
    return _authRepository.getStates();
  }

  Future<BroadcastDetailsResponse> getMyBroadcasts(Map<String, dynamic> model) {
    return _authRepository.getMyBroadcasts(model);
  }

  Future<MySharesBroadcastResponse> myShares() {
    return _authRepository.myShares();
  }

  Future<ShareTypeResponse> shareTypes() {
    return _authRepository.shareTypes();
  }

  Future<SharePostResponse> sharePost(SharePostModel model) {
    return _authRepository.sharePost(model);
  }

  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordModel model) {
    return _authRepository.forgotPassword(model);
  }

  Future<ForgotPasswordResponse> resendOtp(ForgotPasswordModel model) {
    return _authRepository.resendOtp(model);
  }

  Future<ForgotPasswordResponse> verifyOtp(ForgotPasswordModel model) {
    return _authRepository.verifyOtp(model);
  }

  Future<ForgotPasswordResponse> resetPassword(ForgotPasswordModel model) {
    return _authRepository.resetPassword(model);
  }

  Future<UserDetailsResponse> uploadProfileImage(ProfileRequestModel model) {
    return _authRepository.uploadProfileImage(model);
  }

  Future<GeneratedAcceleratedResponse> generateAcceratedUrl(
      ProfileRequestModel model) {
    return _authRepository.generateAcceratedUrl(model);
  }

  Future<ReferEarnResponse> getUserPoints() {
    return _authRepository.getUserPoints();
  }

  Future<ReferalCodeResponse> getReferalCode() {
    return _authRepository.getReferalCode();
  }

  Future<BeehiveResponse> getBeehivePosts(Map<String, dynamic> model) {
    return _authRepository.getBeehivePosts(model);
  }

  Future<MyPostBeehiveResponse> myPostsBeehive(Map<String, dynamic> model) {
    return _authRepository.myPostsBeehive(model);
  }

  Future<BeehiveCategoriesResponse> getBeehiveCategories() {
    return _authRepository.getBeehiveCategories();
  }

  Future<BeehiveUploadResponse> uploadBeehive(BeehiveModel model) {
    return _authRepository.uploadBeehive(model);
  }

  Future<SaveOrLikePostResponse> saveOrLikePost(SaveOrLikeModel model) {
    return _authRepository.saveOrLikePost(model);
  }

  Future<SavedBeehiveResponse> mySavedPosts(Map<String, dynamic> model) {
    return _authRepository.mySavedPosts(model);
  }

  Future<EnrollResModel> validateReferalCode(Map<String, dynamic> model) {
    return _authRepository.validateReferalCode(model);
  }

  Future<EnrollResModel> businessEnroll(BusinessEnrollModel data) {
    return _authRepository.businessEnroll(data);
  }

  Future<ViewBroadcastDetailsResponse> viewBroadcastPost(String id) {
    return _authRepository.viewBroadcastPost(id);
  }

  Future<NotificationResponseModel> getUserNotifications() {
    return _authRepository.getUserNotifications();
  }

  Future<UploadBroadCastResponse> viewNotification(String id) {
    return _authRepository.viewNotification(id);
  }

  Future<UploadBroadCastResponse> markAllAsRead() {
    return _authRepository.markAllAsRead();
  }

  Future<ReadOrDeleteNotifications> readOrDeleteNotifications(
      ReadOrDeleteModel model) {
    return _authRepository.readOrDeleteNotifications(model);
  }

  Future<UploadBroadCastResponse> deleteFile(Map<String, dynamic> model) {
    return _authRepository.deleteFile(model);
  }

  Future<AccountDeleteResponse> deleteAccount() {
    return _authRepository.deleteAccount();
  }
}
