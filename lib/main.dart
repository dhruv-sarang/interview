import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview/bloc/category/category_bloc.dart';
import 'package:interview/bloc/question/question_bloc.dart';
import 'package:interview/bloc/quiz/quiz_bloc.dart';
import 'package:interview/preference/pref_manager.dart';
import 'package:interview/screens/splash/splash_screen.dart';
import 'bloc/login/login_bloc.dart';
import 'bloc/signup/signup_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefManager.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SignupBloc()),
        BlocProvider(create: (context) => CategoryBloc()),
        BlocProvider(create: (context) => QuestionBloc()),
        BlocProvider(create: (context) => QuizBloc()),
      ],
      child:  const MaterialApp(
        title: 'E learning',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

