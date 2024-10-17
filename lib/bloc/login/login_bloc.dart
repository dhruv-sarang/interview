import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/db_helper.dart';
import '../../model/user.dart';
import '../../preference/pref_manager.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginRequest>(login);

    on<TogglePasswordVisibility>((event, emit) async {
      final currentState = state;
      if (currentState is LoginVisibility) {
        emit(LoginVisibility(!currentState.isPasswordVisible));
      } else {
        emit(LoginVisibility(false));
      }
    });
  }

  void login(LoginRequest event, Emitter<LoginState> emit) async {
    final String emailController = event.email;
    final String passwordController = event.password;

    if (passwordController.length < 6) {
      emit(LoginFailure('Password must be at least 6 characters'));
      return;
    }

    DbHelper dbHelper = DbHelper();
    UserModel? user =
        await dbHelper.getUserByEmail(emailController, passwordController);

    if (user != null) {
      if (user.password == passwordController) {
        await PrefManager.login(emailController);
        // print('Login Status : ${PrefManager.getLoginStatus().toString()}');
        emit(LoginSuccess('Login successful!'));
      } else {
        emit(LoginFailure('Incorrect password'));
      }
    } else {
      emit(LoginFailure('Email Or Password incorrect'));
    }
  }
}
