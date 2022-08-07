import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ts_academy/core/models/search_model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/category_Page/category_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/course_widget.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/instractor_widget.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/search_tab/search_tab_view_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';

class SearchTabPage extends StatefulWidget {
  @override
  _SearchTabPageState createState() => _SearchTabPageState();
}

class _SearchTabPageState extends State<SearchTabPage> {
  final searchText = TextEditingController();
  @override
  void dispose() {
    // Logger().e('e');
    super.dispose();
  }

  String searchWord;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<SearchTabViewModel>(
        create: (context) => SearchTabViewModel(context: context),
        child: Consumer<SearchTabViewModel>(builder: (context, model, __) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.2),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            margin: EdgeInsets.all(12),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                                new Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      searchWord = value;
                                      model.search(value);
                                      model.setState();
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: locale.get("Search"),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      isDense: true,
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            locator<AuthenticationService>().userLoged
                                ? UI.push(context, CartPage())
                                : UI.push(context, StudentLoginPage());
                          },
                          child: SvgPicture.asset(
                            "assets/images/Cart.svg",
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    model.busy
                        ? Center(child: Loading())
                        : model.searchResult == null || !model.haveSearchResult
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      child: Text(
                                        locale.get('Subjects'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontSize: 20,
                                            ),
                                      ),
                                    ),
                                    Expanded(child: categories(model, context))
                                  ],
                                ),
                              )
                            : Expanded(
                                child: searchResult(model.searchResult, model)),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Widget categories(SearchTabViewModel model, context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(children: [
          ...model.subjects.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      UI.push(
                          context,
                          CategoryPage(
                            subjectName: e.name,
                            subjectId: e.sId,
                          ));
                    },
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${model.api.imagePath}${e.image}",
                          imageBuilder: (context, imageProvider) => Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Colors.black54, BlendMode.color)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: SizeConfig.widthMultiplier * 70,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              e.name.localized(context),
                              maxLines: 1,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  Widget searchResult(SearchModel search, SearchTabViewModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        child: SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () {
        model.search(searchWord);
      },
      onLoading: () {},
      controller: model.refreshController,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                model.haveSearchResult = false;
                model.setState();
              },
              child: Text(
                locale.get('Clear'),
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              ),
            ),
          ),
          search.courses == null || search.courses?.isEmpty
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        locale.get('Courses'),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                    ),
                    Container(
                        height: SizeConfig.heightMultiplier * 45,
                        child: ListView.builder(
                            itemCount: search.courses.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CourseCardHorizontal(
                                course: search.courses[index],
                                topRated: true,
                              );
                            })),
                  ],
                ),
          search.teachers.isEmpty
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.get('Teachers'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    Container(
                        height: SizeConfig.heightMultiplier * 30,
                        child: ListView.builder(
                            itemCount: search.teachers.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InstractorCard(
                                instructor: search.teachers[index],
                              );
                            })),
                  ],
                )
        ],
      ),
    ));
  }
}
