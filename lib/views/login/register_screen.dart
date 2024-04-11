// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'verification_code_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> registerUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.sendMail}';

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
      // Successfully posted data
      developer.log('Email sent successfully');
      saveUserEmail();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerificationCodeScreen()),
      );
    } else {
      // Failed to post data
      developer.log('Failed to sent email. Error: ${response.statusCode}');
    }
  }
  saveUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String registerEmail = _emailController.text;
    await prefs.setString("registerEmail", registerEmail);
    developer.log("Email saved to SharedPreferences: $registerEmail");
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
              child: Text(
                '    Register to \n    ParkDirect Account',
                style: GoogleFonts.lato(fontSize: 25, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
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
                  fontWeight: FontWeight.bold,
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
            const SizedBox(
              height: 270,
            ),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => SignUp()),
            //     );
            //   },
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       'I don\'t have account',
            //       style: TextStyle(
            //         fontSize: 12,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 60,
              width: 300,
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
                  style: GoogleFonts.poppins(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}