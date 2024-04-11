import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'change_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
@@ -19,7 +20,7 @@ class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController _forgotPasswordEmail = TextEditingController();

  Future<void> sendForgotPasswordToken() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.forgotpassword}';

    final response = await http.post(
      Uri.parse(apiUrl),