// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../book_slots/slot_arrangement_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.login}';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": _emailController.text,
        "password": _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      // Successfully posted data
      developer.log('User logged successfully');
      saveUserEmail();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SlotArrangementScreen()),
      );
    } else {
      // Failed to post data
      developer.log('Failed to login user. Error: ${response.statusCode}');
    }
  }
  saveUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = _emailController.text;
    await prefs.setString("userEmail", userEmail);
    developer.log("Email saved to SharedPreferences: $userEmail");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //add image
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background1.png',
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                '    Login to \n    your account',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            //Email
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                '       Email Address',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 223, 223),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.grey,
                  ),
                  hintText: 'nimal@domain.abc',
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                  //  errorText: _validate ? 'Value cant be empty' : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            //password
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                '       Password',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 223, 223),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: '********',
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                  //  errorText: _validate ? 'Value cant be empty' : null,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                );
              },
              child: const Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'forgot password?     ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 150),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  'I don\'t have account',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  loginUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}