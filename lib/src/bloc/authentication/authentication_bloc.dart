import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:safe_reach/src/data/repository/auth_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  User authUser;

  @override
  AuthenticationState get initialState => AuthenticationState.initial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield* event.when(
        appStarted: (_) => _mapAppStarted2State(),
        loggedIn: (_) => _mapLoggedIn2State(),
        loggedOut: (_) => _mapLoggedOut2State()) as Stream;
  }

  Stream<AuthenticationState> _mapAppStarted2State() async* {
    try {
      bool isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        this.authUser = await _authRepository.getUser();
        yield AuthenticationState.authenticated();
      } else {
        yield AuthenticationState.unauthenticated();
      }
    } catch (_) {
      yield AuthenticationState.unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedIn2State() async* {
    this.authUser = await _authRepository.getUser();
    yield AuthenticationState.authenticated();
  }

  Stream<AuthenticationState> _mapLoggedOut2State() async* {
    this.authUser = null;
    yield AuthenticationState.unauthenticated();
    _authRepository.signOut();
  }
}
