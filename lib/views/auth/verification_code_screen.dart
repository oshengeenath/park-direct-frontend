// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'vehicle_owner_login_screen.dart';
import 'register_screen_2.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});
  @override
  _VerificationCodeScreenState createState() => _VerificationCodeScreenState();
}
class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  String registerEmail = '';
  final TextEditingController _verificationCodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserData();
  }
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      registerEmail = prefs.getString('registerEmail') ?? '';
      developer.log("email: $registerEmail");
    });
  }
  Future<void> sendVerirficationCode() async {
    await getUserData();
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.verifyEmail}';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": registerEmail,
        "verificationCode": _verificationCodeController.text,
      }),
    );
    if (response.statusCode == 200) {
      developer.log('Verification code successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RegisterScreen2()),
      );
    } else {
      developer.log('Failed to save verification code. Error: ${response.body}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/background1.png',
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Enter Verification\nCode',
                style: GoogleFonts.lato(fontSize: 25, color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Please enter the verification code we sent to your email\n$registerEmail',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Verification Code',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 223, 223),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _verificationCodeController,
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
                      hintText: 'A3DVFE',
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                    ),
                  ),
                  ),
              
                const SizedBox(
                  height: 16,
                ),
              
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      //fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  sendVerirficationCode();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: Text(
                  'Verify',
                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}