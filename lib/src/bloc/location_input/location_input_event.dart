import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:super_enum/super_enum.dart';

part 'location_input_event.g.dart';

@superEnum
enum _LocationInputEvent {
  @Data(fields: [DataField("initialQuery", String)])
  InitialQueryChanged,
  @Data(fields: [DataField("finalQuery", String)])
  FinalQueryChanged,
  @object
  UseCurrentLocationPressed,
  @Data(fields: [DataField("uid", String)])
  SavePressed,
  @Data(fields: [DataField('location', Loc)])
  InitLocationSelect,
  @Data(fields: [DataField('location', Loc)])
  FinalLocationSelect
}
