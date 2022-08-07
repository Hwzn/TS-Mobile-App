import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_option/either_option.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/notice.model.dart';
import 'package:ts_academy/core/models/server_error.dart';
import 'package:ts_academy/core/models/settings.model.dart';
import 'package:ts_academy/core/models/user_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'api.dart';

class HttpApi implements Api {
  String imagePath = BaseUrl + "File/";
  Future<Either<ServerError, dynamic>> request(String endPoint,
      {body,
      bool refresh = false,
      BuildContext context,
      String serverPath = BaseUrl,
      Function onSendProgress,
      Map<String, dynamic> headers,
      String type = RequestType.Get,
      Map<String, dynamic> queryParameters,
      String contentType = Headers.jsonContentType,
      bool retry = false,
      ResponseType responseType = ResponseType.json}) async {
    Response response;

    final dio = Dio(BaseOptions(
        baseUrl: serverPath, connectTimeout: 60000, receiveTimeout: 60000));

    final options = Options(
        headers: headers, contentType: contentType, responseType: responseType);

    if (onSendProgress == null) {
      onSendProgress = (int sent, int total) {
        print('$endPoint\n sent: $sent total: $total\n');
      };
    }

    if (!refresh) {
      bool logged = locator<AuthenticationService>().userLoged;

      if (logged) {
        String token = locator<AuthenticationService>().user?.token;
        if (token != null) {
          String userToken = token?.split('.')[1];
          switch (userToken.length % 4) {
            case 1:
              break; // this case can't be handled well, because 3 padding chars is illeagal.
            case 2:
              userToken = userToken + "==";
              break;
            case 3:
              userToken = userToken + "=";
              break;
          }
          var decodedToken = base64.decode(userToken);

          var tokenJson = json.decode(utf8.decode(decodedToken));
          DateTime time =
              DateTime.fromMillisecondsSinceEpoch(tokenJson['exp'] * 1000);
          if (time.isBefore(DateTime.now())) {
            await refreshToken(context);
          }
        }
      }
    }
    try {
      switch (type) {
        case RequestType.Get:
          {
            response = await dio.get(serverPath + endPoint,
                queryParameters: queryParameters, options: options);
          }
          break;
        case RequestType.Post:
          {
            response = await dio.post(serverPath + endPoint,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                data: body,
                options: options);
          }
          break;
        case RequestType.Put:
          {
            response = await dio.put(endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        case RequestType.Delete:
          {
            response = await dio.delete(endPoint,
                queryParameters: queryParameters, data: body, options: options);
          }
          break;
        default:
          break;
      }

      print('$type $endPoint\n$headers\nstatusCode:${response.statusCode}\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data); //map of string dynamic...
      } else {
        return Left(ServerError(response.data['message']));
      }
    } on DioError catch (e) {
      // if (e.response != null) {
      //   // if (e.response.statusCode == 401 && !retry && context != null) {
      //   //   // sending Refresh token
      //   //   // // // Logger().w('Try to send refresh token');
      //   //   await refreshToken(context);
      //   //   return await request(endPoint,
      //   //       context: context,
      //   //       body: body,
      //   //       queryParameters: queryParameters,
      //   //       headers: Header.userAuth,
      //   //       type: type,
      //   //       contentType: contentType,
      //   //       responseType: responseType,
      //   //       retry: true);
      //   // }
      // } else {
      //   return Left(ServerError(e.message));
      // }
      // return Left(ServerError(e.response.statusMessage));
      return Left(ServerError(e?.response?.data["message"]));
    }
  }

  checkSessionExpired({Response response, BuildContext context}) async {
    if (context != null &&
        (response.statusCode == 401 || response.statusCode == 500)) {
      final expiredMsg = response.data['message'];
      final authExpired = expiredMsg != null && expiredMsg == 'Unauthorized';

      if (authExpired) {
        // await AuthenticationService.handleAuthExpired(context: context);
      }
      return true;
    }
  }

  Future<void> refreshToken(BuildContext context) async {
    String email = locator<AuthenticationService>().user.email;

    String oldToken = locator<AuthenticationService>().user.token;

    final body = {"oldtoken": oldToken, "email": email};
    print(body);
    var tokenResponse;
    tokenResponse = await request(EndPoint.REFRESH_TOKEN,
        context: context,
        type: RequestType.Put,
        body: body,
        headers: Header.clientAuth,
        refresh: true);

    // print(tokenResponse);

    User user;

    tokenResponse.fold((error) => print(error), (data) {
      user = User.fromJson(data);
      locator<AuthenticationService>().saveUser(user);
    });

    // return true;
  }
  // Future<Either<ServerError, dynamic>> getUserPosts() async {
  //   final res = await request(EndPoint.TODO, serverPath: "http://server.overrideeg.net:3002/v1/");
  //   return res;
  // }

  Future<Either<ServerError, dynamic>> getUserPosts() async {
    final res = await request(EndPoint.POST, type: RequestType.Get);
    return res;
  }

  //401
  Future<Either<ServerError, dynamic>> getError401() async {
    final res = await request("xsddddd",
        serverPath: "https://wendux.github.io/", type: RequestType.Get);
    return res;
  }

  Future<Either<ServerError, dynamic>> getGradesByStage(BuildContext context,
      {String stageId}) async {
    final res = await request(EndPoint.getGradesByStage + "/$stageId",
        context: context, headers: Header.clientAuth, type: RequestType.Get);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllGrades(BuildContext context,
      {String stageId}) async {
    final res = await request(EndPoint.getAllGrade,
        context: context, headers: Header.clientAuth, type: RequestType.Get);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllCities(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.getAllCity,
        context: context, headers: Header.clientAuth, type: RequestType.Get);

    return res;
  }

  Future<Either<ServerError, dynamic>> getAllStages(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.getAllStage,
        context: context, headers: Header.clientAuth, type: RequestType.Get);

    return res;
  }

  Future<Either<ServerError, dynamic>> getBanners(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.studentBanners,
        context: context, headers: Header.userAuth, type: RequestType.Get);

    return res;
  }

  Future<Either<ServerError, dynamic>> signin(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.login,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> studentSignUp(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.studentRegister,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> teacherSignUp(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.teacherRegister,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> parentSignUp(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(EndPoint.parentRegister,
        body: body,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> checkout(
    BuildContext context, {
    Map<String, dynamic> body,
  }) async {
    final res = await request(EndPoint.Checkout,
        body: body,
        context: context,
        headers: Header.userAuth,
        // responseType: ResponseType.plain,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getStudentReview(
    BuildContext context, {
    @required String studentId,
    @required String subjectId,
  }) async {
    final res = await request(
      EndPoint.User_Review + "/$studentId" + "/$subjectId",
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getSubject(BuildContext context) async {
    final res = await request(
      EndPoint.Subject,
      context: context,
      headers: Header.clientAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> addReviewStudent(
    BuildContext context, {
    Map<String, dynamic> body,
    String studentId,
    String courseId,
  }) async {
    final res = await request(
      EndPoint.ReviewStudent + "/$studentId/$courseId",
      context: context,
      body: body,
      headers: Header.userAuth,
      type: RequestType.Post,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> resetPassword(BuildContext context,
      {String username}) async {
    final res = await request(EndPoint.RESET_PASSWORD + "/$username",
        context: context, headers: Header.clientAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> changePassword(BuildContext context,
      {String newPassword}) async {
    final res = await request(EndPoint.NEW_PASSWORD,
        body: {"newPassword": newPassword},
        context: context,
        headers: Header.userAuth,
        type: RequestType.Put);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> userActivate(BuildContext context,
      {String code}) async {
    final res = await request(EndPoint.userActivate + "/$code",
        body: "{}",
        context: context,
        headers: Header.userAuth,
        type: RequestType.Put);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> resendCode(BuildContext context,
      {String code}) async {
    final res = await request(EndPoint.resendCode,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getStudentHome(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.STUDENT_HOME,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  //Teacher
  Future<Either<ServerError, dynamic>> getTeacherCourses(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.GET_TEACHER_COURSES,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> createTeacherCourse(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    final res = await request(EndPoint.CREATE_COURSE,
        body: body,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> updateTeacherCourse(BuildContext context,
      {@required Map<String, dynamic> body, String id}) async {
    final res = await request(EndPoint.UPDATE_COURSE + "/$id",
        body: body,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Put);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> updateUserProfile(
    BuildContext context, {
    @required Map<String, dynamic> body,
  }) async {
    final res = await request(EndPoint.USER_PROFILE,
        body: body,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Put);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getCourseById(BuildContext context,
      {@required String courseId}) async {
    final res = await request(
      EndPoint.COURSE + "/$courseId",
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getTeacherHomePage(
    BuildContext context,
  ) async {
    final res = await request(
      EndPoint.GET_TEACHER_HOME_PAGE,
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> addBankAccounts(BuildContext context,
      {Map<String, dynamic> body}) async {
    final res = await request(
      EndPoint.ADD_BANK_ACCOUNTS,
      context: context,
      body: body,
      headers: Header.userAuth,
      type: RequestType.Post,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getTeacherBankAccounts(
    BuildContext context,
  ) async {
    final res = await request(
      EndPoint.GET_BANK_ACCOUNTS,
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getWallet(
    BuildContext context,
  ) async {
    final res = await request(
      EndPoint.GET_BANK_ACCOUNTS,
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> deleteTeacherBankAccount(
      BuildContext context,
      {String bankAccountId}) async {
    final res = await request(
      EndPoint.DELETE_BANK_ACCOUNTS + "/$bankAccountId",
      context: context,
      body: {},
      headers: Header.userAuth,
      type: RequestType.Delete,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getTeacherById(BuildContext context,
      {@required String teacherId}) async {
    final res = await request(
      EndPoint.GET_TEACHER_PROFILE + "/$teacherId",
      context: context,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getCaurseByDate(BuildContext context,
      {@required int timeStamp}) async {
    final res = await request(
      EndPoint.COURSE_BY_DATE,
      context: context,
      headers: Header.userAuth,
      queryParameters: {
        "timeStamp": "$timeStamp",
      },
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getSearch(
      BuildContext context, Map<String, dynamic> query) async {
    final res = await request(
      EndPoint.SEARCH,
      context: context,
      queryParameters: query,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getFilter({
    BuildContext context,
    Map<String, dynamic> query,
  }) async {
    final res = await request(
      EndPoint.SEARCH + "/filter",
      context: context,
      queryParameters: query,
      headers: Header.userAuth,
      type: RequestType.Get,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> startLive(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    // // // Logger().wtf(body);
    final res = await request(
      EndPoint.START_LIVE,
      type: RequestType.Post,
      context: context,
      body: body,
      headers: Header.userAuth,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> endLive(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    // // // Logger().wtf(body);
    final res = await request(
      EndPoint.END_LIVE,
      type: RequestType.Post,
      context: context,
      body: body,
      headers: Header.userAuth,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> leave(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    // // // Logger().wtf(body);
    final res = await request(
      EndPoint.LEAVE,
      type: RequestType.Post,
      context: context,
      body: body,
      headers: Header.userAuth,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> joinLive(BuildContext context,
      {@required Map<String, dynamic> body}) async {
    // // // Logger().wtf(body);
    final res = await request(
      EndPoint.JOIN_LIVE,
      type: RequestType.Post,
      context: context,
      body: body,
      headers: Header.userAuth,
    );
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> deleteTeacherCourse(BuildContext context,
      {String id}) async {
    final res = await request(EndPoint.UPDATE_COURSE + "/$id",
        contentType: Headers.jsonContentType,
        body: "{}",
        context: context,
        headers: Header.userAuth,
        type: RequestType.Delete);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getAllStudents(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.STUDENT,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Lessons> getLiveToken(String courseID, String lessonID) async {
    final res = await request('Course/live/$courseID/$lessonID',
        headers: Header.userAuth, type: RequestType.Get);

    Lessons lesson;
    res.fold((e) {
      // // // Logger().e(e);
    }, (d) async {
      // // // Logger().d(d);
      lesson = Lessons.fromJson(d);
    });
    return lesson;
  }

  Future<Either<ServerError, dynamic>> getAllTeachers(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.TEACHER,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> createTeacherCourseContent(
      BuildContext context,
      {@required List body,
      String courseId}) async {
    // // // Logger().wtf(body);
    final res = await request(EndPoint.CREATE_COURSE_COUNTENT + "/$courseId",
        body: body, context: context, onSendProgress: (_, __) {
      print('try to send request');
    }, headers: Header.userAuth, type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getAllSubjects(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.GET_ALL_SUBJECT,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getStudentMyCourses() async {
    final res = await request(EndPoint.STUDENT_COURSES,
        headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getMyNotifications(
      BuildContext context) async {
    final res = await request(EndPoint.MY_NOTIFICATIONS,
        headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> sendNotification(
      BuildContext context, Notice body) async {
    final res = await request(EndPoint.SendNotification,
        headers: Header.userAuth, type: RequestType.Post, body: body.toJson());
    return res;
  }

  Future<Either<ServerError, dynamic>> applyAssignment(
      BuildContext context, String courseId, String lessonId, List body) async {
    final res = await request(EndPoint.APPLY_EXCERCICE + "$courseId/$lessonId",
        headers: Header.userAuth, type: RequestType.Post, body: body);
    return res;
  }

  Future<Either<ServerError, dynamic>> getOnBoarding(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.ON_BOARDING,
        context: context, headers: Header.clientAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> getStudentCart(
    BuildContext context,
  ) async {
    final res = await request(EndPoint.CART,
        context: context, headers: Header.userAuth, type: RequestType.Get);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> deleteFromCart(BuildContext context,
      {String courseId}) async {
    final res = await request(EndPoint.CART,
        queryParameters: {"courseId": courseId},
        context: context,
        body: {},
        headers: Header.userAuth,
        type: RequestType.Delete);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> addToCart(
    BuildContext context, {
    String courseId,
  }) async {
    final res = await request(EndPoint.CART,
        queryParameters: {"courseId": courseId},
        context: context,
        body: {},
        headers: Header.userAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> writeReview(BuildContext context,
      {String courseId, body}) async {
    final res = await request(EndPoint.ADD_COURSE_REVIEW + courseId,
        context: context,
        body: body,
        headers: Header.userAuth,
        type: RequestType.Post);
    // // // Logger().wtf(res);
    return res;
  }

  Future<Either<ServerError, dynamic>> uploadFile(BuildContext context,
      {dynamic file, Function(int, int) onSendProgress}) async {
    MultipartFile multipartFile = await MultipartFile.fromFile(file.path);
    var body = FormData.fromMap({"file": multipartFile});

    final res = await request(EndPoint.UPLOAD_FILE,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post,
        body: body);

    // // // Logger().i('>> File Upload Starting');

    return res;
  }

  Future<Either<ServerError, dynamic>> uploadImage(BuildContext context,
      {File image}) async {
    var body = FormData.fromMap({"file": image});
    final res = await request(EndPoint.UPLOAD_FILE,
        context: context,
        headers: Header.clientAuth,
        type: RequestType.Post,
        body: body);

    // // // Logger().i('>> File Upload Starting');
    // // // Logger().i(res);

    return res;
  }

  Future<Either<ServerError, dynamic>> myProfile(BuildContext context) async {
    final res = await request(EndPoint.MY_PROFILE,
        context: context,
        headers: Header.userAuth,
        type: RequestType.Get,
        body: {});

    // // // Logger().i('>> File Upload Starting');
    // // // Logger().i(res);

    return res;
  }

  Future<Either<ServerError, dynamic>> applyToWithdrawCash(
      BuildContext context, accountId, amount) async {
    final res = await request(EndPoint.WITHDRAW_CASH + "$accountId/$amount",
        context: context,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: {});

    // // // Logger().i('>> File Upload Starting');
    // // // Logger().i(res);

    return res;
  }

  getSettings(BuildContext context) async {
    final res = await request(EndPoint.settings,
        context: context, type: RequestType.Get, headers: Header.clientAuth);
    return res.fold(
        (err) => UI.toast(err.message), (data) => Settings.fromJson(data));
  }

  Future<bool> purchased(BuildContext context, String courseId) async {
    final res = await request(EndPoint.purchased + courseId,
        context: context, type: RequestType.Get, headers: Header.userAuth);
    return res.fold((err) {
      Logger().wtf(err);
      return false;
    }, (data) {
      Logger().wtf(data);
      return data;
    });
  }
}

//   Future<User> registerUser({@required User user}) async {
//     final response = await request(EndPoint.REGISTER, type: RequestType.Post, body: user.toJson());
//     return response != null ? User.fromJson(response) : null;
//   }

//   Future<String> refreshToken({@required String username, String password}) async {
//     print(username + " " + password);
//     try {
//       final body = {'username': username, 'password': password, 'grant_type': 'password'};
//       final response = await request(EndPoint.TOKEN, type: RequestType.Post, headers: Header.clientAuth, contentType: Headers.formUrlEncodedContentType, body: body);
//       return response != null ? response['access_token'] : null;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }

//   Future<String> uploadImage({@required File image}) async {
//     final formData = FormData.fromMap({'file': await MultipartFile.fromFile(image.path, filename: 'image.png')});
//     final response = await request('upload', type: RequestType.Post, contentType: Headers.contentTypeHeader, body: formData);
//     return response['fileURL'] ?? null;
//   }

//   Future<User> getUser({@required int id}) async {
//     final response = await request(EndPoint.USER + '/$id');

//     return response != null ? User.fromJson(response) : null;
//   }
