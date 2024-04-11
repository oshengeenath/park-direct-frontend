import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
@@ -27,7 +28,7 @@ class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUpUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.register}';

    final response = await http.put(
      Uri.parse(apiUrl),