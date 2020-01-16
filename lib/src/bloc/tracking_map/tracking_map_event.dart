import 'package:safe_reach/src/data/model/saved_route_model.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:super_enum/super_enum.dart';

part 'tracking_map_event.g.dart';

@superEnum
enum _TrackingMapEvent {
  @Data(fields: [DataField('route', SavedRoute), DataField("user", User)])
  LoadMap,
  @object
  StartTracking,
  @object
  StopTracking,
}
