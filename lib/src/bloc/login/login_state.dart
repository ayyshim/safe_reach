import 'package:super_enum/super_enum.dart';

part 'login_state.g.dart';

@superEnum
enum _LoginState {
  @object
  Initial,
  @object
  Processing,
  @object
  Success,
  @Data(fields: [DataField('message', String)])
  Failure
}
