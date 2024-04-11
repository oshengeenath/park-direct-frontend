import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'verification_code_screen.dart';

class RegisterScreen extends StatefulWidget {
@@ -20,7 +21,7 @@ class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> registerUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.sendMail}';

    final response = await http.post(
      Uri.parse(apiUrl),