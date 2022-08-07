import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:ts_academy/core/providers/teacher/main_ui_teacher_vm.dart';
import 'package:ts_academy/core/services/notification/notification_service.dart';
import 'package:ts_academy/core/services/pricing.service.dart';

import '../services/api/http_api.dart';
import '../services/auth/authentication_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HttpApi());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => NotificationService());
  locator.registerLazySingleton(() => MainUITeacherVM());
  locator.registerLazySingleton(() => PricingService());
}

List<SingleChildWidget> providers = [
  ...independentServices,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<AuthenticationService>(
      create: (context) => locator<AuthenticationService>()),
  ChangeNotifierProvider<NotificationService>(
      create: (context) => locator<NotificationService>()),
  ChangeNotifierProvider<MainUITeacherVM>(
      create: (context) => locator<MainUITeacherVM>()),
];
