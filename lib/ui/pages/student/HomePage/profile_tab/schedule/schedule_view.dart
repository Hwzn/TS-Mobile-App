import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/localization/localization.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import '../../../../../styles/colors.dart';
import '../../../../../styles/size_config.dart';
import 'schedule_view_model.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return ChangeNotifierProvider<SchedulePageModel>(
      create: (context) => SchedulePageModel(context, locale),
      child: Consumer<SchedulePageModel>(
        builder: (context, model, __) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale.get("Schedule"),
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
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        // "Jan 2021",
                        model.monthYear,
                        style: TextStyle(
                            color: AppColors.red,
                            fontSize: SizeConfig.textMultiplier * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_up,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  // ================================== Week Calendar
                  CalendarWeek(
                    controller: model.calendarWeekController,
                    height: 105,
                    showMonth: false,
                    minDate: DateTime.now().add(
                      const Duration(days: -365),
                    ),
                    maxDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                    onDatePressed: (DateTime datetime) {
                      model.getCoursesByDay(datetime.millisecondsSinceEpoch);
                    },
                    onDateLongPressed: (DateTime datetime) {
                      // Do something
                    },
                    onWeekChanged: () {
                      // Do something
                    },
                    decorations: const [],
                    pressedDateBackgroundColor: AppColors.primaryColor,
                    pressedDateStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    dayOfWeekStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendsStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    todayDateStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    dateStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ================================================ Courses List
                  Expanded(
                    child: model.busy
                        ? const Center(child: CircularProgressIndicator())
                        : model.coursesList.isEmpty || model.coursesList == []
                            ? Center(
                                child: Text(
                                  locale.get("No Courses Found!"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: model.coursesList.length,
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: double.infinity,
                                    height: 80,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: AppColors.red,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              // "11:00\nAM",
                                              DateFormat("HH:mm\na").format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          model
                                                              .coursesList[
                                                                  index]
                                                              .startDate)),
                                              overflow: TextOverflow.ellipsis,

                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                model.coursesList[index].name
                                                    .localized(context),
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                              Text(
                                                model.coursesList[index]
                                                        .description
                                                        ?.localized(context) ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.grey),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  UI.showSnackBarMessage(
                                                      context: context,
                                                      message: locale.get(
                                                          'Agora Link Sent'));
                                                },
                                                child: Text(
                                                  locale.get(model
                                                              .coursesList[
                                                                  index]
                                                              .type !=
                                                          'home'
                                                      ? "Send Agora Link"
                                                      : 'Send Notification'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: AppColors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
