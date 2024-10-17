import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview/bloc/signup/signup_bloc.dart';
import '../../model/user.dart';
import '../../utils/app_utils.dart';
import '../login/login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    String? userName, userEmail, userPassword;
    final passwordController = TextEditingController();
    final confPasswordController = TextEditingController();
    // print('called');
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupFailure) {
            Fluttertoast.showToast(msg: state.error);
          }
          if (state is SignupSuccess) {
            Fluttertoast.showToast(msg: 'Record save successfully..');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        builder: (BuildContext context, SignupState state) {
          bool isPasswordVisible = true;
          if (state is SignupVisibility) {
            isPasswordVisible = state.isPasswordVisible;
          }
          return Form(
            key: formKey,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFB0BEC5), // light blue-grey
                    Color(0xFFA3C1DA), // light blue-grey
                    Color(0xFFA3C1DA), // light blue-grey
                    Color(0xFFA3C1DA), // light blue-grey
                    Color(0xFFB0BEC5), // light blue-grey
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.black54,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Screen',
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                keyboardType: TextInputType.name,
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  return AppUtil.validateName(value.toString());
                                },
                                onSaved: (name) {
                                  userName = name;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Email address',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  return AppUtil.isValidEmail(value.toString());
                                },
                                onSaved: (email) {
                                  userEmail = email;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  labelStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      // _toggleVisibility();
                                      context
                                          .read<SignupBloc>()
                                          .add(TogglePasswordVisibility());
                                    },
                                    icon: isPasswordVisible
                                        ? const Icon(
                                            Icons.visibility_off_outlined,
                                            color: Colors.white70)
                                        : const Icon(Icons.visibility_outlined,
                                            color: Colors.white70),
                                  ),
                                  prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.white70),
                                ),
                                validator: (value) {
                                  return AppUtil.checkPasswordEmpty(
                                      value.toString());
                                },
                                onSaved: (password) {
                                  userPassword = password;
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.white),
                                obscureText: isPasswordVisible,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: confPasswordController,
                                decoration: const InputDecoration(
                                  labelText: 'Confirm Password',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                  prefixIcon: Icon(Icons.lock_outline_rounded,
                                      color: Colors.white70),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                // obscureText: _isHidden,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text('Already have an Account',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 14)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();

                                        String p = passwordController.text;
                                        String c = confPasswordController.text;

                                        if (p == c) {
                                          UserModel user = UserModel(
                                              name: userName!,
                                              email: userEmail!,
                                              password: userPassword!,
                                              createdAt: DateTime.now()
                                                  .millisecondsSinceEpoch);
                                          context
                                              .read<SignupBloc>()
                                              .add(SignupRequest(user: user));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Passwords do not match!');
                                        }
                                      }
                                    },
                                    child: Text('Signup',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
