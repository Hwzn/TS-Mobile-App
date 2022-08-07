import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/pages/student/Auth/login/login_page_view.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/cart/cart_view.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      // padding: const EdgeInsets.all(8.0),
      icon: SvgPicture.asset(
        "assets/images/Cart.svg",
        color: Colors.white,
      ),
      onPressed: () {
        if (locator<AuthenticationService>().userLoged) {
          pushNewScreen(context,
              screen: CartPage(),
              pageTransitionAnimation: PageTransitionAnimation.slideUp);
        } else {
          pushNewScreen(context,
              screen: StudentLoginPage(),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
              withNavBar: false);
        }
      },
    );
  }
}
