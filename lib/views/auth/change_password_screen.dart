// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../util/app_constants.dart';
import 'login_screen.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePasswordScreen> {
  String forgotPasswordEmail = '';
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserData();
  }
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      forgotPasswordEmail = prefs.getString('forgotPasswordEmail') ?? '';
    });
  }
  Future<void> sendPasswordChangeData() async {
    await getUserData();
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.forgotPassword}';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": forgotPasswordEmail,
        "token": _tokenController.text,
        "newPassword": _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      developer.log('Password changed successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
      );
    } else {
      developer.log('Failed to change password. Error: ${response.statusCode}');
    }
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
                '    Change \n    your Password ',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 40,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                '       Enter the token sent to your email address',
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
                controller: _tokenController,
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
                    Icons.verified,
                    color: Colors.grey,
                  ),
                  hintText: '  w8899daa',
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                '       New password',
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
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 2.0),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  hintText: '  *********',
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            const SizedBox(height: 180),
            SizedBox(
              height: 60,
              width: 300,
              child: ElevatedButton(
                onPressed: () async {
                  sendPasswordChangeData();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Change password',
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