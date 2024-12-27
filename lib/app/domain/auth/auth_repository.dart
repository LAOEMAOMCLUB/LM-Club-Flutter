// authRepositoryPage binds response page and model page 

import 'package:lm_club/app/models/auth/request_model/beehive_model.dart';
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
import 'package:lm_club/app/models/auth/response_model/saveOrLikePost_response.dart';
import 'package:lm_club/app/models/auth/response_model/savedBeehive_response.dart';
import 'package:lm_club/app/models/auth/response_model/sharePostResponse.dart';
import 'package:lm_club/app/models/auth/response_model/shareTypeBroadCast_response.dart';
import 'package:lm_club/app/models/auth/response_model/user_details.dart';
import 'package:lm_club/app/models/auth/response_model/viewBroadcast_response.dart';
import 'package:lm_club/app/models/auth/response_model/widgets_response.dart';
import '../../models/auth/request_model/saveOrLike_model.dart';
import '../../models/auth/response_model/beehiveUpload_response.dart';
import '../../models/auth/response_model/beehive_response.dart';
import '../../models/auth/response_model/checkout_response.dart';
import '../../models/auth/response_model/cities_response.dart';
import '../../models/auth/response_model/myPostbeehive_response.dart';
import '../../models/auth/response_model/state_response.dart';

abstract class AuthRepository {
  Future<EnrollResModel> enroll(EnrollModel model);
  Future<UploadBroadCastResponse> uploadBroadcast(BroadcastModel model);
  Future<UploadBroadCastResponse> uploadBusinessBroadcast(
      BusinessBroadcastModel model);
  Future<BroadcastDetailsResponse> getBroadcasts(Map<String, dynamic> model);
  Future<BroadcastPlanResponse> getBroadcastPlans();
  Future<EnrollResModel> addCoupon(CouponsModel model);
  Future<CouponsResponse> getCoupons();
  Future<ChoosePlanResponse> getAllPlans();
  Future<CitiesResponse> getCities(StateData id);
  Future<StateResponse> getStates();
  Future<LoginResponseModel> login(LoginReqModel model);
  Future<PlanDetailsResponse> getplan(String id);
  Future<WidgetsResponse> getWidgets(String id);
  Future<UserDetailsResponse> getUserDetails(String id);
  Future<UserDetailsResponse> updateUserDetails(UserDetailsRequestModel model);
  Future<UserDetailsResponse> updateBusinessUserDetails(
      BusinessUserDetailsRequestModel model);
  Future<BroadcastDetailsResponse> getMyBroadcasts(Map<String, dynamic> model);
  Future<MySharesBroadcastResponse> myShares();
  Future<ShareTypeResponse> shareTypes();
  Future<SharePostResponse> sharePost(SharePostModel model);
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordModel model);
  Future<ForgotPasswordResponse> resendOtp(ForgotPasswordModel model);
  Future<ForgotPasswordResponse> verifyOtp(ForgotPasswordModel model);
  Future<ForgotPasswordResponse> resetPassword(ForgotPasswordModel model);
  Future<UserDetailsResponse> uploadProfileImage(ProfileRequestModel model);
  Future<GeneratedAcceleratedResponse> generateAcceratedUrl(
      ProfileRequestModel model);
  Future<CheckoutResponse> checkOut(Map<String, dynamic> model);
  Future<CheckoutResponse> broadcastCheckOut(Map<String, dynamic> model);
  Future<ReferEarnResponse> getUserPoints();
  Future<ReferalCodeResponse> getReferalCode();
  Future<BeehiveResponse> getBeehivePosts(Map<String, dynamic> model);
  Future<MyPostBeehiveResponse> myPostsBeehive(Map<String, dynamic> model);
  Future<SavedBeehiveResponse> mySavedPosts(Map<String, dynamic> model);
  Future<BeehiveCategoriesResponse> getBeehiveCategories();
  Future<BeehiveUploadResponse> uploadBeehive(BeehiveModel model);
  Future<SaveOrLikePostResponse> saveOrLikePost(SaveOrLikeModel model);
  Future<EnrollResModel> validateReferalCode(Map<String, dynamic> model);
  Future<EnrollResModel> businessEnroll(BusinessEnrollModel model);
  Future<ViewBroadcastDetailsResponse> viewBroadcastPost(String id);

  Future<UploadBroadCastResponse> updateDraftBusinessBroadcast(
      BusinessBroadcastModel model);
  Future<NotificationResponseModel> getUserNotifications();

  Future<UploadBroadCastResponse> viewNotification(String id);
  Future<ReadOrDeleteNotifications> readOrDeleteNotifications(
      ReadOrDeleteModel model);

  Future<UploadBroadCastResponse> markAllAsRead();
  Future<UploadBroadCastResponse> deleteFile(Map<String, dynamic> model);
  Future<AccountDeleteResponse> deleteAccount();
}
