import 'package:super_enum/super_enum.dart';

part 'authentication_event.g.dart';

@superEnum
enum _AuthenticationEvent {
  @object
  AppStarted,
  @object
  LoggedIn,
  @object
  LoggedOut
}
