import 'dart:async';
import 'package:flutter/material.dart';
import '../../preference/pref_manager.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (PrefManager.getLoginStatus()) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: const Center(
          child: CircleAvatar(
            backgroundColor: Colors.black12,
            radius: 80,
            child: SizedBox(
              height: 100,
              width: 100,
              // child: Image.asset(
              //   'assets/images/Vector.png',
              //   fit: BoxFit.cover,
              //   color: Colors.white,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
