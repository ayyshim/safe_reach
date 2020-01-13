import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/card.dart';

class SavedRouteItem extends StatelessWidget {
  final SavedRoute _route;

  const SavedRouteItem({Key key, @required SavedRoute route})
      : _route = route,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: AppColor.GREEN,
            child: Icon(
              MdiIcons.mapMarkerDistance,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _route.initLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "to",
                  style: TextStyle(fontSize: 8, color: AppColor.GREY),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  _route.finalLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Row(
            children: <Widget>[
              RoundedIconButton(
                iconColor: Colors.white,
                icon: MdiIcons.mapMarkerPath,
                onPressed: () {
                  print("Track");
                },
                backgroundColor: AppColor.BLUE,
              ),
              SizedBox(
                width: 8,
              ),
              RoundedIconButton(
                iconColor: Colors.white,
                icon: MdiIcons.trashCan,
                onPressed: () {
                  print("Delete");
                },
                backgroundColor: AppColor.RED,
              )
            ],
          )
        ],
      ),
    );
  }
}
