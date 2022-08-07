import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ts_academy/core/providers/provider_setup.dart';
import 'package:ts_academy/core/services/api/api.dart';
import 'package:ts_academy/core/services/auth/authentication_service.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/chat_page.dart';
import 'package:ts_academy/ui/pages/student/HomePage/profile_tab/chat/chat_service.dart';
import 'package:ts_academy/ui/pages/teacher/add_courses/add_course/add_course_data.dart';
import 'package:ts_academy/ui/pages/teacher/teacher_home/stu_model.dart';
import 'package:ts_academy/ui/routes/ui.dart';
import 'package:ts_academy/ui/styles/colors.dart';
import 'package:ts_academy/ui/styles/size_config.dart';

class StudentCard extends StatelessWidget {
  StuModel student;

  StudentCard({Key key, this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          ChatService.createChat(
              name2: locator<AuthenticationService>().user.name,
              userId2: locator<AuthenticationService>().user.sId,
              pic2: "auth.user.userInfo.image",
              userId1: student.user.sId,
              name1: student.user.name,
              pic1: "seller.image");
          pushNewScreen(context,
              screen: ChatPage(
                userId: student.user.sId,
                userName: student.user.name,
                userAvatar: "seller.image",
              ),
              pageTransitionAnimation: PageTransitionAnimation.slideUp,
              withNavBar: false);
        },
        child: Container(
          height: SizeConfig.heightMultiplier * 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 40,
                height: SizeConfig.heightMultiplier * 20,
                color: AppColors.primaryColorDark,
                child: CachedNetworkImage(
                  imageUrl: BaseFileUrl + (student.user.email ?? ''),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                student.user.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,

                    itemCount: 5,
                    itemSize: 20,
                    // itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_rounded,
                      color: AppColors.rateColorDark,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "4",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Text(
                    "(12522)",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 10, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
