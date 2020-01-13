import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:safe_reach/src/bloc/location_input/location_input_bloc.dart';
import 'package:safe_reach/src/bloc/location_input/location_input_event.dart';
import 'package:safe_reach/src/constants/colors.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/ui/widget/location_suggestion_item.dart';

class LocationInput extends StatefulWidget {
  final String _label;
  final TextEditingController _textEditingController;
  final bool _useCurrentLocation;
  final List<Loc> _suggestions;

  const LocationInput(
      {Key key,
      @required String label,
      @required TextEditingController textEditingController,
      @required List<Loc> suggestions,
      bool useCurrentLocation})
      : _label = label,
        _textEditingController = textEditingController,
        _useCurrentLocation = useCurrentLocation ?? false,
        _suggestions = suggestions,
        super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: widget._textEditingController,
          decoration: InputDecoration(
              suffixIcon: widget._useCurrentLocation
                  ? IconButton(
                      icon: Icon(MdiIcons.crosshairsGps),
                      onPressed: () {
                        BlocProvider.of<LocationInputBloc>(context).add(
                            LocationInputEvent.useCurrentLocationPressed());
                      },
                      color: AppColor.BLUE,
                      tooltip: "Use current location",
                    )
                  : null,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: AppColor.PRIMARY)),
              labelText: widget._label,
              labelStyle: TextStyle(color: AppColor.GREY)),
        ),
        widget._suggestions.length != 0
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int i) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                      shrinkWrap: true,
                      itemCount: widget._suggestions.length,
                      itemBuilder: (BuildContext context, int i) {
                        return LocationSuggestionItem(
                          isFinal: !widget._useCurrentLocation,
                          location: widget._suggestions[i],
                        );
                      },
                    ),
                  ),
                ],
              )
            : SizedBox()
      ],
    );
  }
}
