import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/db_helper.dart';
import '../../model/user.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitialState()) {
    on<SignupRequest>(signup);

    on<TogglePasswordVisibility>((event, emit) async {
      final currentState = state;
      if (currentState is SignupVisibility) {
        emit(SignupVisibility(!currentState.isPasswordVisible));
      } else {
        emit(SignupVisibility(false));
      }
    });
  }

  void signup(SignupRequest event, Emitter<SignupState> emit) async {
    final UserModel? user = event.user;

    DbHelper dbHelper = DbHelper();
    int result = await dbHelper.insertUser(user!);
      if (result != -1) {
        user.userId = result;
        // Fluttertoast.showToast(msg: 'Record save successfully..');
        emit(SignupSuccess('Signup successful!'));
        List<UserModel> userList = [];
        var tempList = await dbHelper.getAllRecords();
        userList = tempList;
      } else {
        emit(SignupFailure('Error'));
      }



  }
}
