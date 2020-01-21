import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:google_map_polyutil/google_map_polyutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  String timeLeftForNextAlert;

  @override
  Stream<TrackingMapState> mapEventToState(
    TrackingMapEvent event,
  ) async* {
    yield* event.when(
        sendAlert: (_) => _mapSendAlert2State(),
        loadMap: (e) => _mapLoadMap2State(e),
        startTracking: (_) => _mapStartTracking2State(),
        stopTracking: (_) => _mapStopTracking2State(),
        updateTicker: (_) => _mapUpdateTicker2State()) as Stream;
  }

  Stream<TrackingMapState> _mapSendAlert2State() async* {
    yield TrackingMapState.alertSent();
    add(TrackingMapEvent.startTracking());
  }

  Stream<TrackingMapState> _mapUpdateTicker2State() async* {
    print("OK");
    yield TrackingMapState.tickerUpdate();
    yield TrackingMapState.tickerUpdated();
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
    this.timeLeftForNextAlert = alertDuration.toString();
    trackingSub?.cancel();
    this.isTracking = true;
    trackingSub =
        _trackingRepository.userCurrentLocation().listen((LatLng current) {
      List<LatLng> path = route.polylines
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      GoogleMapPolyUtil.isLocationOnPath(
              polygon: path, point: current, tolerance: 500.0)
          .then((result) {
        if (result == true) {
          print("On path");
        } else {
          print("Out of path");
          trackingSub.cancel();
          notifyTimerSubscription?.cancel();
          alertTimerSubscription =
              _trackingRepository.alertTicker(alertDuration).listen((x) async {
            LatLng rnLocation = await _trackingRepository.getCurrentLocation();
            bool isBackInPath = await GoogleMapPolyUtil.isLocationOnPath(
                point: rnLocation,
                polygon: path);
            if (isBackInPath) {
              alertTimerSubscription.cancel();
              add(TrackingMapEvent.startTracking());
            } else {
              add(TrackingMapEvent.updateTicker());
              print("T minus $x seconds remain for next alert.");
              if (x < 10) {
                this.timeLeftForNextAlert = '0$x';
              } else {
                this.timeLeftForNextAlert = '$x';
              }
              if (x == 0) {
                alertTimerSubscription.cancel();
                await _trackingRepository.sendAlert(
                    user: currentUser, location: current);
                add(TrackingMapEvent.sendAlert());
              }
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
