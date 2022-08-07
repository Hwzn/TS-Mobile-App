import 'package:logger/logger.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/base_notifier.dart';

class MyCoursesStudentTabViewModel extends BaseNotifier {
  MyCoursesStudentTabViewModel() {
    getMyCourses();
  }
  List<Course> _courses = [];
  List<Course> get courses => [..._courses];

  getMyCourses() async {
    setBusy();
    try {
      final response = await api.getStudentMyCourses();
      response.fold((error) {
        // Logger().e(error.message);
      }, (data) {
        // Logger().d(data);
        _courses
            .addAll(List.from(data).map((e) => Course.fromJson(e)).toList());
      });
    } catch (e) {
      // Logger().e(e.message);
    }
    setIdle();
  }
}
