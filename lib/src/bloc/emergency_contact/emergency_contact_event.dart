import 'package:super_enum/super_enum.dart';

part 'emergency_contact_event.g.dart';

@superEnum
enum _EmergencyContactEvent {
  @Data(fields: [DataField("uid", String)])
  Fetch,
  @Data(fields: [DataField("contacts", List)])
  Update,
  @Data(fields: [DataField("id", String)])
  Delete
}
