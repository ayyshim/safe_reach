import 'package:equatable/equatable.dart';
import 'package:geocoder/geocoder.dart';
import 'package:meta/meta.dart';

class Loc extends Equatable {
  final String _label;
  final Coordinates _coordinates;

  String get label => _label;
  Coordinates get coordinates => _coordinates;

  Loc({@required String label, @required Coordinates coordinates})
      : _label = label,
        _coordinates = coordinates;

  @override
  List<Object> get props => [_label, _coordinates];
}
