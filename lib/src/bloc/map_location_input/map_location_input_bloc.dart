import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/data/repository/location_repository.dart';
import './bloc.dart';

class MapLocationInputBloc
    extends Bloc<MapLocationInputEvent, MapLocationInputState> {
  final LocationRepository _locationRepository;

  MapLocationInputBloc({@required LocationRepository locationRepository})
      : assert(locationRepository != null),
        _locationRepository = locationRepository;

  LatLng currentLatLng = LatLng(0, 0);
  Set<Marker> markers = Set();

  Loc currentLocation;
  Loc initLocation;
  Loc finalLocation;

  @override
  MapLocationInputState get initialState => MapLocationInputState.initial();

  @override
  Stream<MapLocationInputState> mapEventToState(
    MapLocationInputEvent event,
  ) async* {
    yield* event.when(
        loadMap: (_) => _mapLoadMap2State(),
        updateMarker: (e) => _mapUpdateMarker2State(e),
        save: (e) => _mapSave2State(e)) as Stream;
  }

  Stream<MapLocationInputState> _mapSave2State(Save e) async* {
    yield MapLocationInputState.saving();
    try {
      await _locationRepository.saveRouteToDB(
          start: initLocation, end: finalLocation, uid: e.uid);
      yield MapLocationInputState.saved();
    } catch (error) {
      print(error);
    }
  }

  Stream<MapLocationInputState> _mapUpdateMarker2State(UpdateMarker e) async* {
    final address = await _locationRepository.getMarkerLocation(e.latLng);
    if (e.markerId == MarkerId('1')) {
      initLocation = address;
    } else {
      finalLocation = address;
    }

    yield MapLocationInputState.markerUpdated();
  }

  Stream<MapLocationInputState> _mapLoadMap2State() async* {
    yield MapLocationInputState.mapLoading();

    PermissionStatus permissionStatus =
        await _locationRepository.getLocationPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final currentAddress = await _locationRepository.getCurrentLocation();
        this.currentLocation = currentAddress;
        LatLng currentLatLng = LatLng(currentAddress.coordinates.latitude,
            currentAddress.coordinates.longitude);
        markers.removeAll(markers);
        this.currentLatLng = currentLatLng;
        initLocation = currentLocation;
        finalLocation = currentLocation;
        _addTwoMakers();
        yield MapLocationInputState.mapLoaded(center: currentLatLng);
      } catch (error) {
        print(error.toString());
        yield MapLocationInputState.mapError(
            message:
                "Something went wrong.\nPlease ensure your device location is enabled.");
      }
    } else {
      yield MapLocationInputState.mapError(
          message: "Can't load map with out your location access permission.");
    }
  }

  void _addTwoMakers() {
    Marker marker1 = Marker(
        infoWindow: InfoWindow(title: "Origin"),
        markerId: MarkerId('1'),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(100),
        position: this.currentLatLng,
        onDragEnd: (latLng) {
          add(MapLocationInputEvent.updateMarker(
              latLng: latLng, markerId: MarkerId('1')));
        },
        onTap: () {
          print('Init Point Marker ${initLocation.label}');
        });
    markers.add(marker1);
    Marker marker2 = Marker(
        infoWindow: InfoWindow(title: "Destination"),
        markerId: MarkerId('2'),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(50),
        position: LatLng(
            currentLatLng.latitude - 0.0005, currentLatLng.longitude - 0.0005),
        onDragEnd: (latLng) {
          add(MapLocationInputEvent.updateMarker(
              latLng: latLng, markerId: MarkerId('2')));
        },
        onTap: () {
          print('Final Point Marker ${finalLocation.label}');
        });
    markers.add(marker2);
  }
}
