import 'package:flutter/material.dart';


import 'views/login/login_screen.dart';
// import 'views/book_slots/slot_arrangement_screen.dart';

void main() {
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}