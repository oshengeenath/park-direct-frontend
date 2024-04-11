import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../book_slots/slot_arrangement_screen.dart';

class Profile extends StatefulWidget {
@@ -35,7 +36,7 @@ class _ProfileState extends State<Profile> {
  Future<void> fetchProfileData() async {
    await getUserData();
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);