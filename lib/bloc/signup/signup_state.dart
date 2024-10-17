part of 'signup_bloc.dart';

sealed class SignupState {}

final class SignupInitialState extends SignupState {}

final class SignupSuccess extends SignupState {
  final String uid;
  SignupSuccess(this.uid);

}

final class SignupFailure extends SignupState {
  final String error;
  SignupFailure(this.error);
}

class SignupVisibility extends SignupState {
  final bool isPasswordVisible;
  SignupVisibility(this.isPasswordVisible);
}
