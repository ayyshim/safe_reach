import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/location_input/bloc.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/ui/widget/card.dart';

class LocationSuggestionItem extends StatelessWidget {
  final Loc _location;
  final bool _isFinal;

  const LocationSuggestionItem({Key key, @required Loc location, bool isFinal})
      : _location = location,
        _isFinal = isFinal,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: InkWell(
        onTap: () {
          if (!_isFinal) {
            BlocProvider.of<LocationInputBloc>(context).add(
                LocationInputEvent.initLocationSelect(location: _location));
          } else {
            BlocProvider.of<LocationInputBloc>(context).add(
                LocationInputEvent.finalLocationSelect(location: _location));
          }
        },
        child: Text(
          _location.label,
          style: TextStyle(color: AppColor.BLUE, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
