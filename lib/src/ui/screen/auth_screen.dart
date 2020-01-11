import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_event.dart';
import 'package:safe_reach/src/bloc/login/bloc.dart';
import 'package:safe_reach/src/bloc/login/login_bloc.dart';
import 'package:safe_reach/src/bloc/login/login_event.dart';
import 'package:safe_reach/src/data/repository/auth_repository.dart';
import 'package:safe_reach/src/ui/widget/button.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthRepository _authRepository = AuthRepository();
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(authRepository: _authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColorBrightness: Brightness.dark,
        textTheme: Theme.of(context).textTheme,
      ),
      child: BlocProvider(
        create: (_) => this._loginBloc,
        child: Scaffold(
            body: BlocListener(
          bloc: this._loginBloc,
          listener: (BuildContext context, LoginState state) {
            if (state is Processing) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("Loggin in.."),
                  backgroundColor: Colors.green,
                ));
            }

            if (state is Failure) {
              print(state.message);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.message)));
            }

            if (state is Success) {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            }
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/auth_screen_background.jpg'),
                fit: BoxFit.cover,
                color: Colors.black87,
                colorBlendMode: BlendMode.darken,
              ),
              Container(
                padding: EdgeInsets.all(36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 114,
                    ),
                    Text(
                      "Safe Reach",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Keep track of your safe route\nand provide you support when you need.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(
                      height: 48,
                    ),
                    LoginWithGoogleButton(onPressed: () {
                      _login();
                    })
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  void _login() {
    this._loginBloc.add(LoginEvent.loginPressed());
  }

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }
}
