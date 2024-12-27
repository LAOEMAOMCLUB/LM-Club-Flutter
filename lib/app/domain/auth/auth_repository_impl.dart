// authRepoImplementationPage this page make binds service page and data model page to get response.

import 'package:lm_club/app/data/api_services/broadcast_service.dart';
import 'package:lm_club/app/data/api_services/coupons_service.dart';
import 'package:lm_club/app/data/api_services/notification_service.dart';
import 'package:lm_club/app/data/api_services/refer_earn_service.dart';
import 'package:lm_club/app/data/api_services/shared/beehive_service.dart';
import 'package:lm_club/app/data/api_services/shared/choose_plan_service.dart';
import 'package:lm_club/app/data/api_services/shared/enroll_service.dart';
import 'package:lm_club/app/data/api_services/shared/forgot_password_service.dart';
import 'package:lm_club/app/data/api_services/shared/login_service.dart';
import 'package:lm_club/app/data/api_services/widget_service.dart';
import 'package:lm_club/app/domain/auth/auth_repository.dart';
import 'package:lm_club/app/domain/local_storage/shared_pref_repository.dart';
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
import 'package:lm_club/app/models/auth/response_model/beehiveUpload_response.dart';
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
import 'package:lm_club/utils/globals.dart' as globals;
import '../../models/auth/request_model/saveOrLike_model.dart';
import '../../models/auth/response_model/beehive_response.dart';
import '../../models/auth/response_model/checkout_response.dart';
import '../../models/auth/response_model/cities_response.dart';
import '../../models/auth/response_model/myPostbeehive_response.dart';
import '../../models/auth/response_model/saveOrLikePost_response.dart';
import '../../models/auth/response_model/state_response.dart';
import '../../models/auth/response_model/user_details.dart';

class AuthRepoImplementation extends AuthRepository {
  final EnrollService _enrollService;
  final BroadcastService _broadcastService;
  final CouponsService _couponsService;
  final ChoosePlanService _choosePlanService;
  final LoginService _loginService;
  final WidgetsService _widgetService;
  final ForgotPasswordService _forgotPasswordService;
  final ReferEarnService _referEarnService;
  final BeehiveService _beehiveService;
  final SharedPrefRepository _sharedPrefRepository;
  final NotificationService _notificationService;

  AuthRepoImplementation(
      this._enrollService,
      this._broadcastService,
      this._couponsService,
      this._choosePlanService,
      this._loginService,
      this._widgetService,
      this._sharedPrefRepository,
      this._forgotPasswordService,
      this._beehiveService,
      this._referEarnService,
      this._notificationService);

  @override
  Future<EnrollResModel> enroll(EnrollModel model) async {
    final responseData = await _enrollService.enroll(model.toJson());
    final response = EnrollResModel.fromJson(responseData.data);
    String userName = '${response.data!.username} ';
    String userId = response.data!.id.toString();
    String mobile = response.data!.mobile!;
    String role = response.data!.role!.toString();
    String token = response.accessToken!.accessToken!;
    globals.userName = userName;
    globals.userId = userId;
    globals.mobile = mobile;
    globals.token = token;
    globals.role = role;
    _sharedPrefRepository.storeData('userName', userName);
    _sharedPrefRepository.storeData('userId', userId);
    _sharedPrefRepository.storeData('mobile', mobile);
    _sharedPrefRepository.storeData('role', role);
    _sharedPrefRepository.storeData('token', token);
    return EnrollResModel.fromJson(responseData.data);
  }

  @override
  Future<UploadBroadCastResponse> uploadBroadcast(BroadcastModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _broadcastService.uploadBroadcast(token, model.toJson());
    return UploadBroadCastResponse.fromJson(response);
  }

  @override
  Future<UploadBroadCastResponse> uploadBusinessBroadcast(
      BusinessBroadcastModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _broadcastService.uploadBusinessBroadcast(token, model.toJson());
    return UploadBroadCastResponse.fromJson(response);
  }

  @override
  Future<BroadcastDetailsResponse> getBroadcasts(
      Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.getBroadcasts(token, model);
    return BroadcastDetailsResponse.fromJson(response.data);
  }

  @override
  Future<EnrollResModel> addCoupon(CouponsModel model) async {
    final response = await _couponsService.addCoupon(model.toJson());
    return EnrollResModel.fromJson(response);
  }

  @override
  Future<CouponsResponse> getCoupons() async {
    final response = await _couponsService.getCoupons();
    return CouponsResponse.fromJson(response.data);
  }

  @override
  Future<ChoosePlanResponse> getAllPlans() async {
    final response = await _choosePlanService.getAllPlans();
    return ChoosePlanResponse.fromMap(response.data);
  }

  @override
  Future<UserDetailsResponse> getUserDetails(String id) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _loginService.getUserDetails(token, id);
    final responseData = UserDetailsResponse.fromMap(response.data);
    String planStatus = responseData.data!.planStatus.toString();
    _sharedPrefRepository.storeData('planStatus', planStatus);
    String role = responseData.data!.role!.id.toString();
    String mobile = responseData.data!.mobile!;
    String city = responseData.data!.cities!.cityName!;
    String zipcode = responseData.data!.zipcode!;
    String state = responseData.data!.states!.stateName!;
    globals.role = role;
    globals.mobile = mobile;
    globals.zipcode = zipcode;
    globals.city = city;
    globals.state = state;
    globals.street = responseData.data!.street ?? '';
    _sharedPrefRepository.storeData('role', role);
    _sharedPrefRepository.storeData('zipcode', zipcode);
    _sharedPrefRepository.storeData('city', city);
    _sharedPrefRepository.storeData('state', state);
    globals.planStatus = planStatus.toString();
    return UserDetailsResponse.fromMap(response.data);
  }

  @override
  Future<UserDetailsResponse> updateUserDetails(
      UserDetailsRequestModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _loginService.updateUserDetails(token, model.toJson());
    return UserDetailsResponse.fromMap(response.data);
  }

  @override
  Future<UserDetailsResponse> updateBusinessUserDetails(
      BusinessUserDetailsRequestModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _loginService.updateUserDetails(token, model.toJson());
    return UserDetailsResponse.fromMap(response.data);
  }

  @override
  Future<LoginResponseModel> login(LoginReqModel model) async {
    final responseData = await _loginService.login(model.toJson());
    final response = LoginResponseModel.fromJson(responseData.data);
    String userName = '${response.data.username} ';
    String userId = response.data.id.toString();
    String mobile = response.data.mobile!;
    String token = response.accessToken.accessToken!;

    String role = response.data.role!.id.toString();
    _sharedPrefRepository.storeData('token', response.accessToken.accessToken!);
    globals.userName = userName;
    globals.token = token;
    globals.userId = userId;
    globals.mobile = mobile;
    globals.role = role;
    _sharedPrefRepository.storeData('role', role);
    _sharedPrefRepository.storeData('userName', userName);
    _sharedPrefRepository.storeData('userId', userId);
    _sharedPrefRepository.storeData('mobile', mobile);
    _sharedPrefRepository.storeData('token', token);
    return LoginResponseModel.fromJson(responseData.data);
  }

  @override
  Future<PlanDetailsResponse> getplan(String id) async {
    final response = await _choosePlanService.getplan(id);
    return PlanDetailsResponse.fromMap(response.data);
  }

  @override
  Future<WidgetsResponse> getWidgets(String id) async {
    final response = await _widgetService.getWidgets(id);
    return WidgetsResponse.fromJson(response.data);
  }

  @override
  Future<BroadcastDetailsResponse> getMyBroadcasts(
      Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.getMyBroadcasts(token, model);
    return BroadcastDetailsResponse.fromJson(response.data);
  }

  @override
  Future<MySharesBroadcastResponse> myShares() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.myShares(token);
    return MySharesBroadcastResponse.fromJson(response.data);
  }

  @override
  Future<SharePostResponse> sharePost(SharePostModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.sharePost(token, model.toJson());
    return SharePostResponse.fromJson(response.data);
  }

  @override
  Future<ShareTypeResponse> shareTypes() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.shareTypes(token);
    return ShareTypeResponse.fromJson(response.data);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<CitiesResponse> getCities(StateData stateId) async {
    final response = await _enrollService.getCities(stateId.id!.toString());
    return CitiesResponse.fromJson(response.data);
  }

  @override
  Future<StateResponse> getStates() async {
    final response = await _enrollService.getStates();
    return StateResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(
      ForgotPasswordModel model) async {
    final response =
        await _forgotPasswordService.forgotPassword(model.toJson());
    final mobileresponse = ForgotPasswordResponse.fromJson(response.data);
    String? mobile = mobileresponse.mobile;
    globals.mobile = mobile!;
    _sharedPrefRepository.storeData('mobile', mobile);
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> resendOtp(ForgotPasswordModel model) async {
    final response = await _forgotPasswordService.resendOtp(model.toJson());

    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> verifyOtp(ForgotPasswordModel model) async {
    final response = await _forgotPasswordService.verifyOtp(model.toJson());
    final responseData = ForgotPasswordResponse.fromJson(response.data);
    if (responseData.accessToken != null) {
      String token = responseData.accessToken!;
      globals.token = token;
      _sharedPrefRepository.storeData('token', responseData.accessToken!);
    }

    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> resetPassword(
      ForgotPasswordModel model) async {
    final response = await _forgotPasswordService.resetPassword(model.toJson());
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<UserDetailsResponse> uploadProfileImage(
      ProfileRequestModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _loginService.uploadProfileImage(token, model.toJson());
    return UserDetailsResponse.fromMap(response);
  }

  @override
  Future<CheckoutResponse> checkOut(Map<String, dynamic> model) async {
    final responseData = await _enrollService.checkOut(model);
    final response = CheckoutResponse.fromJson(responseData.data);
    String token = response.token!.accessToken!;
    _sharedPrefRepository.storeData('token', response.token!.accessToken!);
    globals.token = token;
    _sharedPrefRepository.storeData('token', token);
    return CheckoutResponse.fromJson(responseData.data);
  }

  @override
  Future<CheckoutResponse> broadcastCheckOut(Map<String, dynamic> model) async {
    final responseData = await _enrollService.checkOut(model);

    return CheckoutResponse.fromJson(responseData.data);
  }

  @override
  Future<GeneratedAcceleratedResponse> generateAcceratedUrl(
      ProfileRequestModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _broadcastService.generateAcceratedUrl(token, model.toJson());
    return GeneratedAcceleratedResponse.fromMap(response.data);
  }

  @override
  Future<ReferEarnResponse> getUserPoints() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _referEarnService.getUserPoints(token);
    return ReferEarnResponse.fromMap(response.data);
  }

  @override
  Future<ReferalCodeResponse> getReferalCode() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _referEarnService.getReferalCode(token);
    return ReferalCodeResponse.fromMap(response.data);
  }

  @override
  Future<BeehiveResponse> getBeehivePosts(Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _beehiveService.getBeehivePosts(token, model);
    return BeehiveResponse.fromJson(response.data);
  }

  @override
  Future<MyPostBeehiveResponse> myPostsBeehive(
      Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _beehiveService.myPostsBeehive(token, model);
    return MyPostBeehiveResponse.fromJson(response.data);
  }

  @override
  Future<BeehiveCategoriesResponse> getBeehiveCategories() async {
    final response = await _beehiveService.getBeehiveCategories();
    return BeehiveCategoriesResponse.fromJson(response.data);
  }

  @override
  Future<BeehiveUploadResponse> uploadBeehive(BeehiveModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _beehiveService.uploadBeehive(token, model.toJson());
    return BeehiveUploadResponse.fromJson(response);
  }

  @override
  Future<SaveOrLikePostResponse> saveOrLikePost(SaveOrLikeModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response =
        await _beehiveService.saveOrLikePost(token, model.toJson());
    return SaveOrLikePostResponse.fromJson(response.data);
  }

  @override
  Future<SavedBeehiveResponse> mySavedPosts(Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _beehiveService.mySavedPosts(token, model);
    return SavedBeehiveResponse.fromJson(response.data);
  }

  @override
  Future<EnrollResModel> validateReferalCode(Map<String, dynamic> model) async {
    final response = await _enrollService.validateReferalCode(model);
    return EnrollResModel.fromJson(response.data);
  }

  @override
  Future<EnrollResModel> businessEnroll(BusinessEnrollModel model) async {
    final responseData = await _enrollService.businessEnroll(model.toJson());
    final response = EnrollResModel.fromJson(responseData);
    String userName = '${response.data!.username} ';
    String userId = response.data!.id.toString();
    String mobile = response.data!.mobile!;
    String role = response.data!.role!.toString();
    String token = response.accessToken!.accessToken!;
    globals.userName = userName;
    globals.userId = userId;
    globals.mobile = mobile;
    globals.role = role;
    globals.token = token;
    _sharedPrefRepository.storeData('userName', userName);
    _sharedPrefRepository.storeData('userId', userId);
    _sharedPrefRepository.storeData('mobile', mobile);
    _sharedPrefRepository.storeData('role', role);
    _sharedPrefRepository.storeData('token', token);
    return EnrollResModel.fromJson(responseData);
  }

  @override
  Future<BroadcastPlanResponse> getBroadcastPlans() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.getBroadcastPlans(token);
    return BroadcastPlanResponse.fromJson(response.data);
  }

  @override
  Future<ViewBroadcastDetailsResponse> viewBroadcastPost(String id) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.viewBroadcastPost(token, id);
    return ViewBroadcastDetailsResponse.fromJson(response.data);
  }

  @override
  Future<UploadBroadCastResponse> updateDraftBusinessBroadcast(
      BusinessBroadcastModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.updateDraftBusinessBroadcast(
        token, model.toJson());
    return UploadBroadCastResponse.fromJson(response.data);
  }

  @override
  Future<NotificationResponseModel> getUserNotifications() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _notificationService.getUserNotifications(token);
    return NotificationResponseModel.fromJson(response.data);
  }

  @override
  Future<UploadBroadCastResponse> viewNotification(String id) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _notificationService.viewNotification(token, id);

    return UploadBroadCastResponse.fromJson(response.data);
  }

  @override
  Future<UploadBroadCastResponse> markAllAsRead() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _notificationService.markAllAsRead(token);
    return UploadBroadCastResponse.fromJson(response.data);
  }

  @override
  Future<ReadOrDeleteNotifications> readOrDeleteNotifications(
      ReadOrDeleteModel model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _notificationService.readOrDeleteNotifications(
        token, model.toJson());
    return ReadOrDeleteNotifications.fromJson(response.data);
  }

  @override
  Future<UploadBroadCastResponse> deleteFile(Map<String, dynamic> model) async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.deleteFile(token, model);
    return UploadBroadCastResponse.fromJson(response.data);
  }

  @override
  Future<AccountDeleteResponse> deleteAccount() async {
    final token = await _sharedPrefRepository.fetchData('token');
    final response = await _broadcastService.deleteAccount(token);
    return AccountDeleteResponse.fromJson(response.data);
  }
}
