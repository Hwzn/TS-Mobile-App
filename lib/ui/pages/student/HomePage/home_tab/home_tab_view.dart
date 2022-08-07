import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/search_tab/search_tab_view.dart';
import 'package:ts_academy/ui/routes/route.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'category_Page/category_page_view.dart';
import 'course_widget.dart';
import 'home_tab_view_model.dart';
import 'instractor_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return ChangeNotifierProvider<HomeTabPageModel>(
        create: (context) => HomeTabPageModel(context: context),
        child: Consumer<HomeTabPageModel>(builder: (context, model, __) {
          return Scaffold(
              body: SingleChildScrollView(
            child: model.busy
                ? SizedBox(
                    height: SizeConfig.heightMultiplier * 100,
                    width: SizeConfig.widthMultiplier * 100,
                    child: Center(child: Loading()))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _headerWidget(context, locale, model),
                      if (model.homeModel.featuresCourses.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            locale.get("Featured") ?? "Featured",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        featuresCoursesList(true, model),
                      ],
                      if (model.homeModel.startSoon.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            locale.get("Start Soon") ?? "Start Soon",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        startSoonCoursesList(false, model)
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              locale.get("Subjects") ?? "Subjects",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black, fontSize: 20),
                            ),
                            InkWell(
                              onTap: () {
                                UI.push(context, SearchTabPage());
                              },
                              child: Text(
                                locale.get("See All") ?? "See All",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Colors.blueGrey,
                                      fontSize: 15,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      categoriesList(context, model),
                      if (model.homeModel.topInstructors != null &&
                          model.homeModel.topInstructors.isNotEmpty) ...[
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              locale.get("Top instructors") ??
                                  "Top instructors",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.black, fontSize: 20),
                            )),
                        instractorList(model),
                      ],
                      if (model.homeModel.partners.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            locale.get("Our partners") ?? "Our partners",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        partnersList(model)
                      ],
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.get("Added recently") ?? "Added recently",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      addedRecentkyList(model),
                    ],
                  ),
          ));
        }));
  }

  Widget featuresCoursesList(bool topRated, HomeTabPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.homeModel.featuresCourses
              .map<Widget>((course) => CourseCardHorizontal(
                    course: Course.fromMinifiedCourse(course),
                    topRated: topRated,
                  ))
              .toList()),
    );
  }

  Widget startSoonCoursesList(bool topRated, HomeTabPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.homeModel.startSoon
              .map<Widget>((course) => CourseCardHorizontal(
                    course: Course.fromMinifiedCourse(course),
                    topRated: topRated,
                  ))
              .toList()),
    );
  }

  Widget addedRecentkyList(HomeTabPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.homeModel.startSoon
              .map<Widget>((course) => CourseCardHorizontal(
                    course: Course.fromMinifiedCourse(course),
                  ))
              .toList()),
    );
  }

  Widget instractorList(HomeTabPageModel model) {
    return SizedBox(
        height: SizeConfig.heightMultiplier * 30,
        child: ListView.builder(
            itemCount: model.homeModel.topInstructors.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InstractorCard(
                instructor: model.homeModel.topInstructors[index],
              );
            }));
  }

  Widget categoriesList(context, HomeTabPageModel model) {
    // var _aspectRatio = _width / cellHeight;
    return SizedBox(
        height: 120,
        child: GridView.builder(
            itemCount: model.homeModel.subjects.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
                childAspectRatio: 1 / 3),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    UI.push(
                        context,
                        CategoryPage(
                          subjectId: model.homeModel.subjects[index].sId,
                          subjectName: model.homeModel.subjects[index].name,
                        ));
                  },
                  child: Chip(
                    labelPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    elevation: 1,
                    avatar: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                          "${model.api.imagePath}${model.homeModel.subjects[index].image}"),
                    ),
                    label: Text(
                      model.homeModel.subjects[index].name.localized(context) ??
                          "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primaryColor,
                  ));
            }));
  }

  Widget _headerWidget(context, locale, HomeTabPageModel model) {
    return model.busy
        ? Loading()
        : CarouselSlider(
            items: model.homeModel.banners
                .map((banner) => Stack(
                      children: [
                        Stack(
                          children: [
                            CachedImage(
                              imageUrl: '$BaseFileUrl${banner.image}',
                              boxFit: BoxFit.cover,
                            ),
                            Container(
                              height: SizeConfig.heightMultiplier * 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        AppColors.primaryColor.withOpacity(0),
                                        AppColors.primaryColor.withOpacity(0.7),
                                      ],
                                      stops: const [
                                        0.6,
                                        1,
                                      ])),
                            )
                          ],
                        ),
                        Positioned(
                            left:
                                locale.locale.languageCode == 'en' ? 20 : null,
                            right:
                                locale.locale.languageCode == 'ar' ? 20 : null,
                            bottom: 20,
                            child: SizedBox(
                              width: SizeConfig.widthMultiplier * 60,
                              child: Text(banner.title.localized(context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.white)),
                            ))
                      ],
                    ))
                .toList(),
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              height: SizeConfig.heightMultiplier * 30,
              autoPlay: true,
              viewportFraction: 1,
              scrollDirection: Axis.horizontal,
            ),
          );
  }

  Widget partnersList(HomeTabPageModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: model.homeModel.partners
              .map<Widget>((partner) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CachedImage(
                          width: 120,
                          height: 100,
                          boxFit: BoxFit.fitWidth,
                          imageUrl: "$BaseFileUrl${partner.logo}",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(partner.name ?? '',
                            style: Theme.of(model.context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}
