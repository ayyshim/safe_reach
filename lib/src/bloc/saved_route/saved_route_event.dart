import 'package:super_enum/super_enum.dart';

part 'saved_route_event.g.dart';

@superEnum
enum _SavedRouteEvent {
  @Data(fields: [DataField("uid", String)])
  Fetch,
  @Data(fields: [DataField("savedRoutes", List)])
  Update,
  @Data(fields: [DataField("id", String)])
  Delete
}
