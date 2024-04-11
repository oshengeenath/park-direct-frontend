import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'login_screen.dart';
import 'sign_up_screen.dart';

@@ -38,7 +39,7 @@ class _VerificationCodeScreenState extends State<VerificationCodeScreen> {

  Future<void> sendVerirficationCode() async {
    await getUserData();
    const String apiUrl = 'http://10.0.2.2:8000/verify';
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.verify}';

    final response = await http.post(
      Uri.parse(apiUrl),