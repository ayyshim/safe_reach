import 'package:super_enum/super_enum.dart';

part 'saved_route_state.g.dart';

@superEnum
enum _SavedRouteState {
  @object
  Loading,
  @object
  Loaded,
  @object
  Error,
  @object
  Deleting,
  @object
  DeleteSuccess,
  @object
  DeleteError
}
