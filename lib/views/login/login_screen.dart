import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../book_slots/slot_arrangement_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
@@ -22,7 +23,7 @@ class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.login}';

    final response = await http.post(
      Uri.parse(apiUrl),