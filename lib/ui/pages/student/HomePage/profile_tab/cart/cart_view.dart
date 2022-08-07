import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/MainHome/main_home_view.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/main_button.dart';
import '../../../../../routes/ui.dart';
import '../../../../../styles/colors.dart';
import '../../courses_tab/course_page/course_page_view.dart';
import 'cart_view_model.dart';
import 'checkout.page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CartPageModel>(
      create: (context) => CartPageModel(context, locale),
      child: Consumer<CartPageModel>(
        builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Cart"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: model.busy
                ? const Center(child: Loading())
                : model.courses.isEmpty
                    ? Center(
                        child: Text(locale.get('Your cart is empty')),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: model.courses.length,
                                itemBuilder: (ctx, index) =>
                                    buildCartItem(context, model, index),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  locale.get("Total"),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  // "${model.courses[0].price} \$",
                                  "${model.total} ",
                                  style: Theme.of(model.context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: MainButton(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                text: locale.get("Go To Checkout"),
                                onTap: () {
                                  UI.push(context, Checkout());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }

  Widget buildCartItem(BuildContext context, CartPageModel model, int index) {
    return InkWell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImage(
            height: 80,
            width: 80,
            boxFit: BoxFit.cover,
            imageUrl:
                "${model.api.imagePath}${model.courses[index].cover?.localized(context) ?? ''}",
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.courses[index].name?.localized(context) ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(model.context).textTheme.bodyText1,
                  ),
                  Text(
                    model.courses[index].info.localized(context),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(model.context).textTheme.bodyText2,
                  ),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: model.courses[index].rate.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        ignoreGestures: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.rateColorDark,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      Text(
                        model.courses[index].rate?.toStringAsFixed(2),
                        style: Theme.of(model.context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                                fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "( ${model.courses[index].reviews?.length} )",
                        style: Theme.of(model.context)
                            .textTheme
                            .bodyText1
                            .copyWith(
                                fontSize: 12, fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                  Text(
                    model.courses[index].price.toString(),
                    style: Theme.of(model.context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    child: Text(
                      model.locale.get("Remove Course"),
                      style: TextStyle(
                        color: Color(0xFF39A9C7),
                      ),
                    ),
                    onPressed: () {
                      model.showAlertDialog(model.courses[index].sId);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () {
        UI.push(model.context, CoursePage(courseId: model.courses[index].sId));
      },
    );
  }

  Widget buildPaymentSuccessfully(CartPageModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(),
        SvgPicture.asset(
          "assets/images/Order completed.svg",
        ),
        Text(
          model.locale.get("Payment completed successfully"),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainButton(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              text: model.locale.get("Browse Courses"),
              onTap: () {
                UI.pushReplaceAll(model.context, MainUI());
              },
            ),
            // SizedBox(width: 20),
            // Container(
            //   width: SizeConfig.widthMultiplier * 45,
            //   child: MainButton(
            //     height: 50,
            //     padding: const EdgeInsets.symmetric(horizontal: 30),
            //     text: model.locale.get("Browse My Courses"),
            //     onTap: () {},
            //   ),
            // ),
          ],
        ),
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
      ],
    );
  }
}
