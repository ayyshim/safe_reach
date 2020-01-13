import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_reach/src/bloc/authentication/authentication_bloc.dart';
import 'package:safe_reach/src/bloc/map_location_input/bloc.dart';
import 'package:safe_reach/src/bloc/map_location_input/map_location_input_bloc.dart';
import 'package:safe_reach/src/bloc/map_location_input/map_location_input_event.dart';
import 'package:safe_reach/src/data/repository/location_repository.dart';
import 'package:safe_reach/src/ui/widget/appBar.dart';
import 'package:safe_reach/src/ui/widget/button.dart';
import 'package:safe_reach/src/ui/widget/loading_screen.dart';
import 'package:safe_reach/src/ui/widget/progress_dialog.dart';

class AddRouteMapScreen extends StatefulWidget {
  @override
  _AddRouteMapScreenState createState() => _AddRouteMapScreenState();
}

class _AddRouteMapScreenState extends State<AddRouteMapScreen> {
  final LocationRepository _locationRepository = LocationRepository();
  MapLocationInputBloc _mapLocationInputBloc;

  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;

  @override
  void initState() {
    super.initState();
    _mapLocationInputBloc =
        MapLocationInputBloc(locationRepository: _locationRepository);
    _mapLocationInputBloc.add(MapLocationInputEvent.loadMap());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mapLocationInputBloc,
      child: Scaffold(
        appBar: customAppBar(
          title: "Add routes (Map)",
          backgroundColor: Colors.white,
        ),
        body: BlocListener(
          listener: (BuildContext context, MapLocationInputState state) {
            if (state is Saving) {
              showDialog(
                  context: context,
                  builder: (_) => ProgressDialog(
                        title: "Saving...",
                      ));
            }

            if (state is Saved) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          bloc: _mapLocationInputBloc,
          child: BlocBuilder(
              bloc: _mapLocationInputBloc,
              builder: (BuildContext context, MapLocationInputState state) {
                if (state is MapLoading) {
                  return LoadingScreen();
                }

                if (state is MapError) {
                  return Container(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                }

                return Stack(
                  children: <Widget>[
                    GoogleMap(
                      onMapCreated: _onMapCreate,
                      markers: _mapLocationInputBloc.markers,
                      compassEnabled: true,
                      buildingsEnabled: true,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: _mapLocationInputBloc.currentLatLng,
                          zoom: 15.0),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: BlueButton(
                        label: "Save",
                        onPressed: () {
                          _mapLocationInputBloc.add(MapLocationInputEvent.save(
                              uid: BlocProvider.of<AuthenticationBloc>(context)
                                  .authUser
                                  .uid));
                        },
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  void _onMapCreate(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  void dispose() {
    _mapLocationInputBloc.close();
    super.dispose();
  }
}
