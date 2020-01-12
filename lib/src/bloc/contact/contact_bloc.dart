import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_reach/src/data/repository/contact_repository.dart';
import './bloc.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;

  ContactBloc({@required ContactRepository contactRepository})
      : assert(contactRepository != null),
        _contactRepository = contactRepository;

  List<Contact> phoneContacts;

  @override
  ContactState get initialState => ContactState.initial();

  @override
  Stream<ContactState> mapEventToState(
    ContactEvent event,
  ) async* {
    yield ContactState.loading();
    yield* event.when(
        requestPermission: (_) => _mapRequestPermission2State(),
        grantedPermission: (_) => _mapGrantedPermission2State(),
        deniedPermission: (_) => _mapDeniedPermission2State(),
        contactAdd: (e) => _mapContactAdd2State(e)) as Stream;
  }

  Stream<ContactState> _mapRequestPermission2State() async* {
    final permissionStatus = await _contactRepository.getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        this.phoneContacts = await _contactRepository.getContacts();
        yield ContactState.loaded();
      } catch (error) {
        print(error);
        yield ContactState.error();
      }
    } else {
      print("Permission denied.");
      yield ContactState.error();
    }
  }

  Stream<ContactState> _mapGrantedPermission2State() async* {
    try {
      this.phoneContacts = await _contactRepository.getContacts();
      yield ContactState.loaded();
    } catch (error) {
      print(error);
      yield ContactState.error();
    }
  }

  Stream<ContactState> _mapDeniedPermission2State() async* {
    print("Permission denied.");
    yield ContactState.error();
  }

  Stream<ContactState> _mapContactAdd2State(ContactAdd e) async* {
    yield ContactState.adding();
    try {
      await _contactRepository.addContact(data: e.data);
      yield ContactState.addSuccess();
    } catch (error) {
      print(error);
      yield ContactState.addError();
    }
  }
}
