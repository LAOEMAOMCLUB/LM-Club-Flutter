// endPointPage here we can set our baseUrl every API url will set here.

class LMCEndpoints {
  // UAT

  // static const baseUrl = 'https://uat.lmclubclub.com/';
  // static const sandboxMode = true;
  // static const clientId =
  //     "Adr7l_cl0kRHBQyZ3yUhSpGjG5JFKwU8_CqSbsfmIKEEnhzt9VdcFgAlWsq2Cqu8_2TxRtczlMtPch7S";
  // static const secretKey =
  //     "ENiyp_O551olwchyJo5ab4rS5urniWCYHPWJrfVUN0Uc9bXy3ypd45icPDkkmLTuUuNqk1wmr00pZwpI";

  // Production
  static const baseUrl = 'https://lmclubclub.com/';
  static const sandboxMode = false;
  static const clientId =
      "Ad2yyKDNeEj1BREmBSoqOABOyPAx0eyAMHdfJfSLck24-4DZovG-YmjZgQTMgoSa5k0Gf-8yygzprEqg";
  static const secretKey =
      "EPGzyvQKJG6b-GUZ061lUUwFSBCubIPV8aP-kLi8QpUk7XmzvLZYEcKv0rF9IVtafVd0Or_uAOq6T8SH";

//Base Endpoint for all user apis
  static const _baseUserAPIEndpoint = '/api/user';
  static const _baseUserAPIEndpointLm = '/api';
  // static const _baseNotificationAPIendpointLm = '/api/notifications';
  static const _baseUserAPIEndpointBeehive = '/api/beehivePost';
  // static const _baseUserAPIEndpointCities = '/api/cities';
  // static const _baseUserAPIEndpointStates = '/api/states';
  static const _baseUserAPIEndpointMasters = 'api/masters';
  //AUTHENTICATION
  static const enroll = '$_baseUserAPIEndpoint/signup';
  static const login = '$_baseUserAPIEndpoint/userlmLogin';

  //broadcast
  static const uploadBroadcast = '$_baseUserAPIEndpointLm/post/uploadPost';
  //static const getBroadcasts = '$_baseUserAPIEndpointLm/post/getPosts';
  static const getBroadcasts = '$_baseUserAPIEndpointLm/getBroadcastPosts';
  static const uploadBusinessBroadcast =
      '$_baseUserAPIEndpointLm/uploadBroadcastPost';

  static const updateDraftBusinessBroadcast =
      '$_baseUserAPIEndpointLm/uploadBroadcastPost';
  // myPosts

//   --Share BToadCast --
  static const myShares = '$_baseUserAPIEndpointLm/myShares';
  static const shareTypes = '$_baseUserAPIEndpointMasters/shareTypes';
  static const sharePost = '$_baseUserAPIEndpointLm/sharePost';

  // myBroadCastPosts
  static const getMyBroadcasts = '$_baseUserAPIEndpointLm/myPosts';
  static const viewBroadcastPost = '$_baseUserAPIEndpointLm/viewPost/';
  static const getBroadcastPlans =
      '$_baseUserAPIEndpointMasters/broadcastPlans';
  static const deleteFile = '$_baseUserAPIEndpointLm/beehivePost/deleteFile';

  //Coupons
  static const getCategories = '$_baseUserAPIEndpointMasters/allCategories';
  static const addCoupon = '$_baseUserAPIEndpointLm/addCoupon';
  static const getCoupons = '$_baseUserAPIEndpointLm/getCoupons';

  //plans
  static const getAllPlans = '$_baseUserAPIEndpointMasters/allSubscriptions';
  static const getplan = '$_baseUserAPIEndpointMasters/subscription/';

  //user widgets
  static const getWidgets = '$_baseUserAPIEndpointMasters/getUserWidgets/';

  // cities
  static const getStates = '$_baseUserAPIEndpointMasters/allStates';
  static const getCities = '$_baseUserAPIEndpointMasters/allCities?state=';

  //otp
  static const verifyOtp = '$_baseUserAPIEndpoint/verifyOtp';
  static const resendOtp = '$_baseUserAPIEndpoint/resendOtp';
  //forgot password
  static const forgotPassword = '$_baseUserAPIEndpoint/forgotPassword';
  static const resetPassword = '$_baseUserAPIEndpoint/resetPassword';

  //profile
  //static const uploadProfileImage = '$_baseUserAPIEndpoint/updatelmUser';
  static const uploadProfileImage =
      '$_baseUserAPIEndpoint/updateProfilePicture';
  static const getUserDetails = '$_baseUserAPIEndpoint/UserProfile/';
  // static const updateUserDetails = '$_baseUserAPIEndpoint/updatelmUser';
  static const updateUserDetails = '$_baseUserAPIEndpoint/updateProfile';
  //static const getUserProfile = '$_baseUserAPIEndpoint/UserProfile/';

  // Checkout
  static const checkOut = '$_baseUserAPIEndpointLm/payments/planPayment';

  // image upload

  static const generateAcceratedUrl =
      '$_baseUserAPIEndpoint/generateAcceleratedUrl';

  // refer & earn

  static const getUserPoints = '$_baseUserAPIEndpointLm/points/userPoints';
  static const getReferalCode = '$_baseUserAPIEndpointLm/points/myReferralCode';
  static const validateReferalCode =
      '$_baseUserAPIEndpoint/validateReferralCode';

  //  Beehive

  static const getBeehivePosts = '$_baseUserAPIEndpointBeehive/getBeehivePosts';
  static const myPostsBeehive = '$_baseUserAPIEndpointBeehive/myPosts';
  static const uploadBeehive = '$_baseUserAPIEndpointBeehive/uploadBeehivePost';
  static const getbeehiveCategories =
      '$_baseUserAPIEndpointMasters/allBeehiveCategories';
  static const saveOrLikePost = '$_baseUserAPIEndpointBeehive/saveOrLikePost';
  static const mySavedPosts = '$_baseUserAPIEndpointBeehive/mySavedPosts';

  // Business user signup

  static const businessEnroll = '$_baseUserAPIEndpoint/signupBusinessUser';

  // notifications
  static const getUserNotifications =
      '$_baseUserAPIEndpointLm/notifications/getAllUserNotifications';
  static const readNotifications =
      '$_baseUserAPIEndpointLm/notifications/readAllNotifications';

  static const viewNotification =
      '$_baseUserAPIEndpointLm/notifications/viewNotification/';
  static const markAllAsRead =
      '$_baseUserAPIEndpointLm/notifications/markAllAsRead';
  static const readOrDeleteNotifications =
      '$_baseUserAPIEndpointLm/notifications/readOrDeleteNotifications';
  static const deleteAccount = '/api/user/deleteUser';
  static const customSettings = '/api/masters/customSettings';
}
