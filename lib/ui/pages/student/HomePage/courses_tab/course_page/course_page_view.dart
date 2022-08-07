import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/course_page_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/courses_tab/course_page/review_tab.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/cart_icon.widget.dart';
import 'package:ts_academy/ui/widgets/custom/add-review.widget.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'info_tab.dart';
import 'lessons_tab.dart';
import 'students_tab.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';

class CoursePage extends StatefulWidget {
  final String courseId;
  final bool isMyCourse;

  const CoursePage({Key key, this.courseId, this.isMyCourse = false})
      : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    if (locator<AuthenticationService>().userLoged &&
        locator<AuthenticationService>().user?.userType == "Teacher") {
      _tabController = TabController(length: 3, vsync: this);
    } else {
      _tabController = TabController(length: 2, vsync: this);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CoursePageModel>(
        create: (context) => CoursePageModel(context, locale, _tabController,
            courseId: widget.courseId, isMyCourse: widget.isMyCourse),
        child: Consumer<CoursePageModel>(builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const BackButton(),
              actions: [
                if (locator<AuthenticationService>().userLoged &&
                    locator<AuthenticationService>().user?.userType ==
                        "Student")
                  const CartIcon()
              ],
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            extendBody: true,
            bottomNavigationBar: model.auth.user?.userType == 'Student' &&
                    !model.busy &&
                    !widget.isMyCourse
                ? FutureBuilder<bool>(
                    future: model.api.purchased(context, model.courseId),
                    builder: (context, snapshot) {
                      if (snapshot.data == false) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: NormalButton(
                            raduis: 10,
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            localize: true,
                            text: model.course?.type == 'home'
                                ? 'Add To Cart'
                                : 'Subscribe',
                            onPressed: () {
                              locator<AuthenticationService>().userLoged
                                  ? model.subscribe(model.course)
                                  : pushNewScreen(context,
                                      screen: StudentLoginPage(),
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.slideRight);
                            },
                            height: 50,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    })
                : null,
            extendBodyBehindAppBar: true,
            floatingActionButton: model.course != null &&
                    widget.isMyCourse &&
                    locator<AuthenticationService>().user?.userType !=
                        "Teacher" &&
                    (model.course.reviews.isEmpty ||
                        (locator<AuthenticationService>().userLoged &&
                            model.course.reviews.firstWhere(
                                    (element) =>
                                        element.user?.sId ==
                                        locator<AuthenticationService>()
                                            .user
                                            ?.sId,
                                    orElse: () => null) ==
                                null)) &&
                    model.reviewsTabActive
                ? FloatingActionButton(
                    onPressed: () {
                      UI.dialog(
                        context: context,
                        child: AddReviewWidget(model),
                        // title: locale.get("permission denied"),
                        accept: true,
                        dismissible: true,
                      );
                    },
                    child: const Icon(Icons.rate_review_outlined),
                    backgroundColor: AppColors.primaryColor,
                    splashColor: AppColors.secondaryElement,
                    hoverColor: Colors.grey,
                    tooltip: locale.get('Write a review'),
                  )
                : null,
            body: model.busy
                ? const Center(
                    child: PlaceholderLines(
                    count: 10,
                    animate: true,
                    align: TextAlign.center,
                  ))
                : courseBody(model, locale),
          );
        }));
  }

  Widget courseBody(CoursePageModel model, AppLocalizations locale) => Column(
        children: [
          Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:
                    // "https://s3.ap-southeast-1.amazonaws.com/images.deccanchronicle.com/dc-Cover-lkmqn1nhu0hem3kvtjrkbvr1v2-20180611171604.Medi.jpeg",
                    BaseFileUrl + (model.course.cover.localized(context) ?? ''),
                imageBuilder: (context, imageProvider) => Container(
                  width: SizeConfig.widthMultiplier * 100,
                  height: SizeConfig.heightMultiplier * 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: const ColorFilter.mode(
                          Colors.blueGrey, BlendMode.multiply),
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Positioned(
                bottom: 40,
                left: locale.locale.languageCode == 'en' ? 20 : null,
                right: locale.locale.languageCode == 'ar' ? 20 : null,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    // "The complete course to learn math essential."
                    model.course?.name?.localized(context) ?? '',

                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      shadows: <Shadow>[
                        const Shadow(
                            offset: Offset(10.0, 10.0),
                            blurRadius: 3.0,
                            color: Colors.blueGrey),
                        const Shadow(
                            offset: Offset(10.0, 10.0),
                            blurRadius: 8.0,
                            color: Colors.blueGrey),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: SizeConfig.widthMultiplier * 5,
                right: SizeConfig.widthMultiplier * 5,
                child: SizedBox(
                  width: SizeConfig.widthMultiplier * 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        // width: SizeConfig.widthMultiplier * 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              locale.get('By') +
                                  " " +
                                  model.course.teacher.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.white, fontSize: 10),
                            ),
                            RatingBar.builder(
                              initialRating:
                                  model.course.teacher.cRating?.toDouble() ?? 5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,

                              itemCount: 5,
                              itemSize: 20,
                              glow: true,
                              ignoreGestures: true,
                              // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star_rounded,
                                color: AppColors.rateColorDark,
                              ),
                              unratedColor: Colors.grey[200],
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                      ),
                      if (locator<AuthenticationService>().userLoged &&
                          locator<AuthenticationService>().user.userType ==
                              'Student')
                        Text(
                          model.course.typedPrice,
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: AppColors.accentText,
                                fontWeight: FontWeight.bold,
                                // shadows: [
                                //   const Shadow(
                                //     color: Colors.white,
                                //     blurRadius: 1,
                                //   ),
                                //   const Shadow(
                                //     color: Colors.black,
                                //     blurRadius: 2,
                                //   )
                                // ]
                              ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                indicatorColor: AppColors.primaryColor,
                indicator: MaterialIndicator(
                  color: AppColors.primaryColor,
                  height: 5,
                  topLeftRadius: 8,
                  topRightRadius: 8,
                  // horizontalPadding: 50,
                  tabPosition: TabPosition.bottom,
                ),
                onTap: (value) {
                  if (value == 2)
                    model.reviewsTabActive = true;
                  else
                    model.reviewsTabActive = false;
                  setState(() {});
                  print(value);
                },
                labelColor: AppColors.primaryColor,
                tabs: [
                  Tab(
                    text: locale.get('Info'),
                  ),
                  // Tab(
                  //   text: locale.get('Lessons'),
                  // ),
                  Tab(
                    text: locale.get('Reviews'),
                  ),
                  if (locator<AuthenticationService>().userLoged &&
                      locator<AuthenticationService>().user?.userType ==
                          "Teacher")
                    Tab(
                      text: locale.get('Students'),
                    )
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                CourseInfoTab(),
                // CourseLessonsTab(),
                const CourseReviewsTab(),
                if (locator<AuthenticationService>().userLoged &&
                    locator<AuthenticationService>().user?.userType ==
                        "Teacher")
                  CourseStudentsTab()
              ],
              controller: _tabController,
            ),
          ),
        ],
      );
}
