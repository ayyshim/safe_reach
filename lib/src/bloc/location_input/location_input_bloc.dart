import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/data/repository/location_repository.dart';
import './bloc.dart';

class LocationInputBloc extends Bloc<LocationInputEvent, LocationInputState> {
  final LocationRepository _locationRepository;

  List<Loc> initialPointSuggestions = [];
  List<Loc> finalPointSuggestions = [];

  Loc initLocation;
  Loc finalLocation;

  LocationInputBloc({@required LocationRepository locationRepository})
      : assert(locationRepository != null),
        _locationRepository = locationRepository;

  @override
  LocationInputState get initialState => LocationInputState.initial();

  @override
  Stream<LocationInputState> mapEventToState(
    LocationInputEvent event,
  ) async* {
    yield* event.when(
        initLocationSelect: (e) => _mapInitLocationSelect2State(e),
        finalLocationSelect: (e) => _mapFinalLocationSelect2State(e),
        initialQueryChanged: (e) => _mapInitialQueryChanged2State(e),
        finalQueryChanged: (e) => _mapFinalQueryChanged2State(e),
        useCurrentLocationPressed: (_) => _mapUseCurrentLocationPressed2State(),
        savePressed: (e) => _mapSavedPressed2State(e)) as Stream;
  }

  Stream<LocationInputState> _mapInitLocationSelect2State(
      InitLocationSelect e) async* {
    this.initLocation = e.location;
    this.initialPointSuggestions = [];
    yield LocationInputState.initLocationSelected();
  }

  Stream<LocationInputState> _mapFinalLocationSelect2State(
      FinalLocationSelect e) async* {
    this.finalLocation = e.location;
    this.finalPointSuggestions = [];
    yield LocationInputState.finalLocationSelected();
  }

  Stream<LocationInputState> _mapInitialQueryChanged2State(
      InitialQueryChanged e) async* {
    this.finalPointSuggestions = [];
    yield LocationInputState.initialSuggestionLoading();
    try {
      this.initialPointSuggestions = await _locationRepository
          .getLocationSuggestion(keyword: e.initialQuery);
      yield LocationInputState.initialSuggestionLoaded();
    } on PlatformException catch (_) {
      this.initialPointSuggestions = [];
      yield LocationInputState.initialSuggestionLoaded();
    }
  }

  Stream<LocationInputState> _mapFinalQueryChanged2State(
      FinalQueryChanged e) async* {
    this.initialPointSuggestions = [];
    yield LocationInputState.finalSuggestionLoading();
    try {
      yield LocationInputState.finalSuggestionLoading();
      this.finalPointSuggestions = await _locationRepository
          .getLocationSuggestion(keyword: e.finalQuery);
      yield LocationInputState.finalSuggestionLoaded();
    } catch (error) {
      this.finalPointSuggestions = [];
      yield LocationInputState.finalSuggestionLoaded();
    }
  }

  Stream<LocationInputState> _mapUseCurrentLocationPressed2State() async* {
    yield LocationInputState.requestPermission();
    try {
      final permissionStatus =
          await _locationRepository.getLocationPermission();
      if (permissionStatus == PermissionStatus.granted) {
        yield LocationInputState.userLocationFetching();
        final location = await _locationRepository.getCurrentLocation();
        yield LocationInputState.userLocationFetched(userLocation: location);
      } else {
        yield LocationInputState.error(
            message:
                "You did not give your location permission. Please allow location permission.");
      }
    } catch (error) {
      print("UCLP_ $error");
      yield LocationInputState.error(message: "UCLP Error");
    }
  }

  Stream<LocationInputState> _mapSavedPressed2State(SavePressed e) async* {
    yield LocationInputState.saving();
    try {
      await _locationRepository.saveRouteToDB(
          start: this.initLocation, end: this.finalLocation, uid: e.uid);
      yield LocationInputState.saved();
    } catch (error) {
      print(error);
      yield LocationInputState.error(message: "Error while saving.");
    }
  }
}
