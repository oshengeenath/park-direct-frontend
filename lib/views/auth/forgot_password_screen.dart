// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../../util/app_constants.dart';
import 'change_password_screen.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController _forgotPasswordEmail = TextEditingController();
  Future<void> sendForgotPasswordToken() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.forgotPassword}';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": _forgotPasswordEmail.text,
      }),
    );

    if (response.statusCode == 200) {
      developer.log('Token sent to change password successfully');
      saveUserEmail();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
      );
    } else {
      developer.log('Failed to send token. Error: ${response.statusCode}');
    }
  }
  saveUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String forgotPasswordEmail = _forgotPasswordEmail.text;
    await prefs.setString("forgotPasswordEmail", forgotPasswordEmail);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background1.png',
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                '    Forget \n    Password ',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                '      Please enter your email number to change\n       your password',
                style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 183, 170, 170)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
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
                controller: _forgotPasswordEmail,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.grey,
                  ),
                  hintText: 'nimal@domain.abc',
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 180),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  sendForgotPasswordToken();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Continue',
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