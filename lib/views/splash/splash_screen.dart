import 'dart:async';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //add image
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background.jpg',
              ),
            ),
            Image.asset('assets/Logo3.jpg'),
            const SizedBox(height: 140),
            Container(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'assets/background2.jpg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}