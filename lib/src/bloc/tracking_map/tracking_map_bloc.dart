import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lop_polyutil/lop_polyutil.dart';
import 'package:meta/meta.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:safe_reach/src/data/repository/tracking_repository.dart';
import './bloc.dart';
import 'package:flutter/services.dart' show rootBundle;

class TrackingMapBloc extends Bloc<TrackingMapEvent, TrackingMapState> {
  final TrackingRepository _trackingRepository;

  TrackingMapBloc({@required TrackingRepository trackingRepository})
      : assert(trackingRepository != null),
        _trackingRepository = trackingRepository;

  @override
  TrackingMapState get initialState => TrackingMapState.initial();

  SavedRoute route;
  User currentUser;

  Set<Polyline> polylines = Set();
  String mapStyle;
  Set<Marker> markers = Set();

  bool isTracking = false;
  StreamSubscription trackingSub;

  int alertDuration = 10; // 300 = 5 minutes
  StreamSubscription alertTimerSubscription;

  int notifyDuration = 30; // 600 = 10 minutes
  StreamSubscription notifyTimerSubscription;

  @override
  Stream<TrackingMapState> mapEventToState(
    TrackingMapEvent event,
  ) async* {
    yield* event.when(
      loadMap: (e) => _mapLoadMap2State(e),
      startTracking: (_) => _mapStartTracking2State(),
      stopTracking: (_) => _mapStopTracking2State(),
    ) as Stream;
  }

  Stream<TrackingMapState> _mapLoadMap2State(LoadMap e) async* {
    yield TrackingMapState.loadingMap();
    this.route = e.route;
    this.currentUser = e.user;
    polylines.add(Polyline(
        polylineId: PolylineId(route.id),
        points: route.polylines,
        width: 8,
        color: AppColor.GREEN,
        geodesic: true));
    rootBundle.loadString('assets/map/style1.json').then((mapStyleVal) {
      mapStyle = mapStyleVal;
    });
    markers.add(Marker(
        markerId: MarkerId(route.initLabel),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "From", snippet: route.initLabel),
        position: LatLng(route.initPoint.lat, route.initPoint.lng)));
    markers.add(Marker(
        markerId: MarkerId(route.finalLabel),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: "From", snippet: route.finalLabel),
        position: LatLng(route.finalPoint.lat, route.finalPoint.lng)));

    yield TrackingMapState.mapLoaded();
  }

  Stream<TrackingMapState> _mapStartTracking2State() async* {
    trackingSub?.cancel();
    this.isTracking = true;
    trackingSub =
        _trackingRepository.userCurrentLocation().listen((Loc location) {
      List<LatLng> path = route.polylines
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      LatLng current =
          LatLng(location.coordinates.latitude, location.coordinates.longitude);
      LopPolyutil.isLocationOnPath(path: path, point: current, radius: 500.0)
          .then((result) {
        if (result == true) {
          print("On path");
          trackingSub.cancel();
          alertTimerSubscription?.cancel();
          notifyTimerSubscription =
              _trackingRepository.alertTicker(notifyDuration).listen((x) {
            if (x == 0) {
              notifyTimerSubscription.cancel();
              add(TrackingMapEvent.startTracking());
            }
          });
        } else {
          print("Out of path");
          trackingSub.cancel();
          notifyTimerSubscription?.cancel();
          alertTimerSubscription =
              _trackingRepository.alertTicker(alertDuration).listen((x) {
            print("T minus $x seconds remain for next alert.");
            if (x == 0) {
              alertTimerSubscription.cancel();
              _trackingRepository.sendAlert(
                  user: currentUser, location: location);
              add(TrackingMapEvent.startTracking());
            }
          });
        }
      });
    });
    yield TrackingMapState.trackingStarted();
  }

  Stream<TrackingMapState> _mapStopTracking2State() async* {
    this.isTracking = false;
    trackingSub.cancel();
    alertTimerSubscription?.cancel();
    notifyTimerSubscription?.cancel();
    yield TrackingMapState.trackingStopped();
  }
}
