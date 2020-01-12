import 'package:super_enum/super_enum.dart';

part 'contact_state.g.dart';

@superEnum
enum _ContactState {
  @object
  Initial,
  @object
  Loading,
  @object
  Loaded,
  @object
  Error,
  @object
  Adding,
  @object
  AddSuccess,
  @object
  AddError
}
