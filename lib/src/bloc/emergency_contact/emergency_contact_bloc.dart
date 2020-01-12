import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_reach/src/data/model/emergency_contact_model.dart';
import 'package:safe_reach/src/data/repository/emergency_contact_repository.dart';
import './bloc.dart';

class EmergencyContactBloc
    extends Bloc<EmergencyContactEvent, EmergencyContactState> {
  final EmergencyContactRepository _emergencyContactRepository;
  StreamSubscription streamSubscription;
  List<EmergencyContact> emergencyContacts = [];
  EmergencyContactBloc(
      {@required EmergencyContactRepository emergencyContactRepository})
      : assert(emergencyContactRepository != null),
        _emergencyContactRepository = emergencyContactRepository;

  @override
  EmergencyContactState get initialState => EmergencyContactState.loading();

  @override
  Stream<EmergencyContactState> mapEventToState(
    EmergencyContactEvent event,
  ) async* {
    yield* event.when(
      fetch: (e) => _mapFetch2State(e),
      update: (e) => _mapUpdate2State(e),
      delete: (Delete e) => _mapDelete2State(e),
    ) as Stream;
  }

  Stream<EmergencyContactState> _mapFetch2State(Fetch e) async* {
    yield EmergencyContactState.loading();
    try {
      streamSubscription?.cancel();
      streamSubscription = _emergencyContactRepository
          .getEmergencyContacts(uid: e.uid)
          .listen((contacts) => add(Update(contacts: contacts)));
    } catch (error) {
      print(error);
      yield EmergencyContactState.error();
    }
  }

  Stream<EmergencyContactState> _mapUpdate2State(Update e) async* {
    this.emergencyContacts = e.contacts ?? [];
    yield EmergencyContactState.loaded();
  }

  Stream<EmergencyContactState> _mapDelete2State(Delete e) async* {
    yield EmergencyContactState.deleting();
    try {
      await _emergencyContactRepository.deleteEmergencyContact(id: e.id);
      yield EmergencyContactState.deleteSuccess();
    } catch (error) {
      print(error);
      yield EmergencyContactState.deleteError();
    }
  }
}
