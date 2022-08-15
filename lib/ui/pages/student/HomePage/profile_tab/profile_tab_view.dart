import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/shared/about_us.page.dart';
import 'package:ts_academy/ui/pages/shared/contact_us.page.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/account_info/account_info_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/bank_accounts/bank_account_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/profile_tab_view_model.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/statistics/statistics_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/wallet/wallet_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/schedule/schedule_view.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'chat/chat_service.dart';
import 'chat/messages_page.dart';
import 'package:flat_icons_flutter/flat_icons_flutter.dart';

class ProfileTabPage extends StatelessWidget {
  bool isParent = false;
  ProfileTabPage({this.isParent = false});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<ProfileTabPageModel>(
        create: (context) =>
            ProfileTabPageModel(context: context, locale: locale),
        child: Consumer<ProfileTabPageModel>(builder: (context, model, __) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: locale.locale.languageCode == 'en'
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: ToggleSwitch(
                          minWidth: 50.0,
                          minHeight: 35.0,
                          fontSize: 13.0,
                          initialLabelIndex:
                              locale.locale.languageCode == 'en' ? 1 : 0,
                          activeBgColor: [
                            AppColors.primaryColor,
                            AppColors.accentElement
                          ],
                          activeFgColor: Colors.grey[100],
                          inactiveBgColor: Colors.grey[100],
                          inactiveFgColor: Colors.grey[900],
                          labels: ['عر', 'En'],
                          onToggle: (index) {
                            print(index);
                            Provider.of<AppLanguageModel>(context,
                                    listen: false)
                                .changeLanguage(Locale(
                                    locale.locale.languageCode == 'en'
                                        ? 'ar'
                                        : 'en'));
                          },
                          totalSwitches: 2,
                        ),
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: model.busy
                                    ? Loading()
                                    : CachedNetworkImage(
                                        imageUrl:
                                            "${model.api.imagePath}${model.auth?.user?.avatar}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                                  // width: SizeConfig.widthMultiplier * 20,
                                                  // height: SizeConfig.heightMultiplier * 10,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                        placeholder: (context, url) =>
                                            Loading(),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        10,
                                                height: SizeConfig
                                                        .heightMultiplier *
                                                    5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Image.asset(
                                                    'assets/images/appicon.png'))),
                              ),
                            ),
                            model.busy || !model.auth.userLoged
                                ? SizedBox()
                                : Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () async {
                                        // await model
                                        //     .uploadImage(ImageSource.gallery);
                                      },
                                      highlightColor: AppColors.red,
                                      child: CircleAvatar(
                                        backgroundColor: AppColors.primaryColor,
                                        child: Icon(Icons.camera_alt_outlined),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          // "Moaz Hamed"
                          "${model.auth?.user?.name ?? ''}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      if (locator<AuthenticationService>().userLoged &&
                          model.auth.user.userType == 'Student')
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                  text: model.auth.user.studentId));
                              UI.showSnackBarMessage(
                                  context: context,
                                  message: locale.get('Copied to Clipboard'));
                            },
                            child: Text(
                              "${locale.get('Student ID')} :" +
                                  "${model.auth.user.studentId}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(
                                      fontSize: 16,
                                      color: AppColors.primaryColorDark),
                            ),
                          ),
                        ),
                      isParent
                          ? InkWell(
                              onTap: () {
                                pushNewScreen(context,
                                    screen: StudentLoginPage(isParent: true),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideUp);
                              },
                              child: Text(
                                locale.get("Manage another son account"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 16,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold),
                              ),
                            )
                          : locator<AuthenticationService>().userLoged &&
                                  locator<AuthenticationService>()
                                          .user
                                          ?.userType ==
                                      'Teacher'
                              ? TextField(
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  readOnly: false,
                                  showCursor: true,
                                  onSubmitted: (string) {
                                    model.updateBio();
                                  },
                                  onChanged: (string) {
                                    model.setState();
                                  },
                                  enableSuggestions: true,
                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                      counter: Text(model
                                          .bioController.text.length
                                          .toString()),
                                      counterStyle:
                                          TextStyle(color: AppColors.red),
                                      // counterText: locale.get('140 Letter'),
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(2),
                                      //   borderSide: BorderSide(
                                      //     color: AppColors.primaryColor
                                      //         .withOpacity(0.5),
                                      //     width: 0.5,
                                      //   ),
                                      // ),
                                      hintText:
                                          locale.get('Type a 140 letter bio'),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      contentPadding: EdgeInsets.all(8)),
                                  controller: model.bioController,
                                )
                              : SizedBox(),
                      if (!model.auth.userLoged)
                        InkWell(
                            onTap: () => pushNewScreen(context,
                                screen: StudentLoginPage(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideRight),
                            child: Text(
                              locale.get('Login to Manage your account'),
                              style:
                                  TextStyle(color: AppColors.primaryColorDark),
                            )),
                      userDataTile(model),
                      // languageTile(context, model),
                      appData(context, model),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: SizeConfig.widthMultiplier * 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(model.settings.facebook);
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    FlatIcons.con_facebook,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(model.settings.twitter);
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    FlatIcons.con_twitter,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(model.settings.instagram);
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    FlatIcons.con_instagram,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(model.settings.snapchat);
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    FlatIcons.con_snapchat,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(model.settings.whatsapp);
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    FlatIcons.con_whatsapp,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            AnimatedIconButton(
                              onPressed: () async {
                                await launch(
                                    'tel:${model.settings.phoneNumber}');
                              },
                              size: 20,
                              splashColor: Colors.redAccent,
                              icons: [
                                AnimatedIconItem(
                                  backgroundColor: Colors.grey.shade100,
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      model.auth.userLoged
                          ? InkWell(
                              onTap: () {
                                locator<AuthenticationService>().signOut;
                                pushNewScreen(context,
                                    screen: StudentLoginPage(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.slideRight);
                              },
                              child: Text(
                                locale.get('Sign Out'),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: AppColors.primaryColor,
                                        fontSize: 18),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: locator<AuthenticationService>().userLoged &&
                                model.auth.user.userType == 'Teacher'
                            ? 100
                            : 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget userDataTile(ProfileTabPageModel model) {
    final locale = AppLocalizations.of(model.context);

    return model.auth.userLoged
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      pushNewScreen(model.context,
                              screen: AccountInfoPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.slideUp)
                          .then((value) => model.setState());
                    },
                    title: Text(locale.get("Account Info")),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blueGrey,
                    ),
                  ),
                  locator<AuthenticationService>().userLoged &&
                          locator<AuthenticationService>().user.userType ==
                              "Teacher"
                      ? ListTile(
                          onTap: () {
                            pushNewScreen(model.context,
                                screen: const WalletPage(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp);
                          },
                          title: Text(locale.get("Wallet")),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blueGrey,
                          ),
                        )
                      : SizedBox(),
                  locator<AuthenticationService>().userLoged &&
                          locator<AuthenticationService>().user.userType ==
                              "Teacher"
                      ? ListTile(
                          onTap: () {
                            pushNewScreen(model.context,
                                screen: const BankAccountsPage(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.slideUp);
                          },
                          title: Text(locale.get("Bank Accounts")),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.blueGrey,
                          ),
                        )
                      : SizedBox(),
                  ListTile(
                    onTap: () {
                      ChatService.chatuserid =
                          locator<AuthenticationService>().user.sId;

                      pushNewScreen(model.context,
                          screen: MessagesPage(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.slideUp);
                    },
                    title: Text(locale.get("Messages")),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.blueGrey,
                    ),
                  ),
                  // ListTile(
                  //   title: Text(locale.get("Wishlist")),
                  //   trailing: Icon(
                  //     Icons.arrow_forward_ios_rounded,
                  //     color: Colors.blueGrey,
                  //   ),
                  //   onTap: () {
                  //     UI.push(context, WishlistPage());
                  //   },
                  // ),
                  if (locator<AuthenticationService>().userLoged &&
                      model.auth.user.userType == "Teacher")
                    ListTile(
                      title: Text(locale.get("Schedule")),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.blueGrey,
                      ),
                      onTap: () {
                        pushNewScreen(model.context,
                            screen: SchedulePage(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.slideUp);
                      },
                    ),
                  if (locator<AuthenticationService>().userLoged &&
                      model.auth.user.userType != "Teacher")
                    ListTile(
                      title: Text(locale.get("Statistics")),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.blueGrey,
                      ),
                      onTap: () {
                        pushNewScreen(model.context,
                            screen: StatisticsPage(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.slideUp);
                      },
                    ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  Widget appData(context, ProfileTabPageModel model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
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
        child: Column(
          children: [
            InkWell(
              onTap: () {
                pushNewScreen(context,
                    screen: StaticPage(
                        title: 'About Us', content: model.settings.about),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp);
              },
              child: ListTile(
                title: Text(locale.get("Who Are We")),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                UI.toast('coming soon');
              },
              child: ListTile(
                title: Text(locale.get("TS Academy Press")),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pushNewScreen(context,
                    screen: ContactUs(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp);
              },
              child: ListTile(
                title: Text(locale.get("Contact Us")),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pushNewScreen(context,
                    screen: StaticPage(
                        title: 'Terms Of Use', content: model.settings.terms),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp);
                ;
              },
              child: ListTile(
                title: Text(locale.get("Terms Of Use")),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                pushNewScreen(context,
                    screen: StaticPage(
                        title: 'Privacy Policy',
                        content: model.settings.privacy),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.slideUp);
                ;
              },
              child: ListTile(
                title: Text(locale.get("Privacy Policy")),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
