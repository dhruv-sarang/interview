part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

final class SignupRequest extends SignupEvent {
  final UserModel? user;

  SignupRequest({required this.user});
}

class TogglePasswordVisibility extends SignupEvent {}
