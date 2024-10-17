import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../bloc/login/login_bloc.dart';
import '../../preference/pref_manager.dart';
import '../../utils/app_utils.dart';
import '../home/home_screen.dart';
import '../signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    late String eMail, passWord;
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            Fluttertoast.showToast(msg: state.error);
          }
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          bool isPasswordVisible = true;
          if (state is LoginVisibility) {
            isPasswordVisible = state.isPasswordVisible;
          }
          return Container(
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
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Card(
                      color: Colors.black54,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Login Screen',
                                style: TextStyle(
                                    color: Colors.grey.shade300,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32),
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
                                // Change the input text color
                                validator: (value) {
                                  return AppUtil.isValidEmail(value.toString());
                                },
                                onSaved: (email) {
                                  eMail = email!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
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
                                      context
                                          .read<LoginBloc>()
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
                                  passWord = password!;
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(color: Colors.white),
                                // Change the input text color

                                obscureText: isPasswordVisible,
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
                                          builder: (context) => const SignupScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text('Sign Up',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        PrefManager.createAccount(
                                                eMail, passWord)
                                            .then((result) {
                                          context.read<LoginBloc>().add(
                                              LoginRequest(
                                                  email: eMail,
                                                  password: passWord));
                                          // _login(_email, _password);
                                        });
                                      }
                                    },
                                    child: Text('Login',
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
