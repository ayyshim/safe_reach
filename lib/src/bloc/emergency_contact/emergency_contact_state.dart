import 'package:super_enum/super_enum.dart';

part 'emergency_contact_state.g.dart';

@superEnum
enum _EmergencyContactState {
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
