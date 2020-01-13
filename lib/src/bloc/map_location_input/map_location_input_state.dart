import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_enum/super_enum.dart';

part 'map_location_input_state.g.dart';

@superEnum
enum _MapLocationInputState {
  @object
  Initial,
  @object
  MapLoading,
  @Data(fields: [DataField('message', String)])
  MapError,
  @Data(fields: [DataField('center', LatLng)])
  MapLoaded,
  @object
  MarkerUpdated,
  @object
  Saving,
  @object
  Saved
}
