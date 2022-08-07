import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/shared/on_boardingPage/on-boarding.page.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/routes/ui.dart';

import '../../../../core/services/localization/localization.dart';

class ChangeLanguagePage extends StatelessWidget {
  bool isEng = true;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: SizeConfig.widthMultiplier * 60,
                height: SizeConfig.heightMultiplier * 40,
                child: Image.asset("assets/images/language.png")),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            languageButtons(context, locale)
          ],
        ),
      ),
    ));
  }

  Widget languageButtons(
    BuildContext context,
    AppLocalizations locale,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AppLanguageModel>(context, listen: false)
                  .changeLanguage(Locale("ar"));
              pushNewScreen(context,
                  screen: OnBoardingPage(),
                  pageTransitionAnimation: PageTransitionAnimation.slideRight,
                  withNavBar: false);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "العربية",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/images/saudi-arabia.svg",
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Provider.of<AppLanguageModel>(context, listen: false)
                  .changeLanguage(const Locale("en"));

              pushNewScreen(context,
                  screen: OnBoardingPage(),
                  pageTransitionAnimation: PageTransitionAnimation.slideRight,
                  withNavBar: false);
            },
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ], shape: BoxShape.circle, color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        locale.get("English"),
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            SvgPicture.asset("assets/images/united-states.svg"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
