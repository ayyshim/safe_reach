import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/bloc.dart';
import 'package:safe_reach/src/bloc/emergency_contact/emergency_contact_bloc.dart';
import 'package:safe_reach/src/bloc/emergency_contact/emergency_contact_event.dart';
import 'package:safe_reach/src/bloc/saved_route/saved_route_bloc.dart';
import 'package:safe_reach/src/bloc/saved_route/saved_route_event.dart';
import 'package:safe_reach/src/data/repository/emergency_contact_repository.dart';
import 'package:safe_reach/src/data/repository/saved_route_repository.dart';
import 'package:safe_reach/src/ui/widget/appBar.dart';
import 'package:safe_reach/src/ui/widget/emergency_contacts.dart';
import 'package:safe_reach/src/ui/widget/profile_card.dart';
import 'package:safe_reach/src/ui/widget/saved_routes.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmergencyContactRepository _emergencyContactRepository =
      EmergencyContactRepository();
  final SavedRouteRepository _savedRouteRepository = SavedRouteRepository();
  EmergencyContactBloc _emergencyContactBloc;
  SavedRouteBloc _savedRouteBloc;

  @override
  void initState() {
    super.initState();
    _emergencyContactBloc = EmergencyContactBloc(
        emergencyContactRepository: _emergencyContactRepository);
    _savedRouteBloc =
        SavedRouteBloc(savedRouteRepository: _savedRouteRepository);
    _emergencyContactBloc.add(EmergencyContactEvent.fetch(
        uid: BlocProvider.of<AuthenticationBloc>(context).authUser.uid));
    _savedRouteBloc.add(SavedRouteEvent.fetch(
        uid: BlocProvider.of<AuthenticationBloc>(context).authUser.uid));
  }

  static const List<String> _popMenuItems = <String>["Logout"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "Logout") {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEvent.loggedOut());
            }
          },
          itemBuilder: (BuildContext context) {
            return _popMenuItems.map((item) {
              return PopupMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList();
          },
        )
      ], title: "Safe Reach"),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              ProfileCard(),
              SizedBox(
                height: 24,
              ),
              BlocProvider(
                  create: (_) => _emergencyContactBloc,
                  child: EmergencyContacts()),
              BlocProvider(
                  create: (_) => _savedRouteBloc, child: SavedRoutes()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emergencyContactBloc.close();
    _savedRouteBloc.close();
    super.dispose();
  }
}
