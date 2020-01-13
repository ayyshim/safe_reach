import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_bloc.dart';
import 'package:safe_reach/src/bloc/location_input/bloc.dart';
import 'package:safe_reach/src/bloc/location_input/location_input_bloc.dart';
import 'package:safe_reach/src/bloc/location_input/location_input_event.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/repository/location_repository.dart';
import 'package:safe_reach/src/ui/screen/add_route_map_screen.dart';
import 'package:safe_reach/src/ui/widget/appBar.dart';
import 'package:safe_reach/src/ui/widget/location_input.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/progress_dialog.dart';

class AddRouteScreen extends StatefulWidget {
  @override
  _AddRouteScreenState createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final LocationRepository _locationRepository = LocationRepository();
  LocationInputBloc _locationInputBloc;

  final TextEditingController _initalPointController = TextEditingController();
  final TextEditingController _finalPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationInputBloc =
        LocationInputBloc(locationRepository: _locationRepository);
    _initalPointController.addListener(_initPointListener);
    _finalPointController.addListener(_finalPointListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Add route"),
      body: BlocProvider(
        create: (_) => _locationInputBloc,
        child: BlocListener(
          listener: (BuildContext context, LocationInputState state) {
            if (state is Error) {
              Navigator.pop(context);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColor.RED,
                ));
            }

            if (state is Saving) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => ProgressDialog(
                        title: "Saving...",
                      ));
            }

            if (state is Saved) {
              Navigator.pop(context);
              Navigator.pop(context);
            }

            if (state is UserLocationFetched) {
              _initalPointController.value =
                  TextEditingValue(text: state.userLocation.label);
              _locationInputBloc.add(LocationInputEvent.initLocationSelect(
                  location: state.userLocation));
            }

            if (state is UserLocationFetching) {
              print("Fetching");
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => ProgressDialog(
                        title: "Getting user location...",
                      ));
            }

            if (state is InitLocationSelected) {
              _initalPointController.value =
                  TextEditingValue(text: _locationInputBloc.initLocation.label);
            }

            if (state is FinalLocationSelected) {
              _finalPointController.value = TextEditingValue(
                  text: _locationInputBloc.finalLocation.label);
            }

            if (state is UserLocationFetched) {
              Navigator.pop(context);
            }
          },
          bloc: _locationInputBloc,
          child: BlocBuilder(
            bloc: _locationInputBloc,
            builder: (BuildContext context, LocationInputState state) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    children: <Widget>[
                      LocationInput(
                        suggestions: _locationInputBloc.initialPointSuggestions,
                        label: "Starting point",
                        textEditingController: this._initalPointController,
                        useCurrentLocation: true,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      LocationInput(
                        suggestions: _locationInputBloc.finalPointSuggestions,
                        label: "Ending point",
                        textEditingController: this._finalPointController,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          BlueButton(
                            label: "Use map",
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return AddRouteMapScreen();
                              }));
                            },
                          ),
                          PrimaryButton(
                            label: "Save",
                            onPressed: () {
                              _locationInputBloc.add(
                                  LocationInputEvent.savePressed(
                                      uid: BlocProvider.of<AuthenticationBloc>(
                                              context)
                                          .authUser
                                          .uid));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _initPointListener() {
    final query = _initalPointController.text;
    _locationInputBloc
        .add(LocationInputEvent.initialQueryChanged(initialQuery: query));
  }

  void _finalPointListener() {
    final query = _finalPointController.text;
    _locationInputBloc
        .add(LocationInputEvent.finalQueryChanged(finalQuery: query));
  }

  @override
  void dispose() {
    _locationInputBloc.close();
    super.dispose();
  }
}
