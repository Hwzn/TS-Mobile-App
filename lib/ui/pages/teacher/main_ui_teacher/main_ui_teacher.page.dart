import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/base_widget.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/providers/teacher/main_ui_teacher_vm.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/notifications_tab/notifications_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/profile_tab_view.dart';
import 'package:ts_academy/ui/pages/teacher/main_ui_teacher/start-live.model.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_courses_tab/teacher_courses_view.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/teacher_home.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import '../../../styles/colors.dart';
import '../../../styles/size_config.dart';
import 'package:im_stepper/stepper.dart';

class GoLive extends StatelessWidget {
  const GoLive({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StartLiveModel>(
      create: (context) => StartLiveModel(context),
      child: Consumer<StartLiveModel>(builder: (context, model, __) {
        return Container(
          alignment: Alignment.center,
          width: SizeConfig.widthMultiplier * 80,
          child: SizedBox(
            width: SizeConfig.widthMultiplier * 75,
            child: DropdownButton<Course>(
              hint: Text(locale.get('Select Course')),
              selectedItemBuilder: (BuildContext context) {
                return model.courses.map((Course item) {
                  return SizedBox(
                    width: SizeConfig.widthMultiplier * 68,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name.localized(context)),
                        const Text(
                          "-",
                          style: TextStyle(color: AppColors.red),
                        ),
                        Text(item.grade.name.localized(context)),
                        const Text(
                          "-",
                          style: TextStyle(color: AppColors.red),
                        ),
                        Text(item.subject.name.localized(context)),
                      ],
                    ),
                  );
                }).toList();
              },
              dropdownColor: AppColors.accentText,
              iconSize: 24,
              value: model.selectedCourse,
              autofocus: true,
              elevation: 16,
              style: const TextStyle(color: AppColors.primaryColor),
              underline: Container(
                height: 0.5,
                color: AppColors.primaryColor,
              ),
              onChanged: (Course newValue) {
                if (DateTime.fromMillisecondsSinceEpoch(newValue.startDate)
                        .difference(DateTime.now())
                        .inDays >
                    1) {
                  UI.showSnackBarMessage(
                      context: context,
                      message: locale.get('This Course Starts At') +
                          " ${DateFormat('d-M-y').format(DateTime.fromMillisecondsSinceEpoch(newValue.startDate))} ${locale.get('in Days')} ${newValue.days.map((e) => locale.get(e)).toString()}");
                } else {
                  model.selectedCourse = newValue;
                  model.setState();
                  model.showAlertDialog(context);
                }
              },
              items:
                  model.courses.map<DropdownMenuItem<Course>>((Course value) {
                return DropdownMenuItem<Course>(
                  value: value,
                  child: Text(
                      '${value.name.localized(context)} - ${value.grade.name.localized(context)} - ${value.subject.name.localized(context)}',
                      style: Theme.of(context).textTheme.bodyText1),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

PersistentTabController _controller;

class MainUITeacher extends StatelessWidget {
  const MainUITeacher({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseWidget<MainUITeacherVM>(
        model: MainUITeacherVM(),
        initState: (m) =>
            {_controller = PersistentTabController(initialIndex: 0)},
        builder: (context, model, child) {
          final auth = locator<AuthenticationService>();
          final locale = AppLocalizations.of(context);
          return PersistentTabView(context, onWillPop: (p0) async {
            model.setState();
            return false;
          },
              controller: _controller,
              neumorphicProperties:
                  const NeumorphicProperties(curveType: CurveType.flat),
              screens: _buildScreens(auth),
              items: _navBarsItems(model, context, locale),
              // confineInSafeArea: true,
              navBarHeight: 70,
              // padding: const NavBarPadding.only(bottom: 20),
              // margin: const EdgeInsets.all(10),
              // navBarHeight: 60,
              backgroundColor:
                  AppColors.primaryBackground, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset:
                  true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              bottomScreenMargin: 60,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: NavBarDecoration(
                  borderRadius: const BorderRadius.all(Radius.zero),
                  colorBehindNavBar: AppColors.primaryBackground,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5)
                  ]),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              // navBarHeight: 40,
              itemAnimationProperties: const ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style15);
        });
  }

  List<Widget> _buildScreens(AuthenticationService auth) {
    return [
      TeacherHome(),
      TeacherCoursesPage(),
      SizedBox(),
      NotificationsTabPage(),
      ProfileTabPage(
        isParent: false,
      )
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(
      MainUITeacherVM model, BuildContext context, AppLocalizations locale) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home_outlined,
        ),
        title: locale.get('Home'),
        activeColorPrimary: AppColors.primaryColorDark,
        inactiveColorPrimary: AppColors.greyColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.play_circle_outline_outlined,
        ),
        title: locale.get('Courses'),
        activeColorPrimary: AppColors.primaryColorDark,
        inactiveColorPrimary: AppColors.greyColor,
      ),
      PersistentBottomNavBarItem(
          icon: SvgPicture.asset(
            "assets/images/Live.svg",
          ),
          contentPadding: 10,
          opacity: 1,
          activeColorPrimary: AppColors.primaryColor,
          inactiveColorPrimary: AppColors.greyColor,
          onPressed: (ctx) {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
              builder: (context) => SizedBox(
                  height: SizeConfig.heightMultiplier * 20,
                  child: const GoLive()),
            );
          }),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.notifications_none,
        ),
        title: locale.get('Notifications'),
        activeColorPrimary: AppColors.primaryColorDark,
        inactiveColorPrimary: AppColors.greyColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline_sharp),
        title: locale.get('Profile'),
        activeColorPrimary: AppColors.primaryColorDark,
        inactiveColorPrimary: AppColors.greyColor,
      ),
    ];
  }
}
