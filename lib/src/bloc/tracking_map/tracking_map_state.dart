import 'package:super_enum/super_enum.dart';

part 'tracking_map_state.g.dart';

@superEnum
enum _TrackingMapState {
  @object
  Initial,
  @object
  LoadingMap,
  @object
  MapLoaded,
  @object
  TrackingStarted,
  @object
  TrackingStopped,
  @object
  AlertSent,
  @object
  TickerUpdate,
  @object
  TickerUpdated
}
