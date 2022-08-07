// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ts_academy/core/services/localization/localization.dart';
// import 'package:ts_academy/ui/styles/size_config.dart';
// import 'package:ts_academy/ui/widgets/main_dropdown.dart';
// import 'statistics_viewmodel.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:fl_chart/fl_chart.dart';

// class StatisticsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final locale = AppLocalizations.of(context);
//     return ChangeNotifierProvider<StatisticsPageModel>(
//       create: (context) => StatisticsPageModel(context, locale),
//       child: Consumer<StatisticsPageModel>(
//         builder: (context, model, __) {
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               title: Text(
//                 locale.get("Statistics"),
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(fontSize: 20),
//               ),
//               leading: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.arrow_back_ios, color: Colors.black)),
//               backgroundColor: Colors.transparent,
//               elevation: 0.0,
//             ),
//             body: model.busy
//                 ? Center(child: CircularProgressIndicator())
//                 : Container(
//                     padding: const EdgeInsets.all(10),
//                     child: ReactiveForm(
//                       formGroup: model.form,
//                       child: Column(
//                         children: [
//                           SizedBox(height: SizeConfig.heightMultiplier * 5),
//                           MainReactiveDropDown(
//                             model: model,
//                             label: locale.get("Subject"),
//                             controllerName: "subject",
//                             itemList: model.subjectList.map((e) {
//                               return DropdownMenuItem(
//                                   value: e,
//                                   child: Text(e),
//                                   onTap: () {
//                                     print(e);
//                                   });
//                             }).toList(),
//                           ),
//                           SizedBox(height: SizeConfig.heightMultiplier * 5),
//                           Container(
//                             width: double.infinity,
//                             height: SizeConfig.heightMultiplier * 40,
//                             child: BarChart(
//                               BarChartData(
//                                 borderData: FlBorderData(
//                                   border: Border(
//                                     top: BorderSide.none,
//                                     right: BorderSide.none,
//                                     left: BorderSide(width: 0.5),
//                                     bottom: BorderSide(width: 0.5),
//                                   ),
//                                 ),
//                                 groupsSpace: 10,
//                                 barGroups: [
//                                   barCharItem2(
//                                       value1: 4.1,
//                                       value2: 5,
//                                       color: 0xFFFF6C40),
//                                   barCharItem2(
//                                       value1: 8,
//                                       value2: 6.5,
//                                       color: 0xFFFFE700),
//                                   barCharItem2(
//                                       value1: 9.1,
//                                       value2: 5.3,
//                                       color: 0xFFCC1C60),
//                                   barCharItem2(
//                                       value1: 11,
//                                       value2: 15,
//                                       color: 0xFF2CD9C5),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: GridView.builder(
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: 27 / 9,
//                               ),
//                               itemCount: 4,
//                               itemBuilder: (ctx, index) {
//                                 return buildStatisticsItem(
//                                     "Attendees", 0xFFCC1C60);
//                               },
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//           );
//         },
//       ),
//     );
//   }

//   Widget buildStatisticsItem(String title, int color) {
//     return Container(
//       child: Row(
//         children: [
//           Container(
//             height: 12,
//             width: 12,
//             decoration: BoxDecoration(
//               color: Color(color),
//               borderRadius: BorderRadius.circular(6),
//             ),
//           ),
//           SizedBox(width: 10),
//           Text("$title"),
//         ],
//       ),
//     );
//   }

//   BarChartRodData barCharItem(double value, int color) {
//     return BarChartRodData(
//       y: value,
//       width: 10,
//       colors: [Color(color)],
//     );
//   }

//   BarChartGroupData barCharItem2({
//     double value1,
//     double value2,
//     int color,
//   }) {
//     return BarChartGroupData(
//       barsSpace: 20,
//       x: 1,
//       barRods: [
//         BarChartRodData(
//           y: value1,
//           width: 10,
//           colors: [Color(color)],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(5),
//             topRight: Radius.circular(5),
//             bottomLeft: Radius.circular(0),
//             bottomRight: Radius.circular(0),
//           ),
//         ),
//         BarChartRodData(
//           y: value2,
//           width: 10,
//           colors: [Color(color)],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(5),
//             topRight: Radius.circular(5),
//             bottomLeft: Radius.circular(0),
//             bottomRight: Radius.circular(0),
//           ),
//         ),
//       ],
//     );
//   }
// }
