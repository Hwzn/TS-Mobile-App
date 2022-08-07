import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/pages/student/HomePage/home_tab/category_Page/category_page_view_model.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'package:ts_academy/ui/widgets/buttons/normal_button.dart';
import 'package:ts_academy/ui/widgets/reactive_widgets.dart';

class FilterPage extends StatelessWidget {
  CategoryPageModel model;
  BuildContext ctx;
  FilterPage({this.model, this.ctx});
  @override
  Widget build(context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<CategoryPageModel>.value(
        value: model,
        child: Consumer<CategoryPageModel>(builder: (ctx, model, __) {
          return Container(
            // height: SizeConfig.heightMultiplier * 80,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: SizeConfig.widthMultiplier * 40,
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Colors.grey[400]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ReactiveForm(
                          formGroup: model.form,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: ReactiveField(
                                //     context: context,
                                //     borderColor: AppColors.borderColor,
                                //     enabledBorderColor: AppColors.borderColor,
                                //     hintColor: AppColors.borderColor,
                                //     textColor: AppColors.greyColor,
                                //     items: ["HTL", "LTH"],
                                //     type: ReactiveFields.DROP_DOWN,
                                //     controllerName: 'rate',
                                //     label: locale.get('Rate') ?? 'Rate',
                                //   ),
                                // ),
                                // ReactiveField(
                                //   context: context,
                                //   borderColor: AppColors.borderColor,
                                //   enabledBorderColor: Colors.black,
                                //   // hintColor: AppColors.borderColor,
                                //   // textColor: AppColors.greyColor,
                                //   items: model.subjects,
                                //   type: ReactiveFields.DROP_DOWN,
                                //   controllerName: 'subjectId',
                                //   onchange: (value) {
                                //     model.subjectId = value;
                                //   },

                                //   label: locale.get('Subject') ?? 'Subject',
                                // ),
                                // SizedBox(
                                //   height: 20,
                                // ),

                                ReactiveField(
                                  context: context,
                                  borderColor: AppColors.borderColor,
                                  enabledBorderColor: Colors.black,
                                  // hintColor: AppColors.borderColor,
                                  // textColor: AppColors.greyColor,
                                  items: model.stages,
                                  type: ReactiveFields.DROP_DOWN,
                                  controllerName: 'stageId',
                                  label: locale.get('Stage') ?? 'Stage',
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                ReactiveField(
                                  context: context,
                                  borderColor: AppColors.borderColor,
                                  enabledBorderColor: Colors.black,
                                  // hintColor: AppColors.borderColor,
                                  // textColor: AppColors.greyColor,
                                  items: model.grades,
                                  type: ReactiveFields.DROP_DOWN,
                                  controllerName: 'gradeId',
                                  label: locale.get('Grade') ?? 'Grade',
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                ReactiveField(
                                  context: context,
                                  borderColor: AppColors.borderColor,
                                  enabledBorderColor: Colors.black,
                                  // hintColor: AppColors.borderColor,
                                  // textColor: AppColors.greyColor,
                                  items: model.cities,
                                  type: ReactiveFields.DROP_DOWN,
                                  controllerName: 'cityId',

                                  label: locale.get('City') ?? 'City',
                                ),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: ReactiveField(
                                //     context: context,
                                //     borderColor: AppColors.borderColor,
                                //     enabledBorderColor: AppColors.borderColor,
                                //     hintColor: AppColors.borderColor,
                                //     textColor: AppColors.greyColor,
                                //     items: ["Male", "Female"],
                                //     type: ReactiveFields.DROP_DOWN,
                                //     controllerName: 'gender',
                                //     label: locale.get('gender') ?? 'gender',
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        buttons(context, model),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget buttons(BuildContext context, CategoryPageModel model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    // borderRadius: ,
                    color: Colors.white,
                    border: Border.all(color: AppColors.primaryColor)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      locale.get("Cancel") ?? "Cancel",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 14, color: AppColors.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: NormalButton(
              text: locale.get('Apply'),
              color: AppColors.primaryColor,
              onPressed: () {
                model.filter(context: context, subjectId: null);
                Navigator.pop(context);
              },
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
