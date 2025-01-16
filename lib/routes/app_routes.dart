// routesPage here we can define routeNames

// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const REWARDS = _Paths.REWARDS;
  static const BEEHIVE = _Paths.BEEHIVE;
  static const MY_DRAFTS = _Paths.MY_DRAFTS;
  static const BROADCAST = _Paths.BROADCAST;
  static const REFER_EARN = _Paths.REFER_EARN;
  static const POST_SUCCESS = _Paths.POST_SUCCESS;
  static const MY_POSTS = _Paths.MY_POSTS;
  static const MY_SHARES_BROADCAST = _Paths.MY_SHARES_BROADCAST;
  static const BUSINESS_CREATE_POST = _Paths.BUSINESS_CREATE_POST;
  static const BEEHIVE_SUCCESS_POST = _Paths.BEEHIVE_SUCCESS_POST;
  static const SAVE_POST = _Paths.SAVE_POST;
  static const MY_POSTS_BEEHIVE = _Paths.MY_POSTS_BEEHIVE;
  static const ADD_BEEHIVE = _Paths.ADD_BEEHIVE;
  static const SCRATCH = _Paths.SCRATCH;
  static const HOME = _Paths.HOME;
  static const BUSINESS_EDIT_POST = _Paths.BUSINESS_EDIT_POST;
  static const BUSINESS = _Paths.BUSINESS;
  static const BUSINESS_OTP = _Paths.BUSINESS_OTP;
  static const BUSINESS_PAYPAL = _Paths.BUSINESS_PAYPAL;
  static const EDIT_BUSINESS_PROFILE = _Paths.EDIT_BUSINESS_PROFILE;
  static const PROFILE = _Paths.PROFILE;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const PASSWORD_OTP = _Paths.PASSWORD_OTP;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const CHOOSE_PLAN = _Paths.CHOOSE_PLAN;
  static const PLAN_DETAILS = _Paths.PLAN_DETAILS;
  static const ENROLL = _Paths.ENROLL;
  static const PAYPAL = _Paths.PAYPAL;
  static const OTP = _Paths.OTP;
  static const VIEWPROFILE = _Paths.VIEWPROFILE;
  static const VIEWBUSINESSPROFILE = _Paths.VIEWBUSINESSPROFILE;
  static const EDITPROFILE = _Paths.EDITPROFILE;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const GETSTARTED = _Paths.GETSTARTED;
  static const RENIWALPLAN = _Paths.RENIWALPLAN;
  static const RENIWALPAY = _Paths.RENIWALPAY;
  static const PRIVACYENROLLPAGE = _Paths.PRIVACYENROLLPAGE;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const SIGN_IN = '/sign-in';
  static const DASHBOARD = '/dashboard';
  static const REWARDS = '/rewards';
  static const BEEHIVE = '/beehive';
  static const MY_DRAFTS = '/my-drafts';
  static const BROADCAST = '/broadcast';
  static const REFER_EARN = '/refer-earn';
  static const POST_SUCCESS = '/post-success';
  static const MY_POSTS = '/my-posts';
  static const MY_SHARES_BROADCAST = '/my-shares-broadcast';
  static const BUSINESS_CREATE_POST = '/business-create-post';
  static const BEEHIVE_SUCCESS_POST = '/beehive-success-post';
  static const SAVE_POST = '/save-post';
  static const MY_POSTS_BEEHIVE = '/my-posts-beehive';
  static const ADD_BEEHIVE = '/add-beehive';
  static const SCRATCH = '/scratch';
  static const HOME = '/home';
  static const BUSINESS_EDIT_POST = '/business-edit-post';
  static const BUSINESS = '/business';
  static const BUSINESS_OTP = '/business-otp';
  static const BUSINESS_PAYPAL = '/business-paypal';
  static const EDIT_BUSINESS_PROFILE = '/edit-business-profile';
  static const PROFILE = '/profile';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const PASSWORD_OTP = '/password-otp';
  static const RESET_PASSWORD = '/reset-password';
  static const CHOOSE_PLAN = '/choose-plan';
  static const PLAN_DETAILS = '/Plan-Details';
  static const ENROLL = '/enroll';
  static const PAYPAL = '/paypal';
  static const OTP = '/otp';
  static const VIEWPROFILE = '/view-profile';
  static const VIEWBUSINESSPROFILE = '/view-business-profile';
  static const EDITPROFILE = '/edit-profile';
  static const NOTIFICATION = '/notification';
  static const GETSTARTED = '/get-started';
  static const RENIWALPLAN = '/reniwal-plan';
  static const RENIWALPAY = '/reniwal-pay';
  static const PRIVACYENROLLPAGE = '/privacy-enroll';
}

extension RouteToName on String {
  String get name => replaceFirst('/', '');
}
