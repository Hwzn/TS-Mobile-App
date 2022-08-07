// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:ts_academy/core/services/localization/localization.dart';
// import 'package:ts_academy/ui/styles/colors.dart';
// import 'package:ts_academy/ui/styles/size_config.dart';

// import 'main_home_view_model.dart';

// class BottomNavigationView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final locale = AppLocalizations.of(context);
//     return Consumer<MainUIVM>(builder: (context, model, __) {
//       return BottomNavigationBar(
//         currentIndex: model.currentPage,
//         onTap: model.changePage,
//         items: [
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/home.svg',
//                 height: SizeConfig.heightMultiplier * 3,
//                 width: SizeConfig.widthMultiplier * 15,
//                 color: model.currentPage == 0
//                     ? AppColors.primaryColor
//                     : Colors.grey,
//               ),
//               label: locale.get("Home") ?? "Home"),
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/search.svg',
//                 height: SizeConfig.heightMultiplier * 3,
//                 width: SizeConfig.widthMultiplier * 15,
//                 color: model.currentPage == 1
//                     ? AppColors.primaryColor
//                     : Colors.grey,
//               ),
//               label: locale.get("Search") ?? "Search"),
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/Courses.svg',
//                 height: SizeConfig.heightMultiplier * 3,
//                 width: SizeConfig.widthMultiplier * 15,
//                 color: model.currentPage == 2
//                     ? AppColors.primaryColor
//                     : Colors.grey,
//               ),
//               label: locale.get("Courses") ?? "Courses"),
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/Notifications.svg',
//                 height: SizeConfig.heightMultiplier * 3,
//                 width: SizeConfig.widthMultiplier * 15,
//                 color: model.currentPage == 3
//                     ? AppColors.primaryColor
//                     : Colors.grey,
//               ),
//               label: locale.get('Notification') ?? 'Notification'),
//           BottomNavigationBarItem(
//               icon: SvgPicture.asset(
//                 'assets/images/home.svg',
//                 height: SizeConfig.heightMultiplier * 3,
//                 width: SizeConfig.widthMultiplier * 15,
//                 color: model.currentPage == 4
//                     ? AppColors.primaryColor
//                     : Colors.grey,
//               ),
//               label: locale.get("Home") ?? "Home")
//         ],
//       );
//     });
//   }
// }
