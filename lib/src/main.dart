import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/bloc.dart';
import 'package:safe_reach/src/data/repository/auth_repository.dart';
import 'package:safe_reach/src/ui/screen/auth_screen.dart';
import 'package:safe_reach/src/ui/screen/dashboard_screen.dart';
import 'package:safe_reach/src/ui/screen/splash_screen.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(authRepository: _authRepository);
    _authenticationBloc.add(AuthenticationEvent.appStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => this._authenticationBloc,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.amber,
          accentColor: Colors.amberAccent,
          textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Ubuntu'),
        ),
        debugShowCheckedModeBanner: false,
        home: BlocBuilder(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            return state.when(
                initial: (_) => SplashScreen(),
                authenticated: (_) => DashboardScreen(),
                unauthenticated: (_) => AuthScreen());
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
