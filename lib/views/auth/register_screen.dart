// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../controllers/email_controller.dart';
import '../../util/app_constants.dart';
import 'verification_code_screen.dart';
import 'vehicle_owner_login_screen.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  Future<void> registerUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.sendVerificationEmail}';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": _emailController.text,
      }),
    );
    if (response.statusCode == 201) {
      developer.log('Email sent successfully');
      saveUserEmail();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationCodeScreen()),
      );
    } else {
      developer.log('Failed to sent email. Error: ${response.statusCode}');
    }
  }
  saveUserEmail() async {
    String registerEmail = _emailController.text;
    final emailController = Get.find<EmailController>();
    emailController.saveEmailAddress(registerEmail);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background1.png',
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Register as a\nVehicle Owner',
                style: GoogleFonts.lato(fontSize: 25, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
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
                      fontWeight: FontWeight.bold,
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
                    color: const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 1.0),
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
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      registerUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(
                            color: Color(0xFFFFC700),
                          ),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}