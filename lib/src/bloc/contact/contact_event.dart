import 'package:super_enum/super_enum.dart';

part 'contact_event.g.dart';

@superEnum
enum _ContactEvent {
  @object
  RequestPermission,
  @object
  GrantedPermission,
  @object
  DeniedPermission,
  @Data(fields: [DataField("data", Map)])
  ContactAdd
}
