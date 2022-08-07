import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/models/course.dart';
import 'package:ts_academy/core/models/promotion.model.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/api/http_api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/styles/text_styles.dart';
import 'package:ts_academy/ui/widgets/cached_image.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/main_button.dart';
import 'package:ts_academy/ui/widgets/main_reactivefield.dart';
import 'package:ts_academy/ui/widgets/payment_web_view.page.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

class Checkout extends StatefulWidget {
  FormGroup form = FormGroup({
    "promoCode": FormControl<String>(validators: [Validators.minLength(5)]),
    "courses": FormControl(validators: [Validators.required]),
    "paymentMethod":
        FormControl<String>(value: 'VISA', validators: [Validators.required]),
  });
  Checkout({Key key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  double total = 0;

  Promotion promotion;

  bool madasIsExpanded = false;
  bool madaShowBackSide = false;

  AppLocalizations locale;
  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          locale.get("Checkout"),
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Course>>(
            future: getCart(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Course> courses = snapshot.data;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ReactiveForm(
                    formGroup: widget.form,
                    child: Column(
                      children: [
                        Container(
                          height: SizeConfig.heightMultiplier * 20,
                          color: Colors.blueGrey.shade100.withOpacity(0.25),
                          child: ListView.builder(
                            itemCount: courses.length,
                            itemBuilder: (ctx, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: buildCartItem(courses, index),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MainReactiveField(
                                  label: locale.get("Promo Code"),
                                  controllerName: "promoCode"),
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: SizeConfig.widthMultiplier * 35,
                              child: ReactiveFormConsumer(
                                builder: (context, formGroup, child) =>
                                    MainButton(
                                  height: 50,
                                  color: formGroup.control('promoCode').invalid
                                      ? Colors.blueGrey
                                      : AppColors.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  text: locale.get("Apply"),
                                  onTap: formGroup.control('promoCode').valid
                                      ? () {
                                          getPromoCode();
                                        }
                                      : () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          height: SizeConfig.heightMultiplier * 15,
                          color: Colors.blueGrey.shade100.withOpacity(0.25),
                          width: SizeConfig.widthMultiplier * 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      locale.get("Total"),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      // "${courses[0].price} \$",
                                      // promotion == null
                                      "${total} ",
                                      // : "${total - (total * promotion.discountPercent / 100)}",

                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                if (promotion != null) ...[
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        locale.get("Discount"),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.red),
                                      ),
                                      Text(
                                        // "${courses[0].price} \$",
                                        // promotion == null
                                        // "${total} ",
                                        "${(total * promotion.discountPercent / 100)}",

                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.red),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        locale.get("Price After Discount"),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.red),
                                      ),
                                      Text(
                                        // "${courses[0].price} \$",
                                        // promotion == null
                                        "${total - (total * promotion.discountPercent / 100)}",

                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                              fontSize: 20,
                                              color: AppColors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Card(
                            shadowColor:
                                AppColors.primaryColor.withOpacity(0.2),
                            elevation: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        locale.get('Select Payment Method'),
                                        style: TextStyles.subHeaderStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ReactiveField(
                                  type: ReactiveFields.RADIO_LISTTILE,
                                  controllerName: 'paymentMethod',
                                  radioTitle: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/Mada_Logo.png',
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                  radioVal: 'MADA',
                                ),
                                Divider(),
                                ReactiveField(
                                  type: ReactiveFields.RADIO_LISTTILE,
                                  controllerName: 'paymentMethod',
                                  radioTitle: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/visa_master.png',
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                  radioVal: 'VISA',
                                ),
                              ],
                            )),

                        // mada(),
                        // Divider(),
                        // visaMaster(),
                        Divider(),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: ReactiveFormConsumer(
                            builder: (context, formGroup, child) => MainButton(
                              color: formGroup.valid
                                  ? AppColors.primaryColor
                                  : Colors.blueGrey,
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              text: locale.get("Checkout"),
                              onTap: formGroup.valid
                                  ? () {
                                      checkout();
                                    }
                                  : () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Loading();
            }),
      ),
    );
  }

  InputDecoration textInputDecoration(String label) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.4),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.4),
          borderRadius: BorderRadius.all(Radius.circular(40))),
      hintText: label,
      fillColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      counterStyle: TextStyle(color: AppColors.primaryColorDark),
      hintStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade400),
    );
  }

  Widget buildCartItem(List<Course> courses, int index) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImage(
            height: 80,
            width: 80,
            boxFit: BoxFit.cover,
            imageUrl: "${locator<HttpApi>().imagePath}${courses[index].cover}",
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courses[index].name.localized(context),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
                ),
                Text(
                  courses[index].description.localized(context),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
                Row(
                  children: [
                    // RatingBar.builder(
                    //   initialRating: courses[index].cRating.toDouble(),
                    //   minRating: 1,
                    //   direction: Axis.horizontal,
                    //   allowHalfRating: true,
                    //   itemCount: 5,
                    //   itemSize: 20,
                    //   // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    //   ignoreGestures: true,
                    //   itemBuilder: (context, _) => Icon(
                    //     Icons.star_rounded,
                    //     color: AppColors.rateColorDark,
                    //   ),
                    //   onRatingUpdate: (rating) {
                    //     print(rating);
                    //   },
                    // ),
                    SizedBox(width: 5),
                    Text(
                      "( ${courses[index].reviews.length} )",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                Text(
                  courses[index].price.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<List<Course>> getCart() async {
    var res = await locator<HttpApi>().getStudentCart(context);
    List<Course> courses;
    res.fold((error) {
      UI.showSnackBarMessage(context: context, message: error.message);
    }, (data) {
      courses = data
          .map<Course>(
            (item) => Course.fromJson(item),
          )
          .toList();
      total = 0;
      widget.form.control('courses').updateValue(data);
      courses.forEach((element) {
        total = total + element.price;
      });
    });
    return Future.sync(() => courses);
  }

  void getPromoCode() {
    locator<HttpApi>()
        .request(
            EndPoint.GET_PROMOTION_BY_CODE +
                widget.form.control('promoCode').value,
            headers: Header.userAuth,
            type: RequestType.Get)
        .then((value) {
      value.fold((e) {
        Logger().wtf(e);
        UI.showSnackBarMessage(context: context, message: e.message);
      }, (promo) {
        UI.showSnackBarMessage(
            context: context, message: locale.get('Promo Code applied'));
        setState(() {
          promotion = Promotion.fromJson(promo);
        });
      });
    });
  }

  void checkout() async {
    List courses = widget.form.control('courses').value;

    Map<String, dynamic> checkoutBody = {
      "courses": courses.map((e) => {'_id': e['_id']}).toList(),
      "paymentMethod": widget.form.control('paymentMethod').value,
      "promoCode": widget.form.control('promoCode').value
    };
    if (locator<AuthenticationService>().user.userType == 'Parent') {
      checkoutBody['purchasedFor'] =
          locator<AuthenticationService>().user.studentId;
    }

    Logger().wtf(checkoutBody);

    var res = await locator<HttpApi>().checkout(context, body: checkoutBody);
    res.fold((error) {
      Logger().wtf(error);

      UI.showSnackBarMessage(context: context, message: error.message);
    }, (data) {
      if (data.length > 0) {
        String url = BaseUrl +
            "Checkout/payment/${data['_id']}?paymentMethod=${data['paymentMethod']}";

        pushNewScreen(
            context,
           screen: PaymentWebbView(
              url: url,
            ),pageTransitionAnimation: PageTransitionAnimation.sizeUp,withNavBar: false);
      }
      // showModalBottomSheet(
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(10.0),
      //             topRight: Radius.circular(10.0))),
      //     isScrollControlled: true,
      //     context: context,
      //     builder: (context) {
      //       return PaymentWebbView(
      //         url: url,
      //       );
      //     });
      Logger().wtf(data);
      // UI.push(context, MainUI());
    });
  }

  // mada() {
  //   return ExpansionTile(
  //       trailing: Icon(
  //         madasIsExpanded ? Icons.remove : Icons.add,
  //         color: AppColors.primaryColor,
  //       ),
  //       tilePadding: EdgeInsets.all(16),
  //       key: UniqueKey(),
  //       initiallyExpanded: madasIsExpanded,
  //       onExpansionChanged: (value) {
  //         setState(() {
  //           widget.form.control('cardNumber').updateValue(null);
  //           widget.form.control('holder').updateValue(null);
  //           widget.form.control('expireDate').updateValue(null);
  //           widget.form.control('cvv').updateValue(null);
  //           cardNumberController.clear();
  //           holderController.clear();
  //           expireDateController.clear();
  //           cvvController.clear();
  //           madasIsExpanded = value;
  //           visasIsExpanded = !value;
  //         });
  //       },
  //       backgroundColor: Colors.white,
  //       collapsedBackgroundColor: Colors.white,
  //       title: SizedBox(),
  //       leading: Image.asset(
  //         'assets/images/Mada_Logo.png',
  //         height: 40,
  //       ),
  //       children: [
  //         Directionality(
  //           textDirection: TextDirection.ltr,
  //           child: CreditCard(
  //               cardNumber: widget.form.control('cardNumber').value,
  //               cardExpiry: widget.form.control('expireDate').value,
  //               cardHolderName: widget.form.control('holder').value,
  //               cvv: widget.form.control('cvv').value,
  //               bankName: "mada",
  //               backLayout: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 30,
  //                   ),
  //                   Container(
  //                     color: AppColors.primaryColor,
  //                     height: 50,
  //                     width: double.maxFinite,
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       Container(
  //                         width: SizeConfig.widthMultiplier * 50,
  //                         height: 50,
  //                         color: Colors.grey,
  //                       ),
  //                       Container(
  //                         height: 50,
  //                         width: SizeConfig.widthMultiplier * 20,
  //                         child: Align(
  //                           alignment: Alignment.center,
  //                           child: Text(
  //                             widget.form.control('cvv').value ?? '',
  //                             style: TextStyle(
  //                                 fontSize: 21,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: AppColors.red),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Image.asset(
  //                       'assets/images/Mada_Logo.png',
  //                       height: 20,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               showBackSide: madaShowBackSide,
  //               frontBackground: Container(
  //                 color: Colors.blueGrey.shade300,
  //                 width: double.maxFinite,
  //                 height: double.maxFinite,
  //                 child: Stack(
  //                   children: [
  //                     Positioned(
  //                       bottom: 4,
  //                       right: 10,
  //                       width: 80,
  //                       height: 50,
  //                       child: Image.asset(
  //                         'assets/images/Mada_Logo.png',
  //                         height: 50,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               cardType: CardType.other,
  //               backBackground: CardBackgrounds.white,
  //               showShadow: false,
  //               textExpDate: 'Exp. Date',
  //               textName: 'Name',
  //               textExpiry: 'MM/YYYY'),
  //         ),
  //         Container(
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               children: [
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     maxLength: 19,
  //                     decoration:
  //                         textInputDecoration(locale.get('Card Number')),
  //                     enableInteractiveSelection: false,
  //                     showCursor: true,
  //                     controller: cardNumberController,
  //                     key: cardNumberKey,
  //                     cursorColor: AppColors.primaryColor,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: [CreditCardNumberInputFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('cardNumber').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration:
  //                         textInputDecoration(locale.get('Card Holder Name')),
  //                     key: holderKey,
  //                     controller: holderController,
  //                     keyboardType: TextInputType.name,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('holder').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration:
  //                         textInputDecoration(locale.get('Expire Date')),
  //                     key: expireDateKey,
  //                     controller: expireDateController,
  //                     keyboardType: TextInputType.datetime,
  //                     inputFormatters: [CreditCardExpirationDateFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('expireDate').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration: textInputDecoration(locale.get('CVC')),
  //                     key: cvcKey,
  //                     controller: cvvController,
  //                     focusNode: madaFocusNode,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: [CreditCardCvcInputFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('cvv').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ]);
  // }

  // visaMaster() {
  //   return ExpansionTile(
  //       trailing: Icon(
  //         visasIsExpanded ? Icons.remove : Icons.add,
  //         color: AppColors.primaryColor,
  //       ),
  //       tilePadding: EdgeInsets.all(16),
  //       key: UniqueKey(),
  //       initiallyExpanded: visasIsExpanded,
  //       onExpansionChanged: (value) {
  //         setState(() {
  //           widget.form.control('cardNumber').updateValue(null);
  //           widget.form.control('holder').updateValue(null);
  //           widget.form.control('expireDate').updateValue(null);
  //           widget.form.control('cvv').updateValue(null);
  //           cardNumberController.clear();
  //           holderController.clear();
  //           expireDateController.clear();
  //           cvvController.clear();
  //           visasIsExpanded = value;
  //           madasIsExpanded = !value;
  //         });
  //       },
  //       backgroundColor: Colors.white,
  //       collapsedBackgroundColor: Colors.white,
  //       title: SizedBox(),
  //       leading: Image.asset(
  //         'assets/images/visa_master.png',
  //         height: 40,
  //       ),
  //       children: [
  //         Directionality(
  //           textDirection: TextDirection.ltr,
  //           child: CreditCard(
  //               cardNumber: widget.form.control('cardNumber').value,
  //               cardExpiry: widget.form.control('expireDate').value,
  //               cardHolderName: widget.form.control('holder').value,
  //               cvv: widget.form.control('cvv').value,
  //               bankName: isVisa == null
  //                   ? ''
  //                   : isVisa == true
  //                       ? 'VISA'
  //                       : 'MASTERCARD',
  //               showBackSide: visaShowBackSide ?? false,
  //               frontBackground: CardBackgrounds.black,
  //               backBackground: CardBackgrounds.white,
  //               backLayout: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 30,
  //                   ),
  //                   Container(
  //                     color: Colors.black,
  //                     height: 50,
  //                     width: double.maxFinite,
  //                   ),
  //                   SizedBox(
  //                     height: 20,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: <Widget>[
  //                       Container(
  //                         width: SizeConfig.widthMultiplier * 50,
  //                         height: 50,
  //                         color: Colors.grey,
  //                       ),
  //                       Container(
  //                         height: 50,
  //                         width: SizeConfig.widthMultiplier * 20,
  //                         child: Align(
  //                           alignment: Alignment.center,
  //                           child: Text(
  //                             widget.form.control('cvv').value ?? '',
  //                             style: TextStyle(
  //                                 fontSize: 21,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: AppColors.red),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Image.asset(
  //                       'assets/images/visa_master.png',
  //                       height: 20,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //               cardType: isVisa == null
  //                   ? CardType.other
  //                   : isVisa == true
  //                       ? CardType.visa
  //                       : CardType.masterCard,
  //               showShadow: false,
  //               textExpDate: 'Exp. Date',
  //               textName: 'Name',
  //               textExpiry: 'MM/YYYY'),
  //         ),
  //         Container(
  //           color: Colors.white,
  //           child: Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               children: [
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration:
  //                         textInputDecoration(locale.get('Card Number')),
  //                     enableInteractiveSelection: false,
  //                     focusNode: visaNumberFocusNode,
  //                     controller: cardNumberController,
  //                     showCursor: true,
  //                     maxLength: 19,
  //                     key: cardNumberKey,
  //                     cursorColor: AppColors.primaryColor,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: [CreditCardNumberInputFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('cardNumber').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration:
  //                         textInputDecoration(locale.get('Card Holder Name')),
  //                     key: holderKey,
  //                     keyboardType: TextInputType.name,
  //                     controller: holderController,
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('holder').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration:
  //                         textInputDecoration(locale.get('Expire Date')),
  //                     key: expireDateKey,
  //                     controller: expireDateController,
  //                     keyboardType: TextInputType.datetime,
  //                     inputFormatters: [CreditCardExpirationDateFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('expireDate').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Directionality(
  //                   textDirection: TextDirection.ltr,
  //                   child: TextFormField(
  //                     decoration: textInputDecoration(locale.get('CVC')),
  //                     key: cvcKey,
  //                     controller: cvvController,
  //                     focusNode: visaFocusNode,
  //                     keyboardType: TextInputType.number,
  //                     inputFormatters: [CreditCardCvcInputFormatter()],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         widget.form.control('cvv').updateValue(value);
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ]);
  // }
}
