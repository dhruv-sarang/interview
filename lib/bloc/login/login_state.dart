part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, error }

sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginSuccess extends LoginState {
  final String uid;
  LoginSuccess(this.uid);
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

class LoginVisibility extends LoginState {
  final bool isPasswordVisible;

  LoginVisibility(this.isPasswordVisible);
}
