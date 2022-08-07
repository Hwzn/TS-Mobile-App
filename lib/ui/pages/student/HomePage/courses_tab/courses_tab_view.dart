import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/main_button.dart';
import 'courses_card.dart';
import 'courses_tab_view_model.dart';

class CoursesTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    if (!locator<AuthenticationService>().userLoged) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            locale.get('My Courses'),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          height: SizeConfig.heightMultiplier * 100,
          width: SizeConfig.widthMultiplier * 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(locale.get('please login to view your courses')),
              SizedBox(
                height: 30,
              ),
              Container(
                width: SizeConfig.widthMultiplier * 60,
                child: MainButton(
                  text: locale.get('Login'),
                  onTap: () {
                    UI.push(context, StudentLoginPage());
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
    return ChangeNotifierProvider<MyCoursesStudentTabViewModel>(
      create: (context) => MyCoursesStudentTabViewModel(),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              locale.get("My Courses"),
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/images/search.svg",
                  color: Colors.black,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(8.0),
                icon: SvgPicture.asset(
                  "assets/images/Cart.svg",
                  color: Colors.black,
                ),
                onPressed: () {
                  UI.push(context, CartPage());
                },
              ),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: coursesList(),
          )),
    );
  }

  Widget coursesList() {
    return Consumer<MyCoursesStudentTabViewModel>(
        builder: (context, model, __) {
      final locale = AppLocalizations.of(context);
      return model.busy
          ? Container(
              child: Center(
                child: Loading(),
              ),
            )
          : model.courses.isEmpty
              ? Center(
                  child: Text(
                      locale.get('There is no courses, Start Learning Now')),
                )
              : ListView.builder(
                  itemCount: model.courses.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CoursehorizontalCard(
                          key: Key(model.courses[index].sId),
                          course: model.courses[index],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: Colors.grey,
                            height: 1,
                          ),
                        )
                      ],
                    );
                  });
    });
  }
}
