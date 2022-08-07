import 'package:ts_academy/core/services/preference/preference.dart';

class RequestType {
  static const String Get = 'get';
  static const String Post = 'post';
  static const String Put = 'put';
  static const String Delete = 'delete';
}

class Header {
  // static Map<String, dynamic> clientAuth({@required String clientID}) {
  //   final hashedClient = const Base64Encoder().convert("$clientID:".codeUnits);
  //   return {'Authorization': 'Basic $hashedClient'};
  // }
  static Map<String, dynamic> get clientAuth =>
      {'Authorization': 'Bearer GPArE2mR+4yu37oxT/HMBvifTgDViU7164H93TtInNY'};

  static Map<String, dynamic> get userAuth =>
      {'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}'};
}

const String BaseUrl = 'http://169.51.198.68:3093/v1/';
const String BaseFileUrl = BaseUrl + 'File/';

class EndPoint {
  static const String pricing = 'Pricing';
  static const String getAllStage = 'Stage';
  static const String getGradesByStage = 'Grade/stage';
  static const String getAllGrade = 'Grade';
  static const String getAllCity = 'City';
  static const String studentBanners = 'Banner';
  static const String login = 'Auth/login';
  static const String studentRegister = 'Auth/register/student';
  static const String teacherRegister = 'Auth/register/teacher';
  static const String parentRegister = 'Auth/register/parent';
  static const String requestToken = 'Auth/requestToken/';
  static const String userActivate = 'Auth/activate';
  static const String resendCode = 'Auth/resendCode';
  static const String RESET_PASSWORD = 'Auth/resetPassword';
  static const String NEW_PASSWORD = 'Auth/newPassword';
  static const String UPLOAD_FILE = 'File/upload';
  static const String REFRESH_TOKEN = 'Auth/refreshToken';
  static const String CREATE_COURSE_COUNTENT = 'Course/content';
  static const String ON_BOARDING = 'OnBoarding';
  static const String STUDENT = 'Student';
  static const String TEACHER = 'Teacher';
  static const String USER_PROFILE = 'User/profile';
  static const String CART = 'Cart';
  static const String SEARCH = 'Search';
  static const String STUDENT_HOME = 'Home/student';
  static const String COURSE_BY_DATE = 'Course/byDate';
  static const String START_LIVE = 'Course/startLive';
  static const String END_LIVE = 'Course/endLive';
  static const String LEAVE = 'Course/leave';
  static const String JOIN_LIVE = 'Course/join';
  static const String Checkout = 'Checkout';
  static const String purchased = 'Checkout/purchased/';
  static const String User_Review = 'User/review';
  static const String Subject = 'Subject';
  static const String ReviewStudent = 'User/reviewStudent';
  static const String GET_PROMOTION_BY_CODE = 'Promotion/byCode/';

  //Teacher
  static const String GET_TEACHER_HOME_PAGE = 'Home/teacher';
  static const String GET_TEACHER_COURSES = 'Course/teacher';
  static const String GET_TEACHER_PROFILE = 'User/teacher';
  static const String CREATE_COURSE = 'Course/new';
  static const String COURSE = 'Course';
  static const String ADD_COURSE_REVIEW = 'Course/review/';
  static const String UPDATE_COURSE = 'Course';
  static const String GET_ALL_SUBJECT = 'Subject';
  static const String ADD_BANK_ACCOUNTS = 'User/account';
  static const String GET_BANK_ACCOUNTS = 'User/account';
  static const String DELETE_BANK_ACCOUNTS = 'User/account';
  static const String STUDENT_COURSES = 'Course/student';
  static const String APPLY_EXCERCICE = 'Course/excercice/';

  static const String TOKEN = 'auth/token';
  static const String USER = 'User';
  static const String MY_PROFILE = 'User/profile';
  static const String WITHDRAW_CASH = 'User/Withdraw/';
  static const String POST = 'posts';
  static const String COMMENT = 'comment';
  static const String REPLY = 'reply';
  static const String CONTACTUS = 'ContactUs';

  static const String MY_NOTIFICATIONS = 'Notice/my';
  static const String SendNotification = 'Notice/send';
  static const String settings = 'Setting';
}

abstract class Api {}
