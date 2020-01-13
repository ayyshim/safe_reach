import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:super_enum/super_enum.dart';

part 'location_input_state.g.dart';

@superEnum
enum _LocationInputState {
  @object
  Initial,
  @object
  RequestPermission,
  @object
  InitialSuggestionLoading,
  @object
  InitialSuggestionLoaded,
  @object
  FinalSuggestionLoading,
  @object
  FinalSuggestionLoaded,
  @object
  UserLocationFetching,
  @Data(fields: [DataField('userLocation', Loc)])
  UserLocationFetched,
  @object
  Saved,
  @object
  Saving,
  @Data(fields: [DataField('message', String)])
  Error,
  @object
  InitLocationSelected,
  @object
  FinalLocationSelected
}
