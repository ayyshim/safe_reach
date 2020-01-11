import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:safe_reach/src/data/repository/auth_repository.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({@required AuthRepository authRepository})
      : assert(authRepository != null),
        _authRepository = authRepository;

  @override
  LoginState get initialState => LoginState.initial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    yield* event.when(loginPressed: (_) => _mapLogingPressed2State()) as Stream;
  }

  Stream<LoginState> _mapLogingPressed2State() async* {
    yield LoginState.processing();
    try {
      await _authRepository.loginWithGoole();
      yield LoginState.success();
    } catch (error) {
      if (error is NoSuchMethodError) {
        yield LoginState.failure(message: "Login cancled.");
      } else {
        yield LoginState.failure(message: "Something went wrong.");
      }
    }
  }
}
