import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_reach/src/bloc/tracking_map/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:safe_reach/src/data/repository/tracking_repository.dart';
import 'package:safe_reach/src/ui/widget/appBar.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/loading_screen.dart';

class TrackingScreen extends StatefulWidget {
  final SavedRoute _route;
  final User _user;

  TrackingScreen({Key key, @required User user, @required SavedRoute route})
      : _route = route,
        _user = user,
        super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final TrackingRepository _trackingRepository = TrackingRepository();
  TrackingMapBloc _trackingMapBloc;

  @override
  void initState() {
    super.initState();
    _trackingMapBloc = TrackingMapBloc(trackingRepository: _trackingRepository);
    _trackingMapBloc.add(
        TrackingMapEvent.loadMap(route: widget._route, user: widget._user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _trackingMapBloc,
      child: Scaffold(
          appBar:
              customAppBar(title: "Navigator", backgroundColor: Colors.white),
          body: BlocListener(
            bloc: _trackingMapBloc,
            listener: (BuildContext context, TrackingMapState state) {},
            child: BlocBuilder(
              bloc: _trackingMapBloc,
              builder: (BuildContext context, TrackingMapState state) {
                if (state is LoadingMap) {
                  return LoadingScreen();
                }

                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      markers: _trackingMapBloc.markers,
                      onMapCreated: (GoogleMapController controller) {
                        controller.setMapStyle(_trackingMapBloc.mapStyle);
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget._route.initPoint.lat,
                              widget._route.initPoint.lng),
                          zoom: 12),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      polylines: _trackingMapBloc.polylines,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: BlueButton(
                        changeColor: _trackingMapBloc.isTracking
                            ? AppColor.RED
                            : AppColor.BLUE,
                        label: _trackingMapBloc.isTracking ? "Stop" : "Start",
                        onPressed: () {
                          print(_trackingMapBloc.isTracking
                              ? "Stopped"
                              : "Started");
                          _trackingMapBloc.isTracking
                              ? _trackingMapBloc
                                  .add(TrackingMapEvent.stopTracking())
                              : _trackingMapBloc
                                  .add(TrackingMapEvent.startTracking());
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          )),
    );
  }

  @override
  void dispose() {
    _trackingMapBloc.close();
    super.dispose();
  }
}
