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
  bool _isPasswordVisible = false;
  Future<void> loginUser() async {
    try {
      const String apiUrl = '${AppConstants.baseUrl}${AppConstants.loginUser}';
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
        final responseData = json.decode(response.body);

        // Assuming the response data contains a 'user' object and a 'token' string
        saveUserLocally(responseData['user'], responseData['token']);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SlotArrangementScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful!')),
        );
      } else {
        developer.log('Failed to login user. Error: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      developer.log('Failed to login user. Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network Error: Please try again later.')),
      );
    }
  }

  Future<void> saveUserLocally(Map<String, dynamic> userData, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the entire user data as a JSON string
    await prefs.setString("userData", jsonEncode(userData));

    // Save the token
    await prefs.setString("token", token);

    developer.log("User data and token saved to SharedPreferences");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                'Login to\nyour account',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 223, 223),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _emailController,
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
                      hintText: 'user@gmail.com',
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 223, 223),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      hintText: '********',
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                    ),
                  ),
                ),
              ],
            ),
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
                  'Don\'t have an account Register',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}