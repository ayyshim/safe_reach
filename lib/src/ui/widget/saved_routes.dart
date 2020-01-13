import 'package:flutter/material.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/ui/screen/add_route_screen.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/saved_route_item.dart';
import 'package:safe_reach/src/ui/widget/section.dart';

class SavedRoutes extends StatefulWidget {
  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<SavedRoutes> {
  final List<SavedRoute> _dummyData = [
    SavedRoute(
        id: "1",
        initLabel: "Tula's Institute, Dhoolkot, Dehradun",
        finalLabel: "Selaqui Mainroad, Selaqui, Dehradun",
        initPoint: Point(lat: 30.3418621, lng: 77.884896),
        finalPoint: Point(lat: 30.3515352, lng: 77.8625436))
  ];

  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Saved routes",
      content: Column(
        children: <Widget>[
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 12,
                );
              },
              itemCount: _dummyData.length,
              itemBuilder: (BuildContext context, int index) {
                return SavedRouteItem(
                  route: _dummyData[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              PrimaryButton(
                label: "Add route",
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddRouteScreen();
                  }));
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
