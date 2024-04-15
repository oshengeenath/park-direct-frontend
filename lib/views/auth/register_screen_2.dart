// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../controllers/email_controller.dart';
import '../../util/app_constants.dart';
import 'vehicle_owner_login_screen.dart';
class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({super.key});
  @override
  State<RegisterScreen2> createState() => _RegisterScreen2State();
}
class _RegisterScreen2State extends State<RegisterScreen2> {
  bool isChecked = false;
  bool _obscureText = true;
  bool isPasswordStrong = true;
  bool _isValidMobile = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> signUpUser() async {
    String emailAddress = Get.find<EmailController>().emailAddress;
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.registerUser}';
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullname': _nameController.text,
        'email': emailAddress,
        'mobilenum': _mobileController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      developer.log('User sign-up successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
      );
    } else {
      developer.log('Failed to save sign-up user. Error: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
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
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Please complete your profile to create ParkDirect account',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _nameController,
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
                        Icons.person,
                        color: Colors.grey,
                      ),
                      hintText: 'John Doe',
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _mobileController,
                    onChanged: (value) {
                      setState(() {
                        _isValidMobile = value.length == 9 && int.tryParse(value) != null;
                        _isValidMobile = value.length == 10 && int.tryParse(value) != null;
                      });
                    },
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
                        Icons.email,
                        color: Colors.grey,
                      ),
                      hintText: '077XXXXXXX',
                      errorText: _isValidMobile ? null : 'Invalid Phone Number',
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FF),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    onChanged: (text) {
                      setState(() {
                        isPasswordStrong = isStrongPassword(text);
                      });
                    },
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
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: '********',
                        errorText: isPasswordStrong ? null : 'Use a strong Password'),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFC700),
                      ),
                      child: Checkbox(
                        side: const BorderSide(color: Color(0xFFFFC700)),
                        activeColor: const Color(0xFFFFC700),
                        value: isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            isChecked = newValue!;
                          });
                        },
                        checkColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text('I agree to '),
                    GestureDetector(
                      onTap: () {
                        _displayBottomSheet(context);
                      },
                      child: const Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      signUpUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
bool isStrongPassword(String password) {
  final RegExp hasUppercase = RegExp(r'[A-Z]');
  final RegExp hasLowercase = RegExp(r'[a-z]');
  final RegExp hasDigits = RegExp(r'\d');
  final RegExp hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  return hasUppercase.hasMatch(password) && hasLowercase.hasMatch(password) && hasDigits.hasMatch(password) && hasSpecialCharacters.hasMatch(password) && password.length >= 8;
}
class EmailValidator {
  static bool isValid(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }
}
Future _displayBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 400,
            width: 400,
            child: const Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'These terms and conditions outline the rules and regulations for the use of ParkDirect\'s Website, located at ParkDirect.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'By accessing this website we assume you accept \nthese terms and conditions. Do not continue to use ParkDirect if you do not agree to take all of the terms and conditions stated on this page.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ));
}