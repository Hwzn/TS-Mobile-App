import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/base_widget.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/courses_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/home_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/notifications_tab/notifications_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/profile_tab_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/search_tab/search_tab_view.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

import 'main_home_view_model.dart';

class MainUI extends StatelessWidget {
  bool isParent;
  MainUI({Key key, this.isParent = false}) : super(key: key);
  PersistentTabController _controller;
  @override
  Widget build(BuildContext context) {
    return BaseWidget<MainUIVM>(
        initState: (m) =>
            {_controller = PersistentTabController(initialIndex: 0)},
        model: MainUIVM(),
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
              confineInSafeArea: false,
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
              hideNavigationBarWhenKeyboardShows:
                  true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
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
              navBarStyle: NavBarStyle.style9);
        });
  }
}

List<Widget> _buildScreens(AuthenticationService auth) {
  return [
    HomeTabPage(),
    SearchTabPage(),
    CoursesTabPage(),
    NotificationsTabPage(),
    ProfileTabPage(
      isParent: auth.user?.userType == 'Parent',
    )
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems(
    MainUIVM model, BuildContext context, AppLocalizations locale) {
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
        Icons.search_outlined,
      ),
      title: locale.get('Search'),
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
