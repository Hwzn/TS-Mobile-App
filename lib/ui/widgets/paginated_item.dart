import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginatedItemsWidget extends StatelessWidget {
  final RefreshController refreshController;
  final Function onRefresh;
  final Function onLoad;
  final Axis scrollDirection;
  final double heigth;
  final Widget child;

  const PaginatedItemsWidget({
    Key key,
    this.onLoad,
    this.onRefresh,
    this.scrollDirection = Axis.vertical,
    this.refreshController,
    this.child,
    this.heigth = 280,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: heigth,
        child: buildListOfItems(direction: scrollDirection, child: child));
  }

  SmartRefresher buildListOfItems(
      {@required Axis direction, @required Widget child}) {
    return SmartRefresher(
      controller: refreshController,
      // reverse: true,
      onLoading: onLoad,
      onRefresh: onRefresh,
      scrollDirection: direction,
      enablePullDown: true,
      enablePullUp: true,

      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     AnimatedRoute(
                    //         type: ANIM_TYPE.slide_from_right,
                    //         page: HomePage()));
                  },
                  // heroBuilder: (context) => buildJobCard(model, index),
                  // heroTag: model.jobs[index].id,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: child ??
                        Container(
                          height: 100,
                          color: Colors.red,
                        ),
                  ),
                ),
              )),
    );
  }
}
