import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_academy/core/models/basic_data.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/category_Page/filter_page/filter_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

import '../course_widget.dart';
import '../instractor_widget.dart';
import 'category_page_view_model.dart';
import 'course_card_vertical.dart';

class CategoryPage extends StatefulWidget {
  String subjectId;
  Name subjectName;

  CategoryPage({this.subjectId, this.subjectName});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  final dataKey = GlobalKey();
  final ScrollController _controller = ScrollController();

  void _goToElement(int index) {
    setState(() {
      _controller.animateTo(
          0, // 100 is the height of container and index of 6th element is 5
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInSine);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CategoryPageModel>(
        create: (context) =>
            CategoryPageModel(subjectId: widget.subjectId, context: context),
        child: Consumer<CategoryPageModel>(builder: (context, model, __) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primaryColorDark,
                child:
                    const Icon(Icons.arrow_upward_rounded, color: Colors.white),
                onPressed: () => {_goToElement(0)},
              ),
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  widget.subjectName.localized(context),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 20),
                ),
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios, color: Colors.black)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _modalBottomSheetMenu(context, model);
                        // UI.push(context, FilterPage());
                      },
                      child: SvgPicture.asset(
                        "assets/images/Filter.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      locator<AuthenticationService>().userLoged
                          ? pushNewScreen(context,
                              screen: CartPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp)
                          : pushNewScreen(context,
                              screen: StudentLoginPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/images/Cart.svg",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0.0,
              ),
              // extendBodyBehindAppBar: true,
              body: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () {
                  model.filter();
                  model.refreshController.refreshCompleted();
                },
                onLoading: () {
                  model.onload(context);
                },
                controller: model.refreshController,
                child: model.busy
                    ? const Loading()
                    : ListView(
                        controller: _controller,
                        children: [
                          if (model.filterData?.featuresCourses != null &&
                              model.filterData.featuresCourses.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("Feature Courses") ??
                                    "Feature Courses",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black, fontSize: 18),
                              ),
                            ),
                            coursesTopRatedList(model)
                          ],
                          if (model.filterData?.topInstructors != null &&
                              model.filterData.topInstructors.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("Top instructors"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black, fontSize: 18),
                              ),
                            ),
                            topInstructorsList(model)
                          ],
                          if (model.filterData?.allCourses != null &&
                              model.filterData.allCourses.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                locale.get("All Courses") ?? "All Courses",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Colors.black, fontSize: 18),
                              ),
                            ),
                            allCourses(model),
                          ],
                        ],
                      ),
              ));
        }));
  }

  void _modalBottomSheetMenu(context, model) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        isScrollControlled: true,
        // enableDrag: true,

        context: context,
        builder: (context) {
          return new Container(
            // height: SizeConfig.heightMultiplier * 100,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: FilterPage(
              model: model,
              ctx: context,
            ),
          );
        });
  }

  Widget coursesTopRatedList(CategoryPageModel model) {
    return Container(
        height: SizeConfig.heightMultiplier * 45,
        child: model.filterData.featuresCourses.isEmpty
            ? SizedBox()
            : ListView.builder(
                itemCount: model.filterData.featuresCourses.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CourseCardHorizontal(
                    topRated: true,
                    course: model.filterData.featuresCourses[index],
                  );
                }));
  }

  Widget topInstructorsList(CategoryPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.filterData.topInstructors
              .map<Widget>(
                  (instructor) => InstractorCard(instructor: instructor))
              .toList()),
    );
  }

  Widget allCourses(CategoryPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.filterData.allCourses
              .map<Widget>((course) => CourseCardVertical(course: course))
              .toList()),
    );
  }
}
