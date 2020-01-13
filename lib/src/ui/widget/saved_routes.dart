import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/saved_route/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/ui/screen/add_route_screen.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/loading_screen.dart';
import 'package:safe_reach/src/ui/widget/progress_dialog.dart';
import 'package:safe_reach/src/ui/widget/saved_route_item.dart';
import 'package:safe_reach/src/ui/widget/section.dart';

class SavedRoutes extends StatefulWidget {
  @override
  _SavedRoutesState createState() => _SavedRoutesState();
}

class _SavedRoutesState extends State<SavedRoutes> {
  @override
  Widget build(BuildContext context) {
    return Section(
      title: "Saved routes",
      content: BlocListener(
        bloc: BlocProvider.of<SavedRouteBloc>(context),
        listener: (BuildContext context, SavedRouteState state) {
          if (state is Error) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Error..."),
                backgroundColor: AppColor.RED,
                duration: Duration(seconds: 2),
              ));
          }

          if (state is Deleting) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => ProgressDialog(
                      title: "Deleting...",
                    ));
          }

          if (state is DeleteSuccess) {
            Navigator.pop(context);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Deleted"),
                backgroundColor: AppColor.GREEN,
                duration: Duration(seconds: 2),
              ));
          }

          if (state is DeleteError) {
            Navigator.pop(context);
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Something went wrong!"),
                backgroundColor: AppColor.RED,
                duration: Duration(seconds: 2),
              ));
          }
        },
        child: Column(
          children: <Widget>[
            Container(
              child: BlocBuilder(
                bloc: BlocProvider.of<SavedRouteBloc>(context),
                builder: (BuildContext context, SavedRouteState state) {
                  if (state is Loading) {
                    return LoadingScreen();
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: BlocProvider.of<SavedRouteBloc>(context)
                        .savedRoute
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      final route = BlocProvider.of<SavedRouteBloc>(context)
                          .savedRoute[index];
                      return SavedRouteItem(
                        route: route,
                      );
                    },
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
      ),
    );
  }
}
