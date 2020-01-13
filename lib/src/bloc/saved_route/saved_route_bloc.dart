import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/data/repository/saved_route_repository.dart';
import './bloc.dart';

class SavedRouteBloc extends Bloc<SavedRouteEvent, SavedRouteState> {
  final SavedRouteRepository _savedRouteRepository;
  StreamSubscription streamSubscription;
  List<SavedRoute> savedRoute = [];
  SavedRouteBloc({@required SavedRouteRepository savedRouteRepository})
      : assert(savedRouteRepository != null),
        _savedRouteRepository = savedRouteRepository;

  @override
  SavedRouteState get initialState => SavedRouteState.loading();

  @override
  Stream<SavedRouteState> mapEventToState(
    SavedRouteEvent event,
  ) async* {
    yield* event.when(
      fetch: (e) => _mapFetch2State(e),
      update: (e) => _mapUpdate2State(e),
      delete: (Delete e) => _mapDelete2State(e),
    ) as Stream;
  }

  Stream<SavedRouteState> _mapFetch2State(Fetch e) async* {
    yield SavedRouteState.loading();
    try {
      streamSubscription?.cancel();
      streamSubscription = _savedRouteRepository
          .getEmergencyContacts(uid: e.uid)
          .listen((savedRoutes) => add(Update(savedRoutes: savedRoutes)));
    } catch (error) {
      print(error);
      yield SavedRouteState.error();
    }
  }

  Stream<SavedRouteState> _mapUpdate2State(Update e) async* {
    this.savedRoute = e.savedRoutes ?? [];
    yield SavedRouteState.loaded();
  }

  Stream<SavedRouteState> _mapDelete2State(Delete e) async* {
    yield SavedRouteState.deleting();
    try {
      await _savedRouteRepository.deleteEmergencyContact(id: e.id);
      yield SavedRouteState.deleteSuccess();
    } catch (error) {
      print(error);
      yield SavedRouteState.deleteError();
    }
  }
}
