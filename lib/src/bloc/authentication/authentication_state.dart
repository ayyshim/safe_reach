import 'package:equatable/equatable.dart';
import 'package:super_enum/super_enum.dart';

part 'authentication_state.g.dart';

@superEnum
enum _AuthenticationState {
  @object
  Initial,
  @object
  Authenticated,
  @object
  Unauthenticated
}
