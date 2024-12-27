import 'package:lm_club/app/home/home.dart';
import 'package:lm_club/app/presentation/add_widget/scratch.dart';
import 'package:lm_club/app/presentation/beehive/pages/add_behive.dart';
import 'package:lm_club/app/presentation/beehive/pages/beehive.dart';
import 'package:lm_club/app/presentation/beehive/pages/myPost_beehive.dart';
import 'package:lm_club/app/presentation/beehive/pages/savePost_beehive.dart';
import 'package:lm_club/app/presentation/beehive/pages/successPost_beehive.dart';
import 'package:lm_club/app/presentation/brodcast/bloc/myShares_broadCast.dart';
import 'package:lm_club/app/presentation/brodcast/brodcast.dart';
import 'package:lm_club/app/presentation/brodcast/my_drafts.dart';
import 'package:lm_club/app/presentation/brodcast/my_posts.dart';
import 'package:lm_club/app/presentation/brodcast/post_success.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/broadcast_paypal.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/business_create_post.dart';
import 'package:lm_club/app/presentation/business_module/business-broadcast/pages/business_edit_post.dart';
import 'package:lm_club/app/presentation/business_module/business/pages/business.dart';
import 'package:lm_club/app/presentation/business_module/business/pages/business_otp.dart';
import 'package:lm_club/app/presentation/business_module/business_profile/pages/edit_business_profile.dart';
import 'package:lm_club/app/presentation/choose_plan/bloc/reniwal_plan.dart';
import 'package:lm_club/app/presentation/choose_plan/choose_plan.dart';
import 'package:lm_club/app/presentation/choose_plan/plan_details.dart';
import 'package:lm_club/app/presentation/dashboard/dashboard.dart';
import 'package:lm_club/app/presentation/enroll/enroll.dart';
import 'package:lm_club/app/presentation/enroll/otp.dart';
import 'package:lm_club/app/presentation/forgot-password/pages/forgot_password.dart';
import 'package:lm_club/app/presentation/forgot-password/pages/reset_password.dart';
import 'package:lm_club/app/presentation/get_started/splash.dart';
import 'package:lm_club/app/presentation/notification/pages/notification.dart';
import 'package:lm_club/app/presentation/otp/pages/password_otp.dart';
import 'package:lm_club/app/presentation/paypal/paypal.dart';
import 'package:lm_club/app/presentation/paypal/reniwal_Pay.dart';
import 'package:lm_club/app/presentation/profile/edit_profile.dart';
import 'package:lm_club/app/presentation/profile/profile.dart';
import 'package:lm_club/app/presentation/profile/view_profile.dart';
import 'package:lm_club/app/presentation/refer/pages/refer_earn.dart';
import 'package:lm_club/app/presentation/rewards/rewards.dart';
import 'package:lm_club/app/presentation/signin/sign_in.dart';
import 'package:lm_club/app/presentation/webpages/webview.dart';
import 'package:qlevar_router/qlevar_router.dart';
import '../../app/presentation/business_module/business_profile/pages/business_profile.dart';
import '../../app/presentation/get_started/get_started.dart';
import '../app_routes.dart';

final routes = [
  QRoute(
      path: Routes.SPLASH,
      name: Routes.SPLASH.name,
      builder: () => const Splash(),
      middleware: []),
  QRoute(
      path: Routes.SIGN_IN,
      name: Routes.SIGN_IN.name,
      builder: () => const Login(),
      middleware: []),
  QRoute(
      path: Routes.DASHBOARD,
      name: Routes.DASHBOARD.name,
      builder: () => const Dashboard(),
      middleware: []),
  QRoute(
      path: Routes.REWARDS,
      name: Routes.REWARDS.name,
      builder: () => const Rewards(),
      middleware: []),
  QRoute(
      path: Routes.BEEHIVE,
      name: Routes.BEEHIVE.name,
      builder: () => const Beehive(),
      middleware: []),
  QRoute(
      path: Routes.MY_DRAFTS,
      name: Routes.MY_DRAFTS.name,
      builder: () => const MyDrafts(id: ''),
      middleware: []),
  QRoute(
      path: Routes.BROADCAST,
      name: Routes.BROADCAST.name,
      builder: () => const Brodcast(),
      middleware: []),
  QRoute(
      path: Routes.REFER_EARN,
      name: Routes.REFER_EARN.name,
      builder: () => const ReferEarn(),
      middleware: []),
  QRoute(
      path: Routes.POST_SUCCESS,
      name: Routes.POST_SUCCESS.name,
      builder: () => const PostSuccess(),
      middleware: []),
  QRoute(
      path: Routes.MY_POSTS,
      name: Routes.MY_POSTS.name,
      builder: () => const MyPosts(id: ''),
      middleware: []),
  QRoute(
      path: Routes.MY_SHARES_BROADCAST,
      name: Routes.MY_SHARES_BROADCAST.name,
      builder: () => const MySharesBroadCast(),
      middleware: []),
  QRoute(
      path: Routes.BUSINESS_CREATE_POST,
      name: Routes.BUSINESS_CREATE_POST.name,
      builder: () => const BusinessCreatePost(),
      middleware: []),
  QRoute(
      path: Routes.BEEHIVE_SUCCESS_POST,
      name: Routes.BEEHIVE_SUCCESS_POST.name,
      builder: () => const BeehiveSuccessPost(),
      middleware: []),
  QRoute(
      path: Routes.SAVE_POST,
      name: Routes.SAVE_POST.name,
      builder: () => const SavePost(),
      middleware: []),
  QRoute(
      path: Routes.MY_POSTS_BEEHIVE,
      name: Routes.MY_POSTS_BEEHIVE.name,
      builder: () => const MyPostsBeehive(),
      middleware: []),
  QRoute(
      path: Routes.ADD_BEEHIVE,
      name: Routes.ADD_BEEHIVE.name,
      builder: () => const AddBeehive(),
      middleware: []),
  QRoute(
      path: Routes.SCRATCH,
      name: Routes.SCRATCH.name,
      builder: () => const Scratch(),
      middleware: []),
  QRoute(
      path: Routes.HOME,
      name: Routes.HOME.name,
      builder: () => const Home(),
      middleware: []),
  QRoute(
      path: Routes.BUSINESS_EDIT_POST,
      name: Routes.BUSINESS_EDIT_POST.name,
      builder: () => const BusinessEditPost(),
      middleware: []),
  QRoute(
      path: Routes.BUSINESS,
      name: Routes.BUSINESS.name,
      builder: () => const Business(),
      middleware: []),
  QRoute(
      path: Routes.BUSINESS_OTP,
      name: Routes.BUSINESS_OTP.name,
      builder: () => const BusinessOtp(),
      middleware: []),
  QRoute(
      path: Routes.BUSINESS_PAYPAL,
      name: Routes.BUSINESS_PAYPAL.name,
      builder: () => const BusinessPaypal(),
      middleware: []),
  QRoute(
      path: Routes.EDIT_BUSINESS_PROFILE,
      name: Routes.EDIT_BUSINESS_PROFILE.name,
      builder: () => const EditBusinessProfile(),
      middleware: []),
  QRoute(
      path: Routes.PROFILE,
      name: Routes.PROFILE.name,
      builder: () => const Profile(id: ''),
      middleware: []),
  QRoute(
      path: Routes.FORGOT_PASSWORD,
      name: Routes.FORGOT_PASSWORD.name,
      builder: () => const ForgotPassword(),
      middleware: []),
  QRoute(
      path: Routes.PASSWORD_OTP,
      name: Routes.PASSWORD_OTP.name,
      builder: () => const PasswordOtp(),
      middleware: []),
  QRoute(
      path: Routes.RESET_PASSWORD,
      name: Routes.RESET_PASSWORD.name,
      builder: () => const ResetPassword(),
      middleware: []),
  QRoute(
      path: Routes.CHOOSE_PLAN,
      name: Routes.CHOOSE_PLAN.name,
      builder: () => const ChoosePlan(subscriptionPlan: ''),
      middleware: []),
  QRoute(
      path: Routes.PLAN_DETAILS,
      name: Routes.PLAN_DETAILS.name,
      builder: () => const PlanDetails(),
      middleware: []),
  QRoute(
      path: Routes.ENROLL,
      name: Routes.ENROLL.name,
      builder: () => const Enroll(id: ''),
      middleware: []),
  QRoute(
      path: Routes.PAYPAL,
      name: Routes.PAYPAL.name,
      builder: () => const Paypal(amount: ''),
      middleware: []),
  QRoute(
      path: Routes.OTP,
      name: Routes.OTP.name,
      builder: () => const Otp(subscriptionFee: ''),
      middleware: []),
  QRoute(
      path: Routes.VIEWPROFILE,
      name: Routes.VIEWPROFILE.name,
      builder: () => const ViewProfile(id: ''),
      middleware: []),
  QRoute(
      path: Routes.VIEWBUSINESSPROFILE,
      name: Routes.VIEWBUSINESSPROFILE.name,
      builder: () => const ViewBusinessProfile(id: ''),
      middleware: []),
  QRoute(
      path: Routes.EDITPROFILE,
      name: Routes.EDITPROFILE.name,
      builder: () => const EditProfile(),
      middleware: []),
  QRoute(
      path: Routes.NOTIFICATION,
      name: Routes.NOTIFICATION.name,
      builder: () => const Notifications(),
      middleware: []),
  QRoute(
      path: Routes.GETSTARTED,
      name: Routes.GETSTARTED.name,
      builder: () => const GetStarted(),
      middleware: []),
  QRoute(
      path: Routes.RENIWALPLAN,
      name: Routes.RENIWALPLAN.name,
      builder: () => const ReniwalPlan(id: '', subscriptionPlan: ''),
      middleware: []),
  QRoute(
      path: Routes.RENIWALPAY,
      name: Routes.RENIWALPAY.name,
      builder: () => const ReniwalPay(
          reniwal: '',
          planId: '',
          subscriptionPlan: '',
          registrationAmount: ''),
      middleware: []),
  QRoute(
      path: Routes.PRIVACYENROLLPAGE,
      name: Routes.PRIVACYENROLLPAGE.name,
      builder: () =>  WebView(),
      middleware: [])
];
