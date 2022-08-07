import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/loading.dart';
import 'package:ts_academy/ui/widgets/main_dropdown.dart';
import 'statistics_viewmodel.dart';
import 'package:reactive_forms/reactive_forms.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<StatisticsPageModel>(
      create: (context) => StatisticsPageModel(context, locale),
      child: Consumer<StatisticsPageModel>(
        builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Statistics"),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 20),
              ),
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios, color: Colors.black)),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: model.busy
                ? Center(child: Loading())
                : Container(
                    padding: const EdgeInsets.all(10),
                    child: ReactiveForm(
                      formGroup: model.form,
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.heightMultiplier * 5),
                          MainReactiveDropDown(
                            model: model,
                            label: locale.get("Subject"),
                            controllerName: "subject",
                            itemList: model.subjects.map((e) {
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name.localized(context)),
                                  onTap: () {
                                    print(e.sId);
                                    print("***************************");
                                    model.getStudentReview(e.sId);
                                  });
                            }).toList(),
                          ),
                          SizedBox(height: SizeConfig.heightMultiplier * 5),
                          Container(
                            width: double.infinity,
                            height: SizeConfig.heightMultiplier * 40,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              enableSideBySideSeriesPlacement: true,
                              enableMultiSelection: true,
                              enableAxisAnimation: true,
                              legend: Legend(),
                              series: <CartesianSeries>[
                                ColumnSeries<ChartData, String>(
                                  dataSource: model.chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y,
                                  color: AppColors.primaryColor,
                                  enableTooltip: true,
                                  width: 0.5,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                                ColumnSeries<ChartData, String>(
                                  dataSource: model.chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y1,
                                  color: AppColors.red,
                                  width: 0.2,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: SizeConfig.heightMultiplier * 5),
                          Row(
                            children: [
                              Expanded(
                                child: buildStatisticsItem(
                                    "${model.lastMonthKey}", 0xFFCC1C60),
                              ),
                              Expanded(
                                child: buildStatisticsItem(
                                    "${model.currentMonthKey}", 0xFF2CD9C5),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget buildStatisticsItem(String title, int color) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(width: 10),
            Text("$title"),
          ],
        ),
      ),
    );
  }
}
