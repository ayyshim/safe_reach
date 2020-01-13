import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:super_enum/super_enum.dart';

part 'map_location_input_event.g.dart';

@superEnum
enum _MapLocationInputEvent {
  @object
  LoadMap,
  @Data(fields: [DataField("latLng", LatLng), DataField("markerId", MarkerId)])
  UpdateMarker,
  @Data(fields: [DataField("uid", String)])
  Save
}
