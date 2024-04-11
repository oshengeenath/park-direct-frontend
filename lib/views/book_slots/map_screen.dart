import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import 'parkalert_screen.dart';
import '../splash/splash_screen.dart';

@@ -43,7 +44,7 @@ class _MapScreenState extends State<MapScreen> {

  Future<void> bookSlot() async {
    await getUserData();
    const String apiUrl = '${AppConstants.baseUrl}${AppConstants.bookSlot}';

    final response = await http.post(
      Uri.parse(apiUrl),