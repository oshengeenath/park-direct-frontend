import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '/views/login/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
@@ -36,7 +37,7 @@ class _ChangePasswordState extends State<ChangePasswordScreen> {

  Future<void> sendPasswordChangeData() async {
    await getUserData();
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.forgotpassword}';

    final response = await http.post(
      Uri.parse(apiUrl),