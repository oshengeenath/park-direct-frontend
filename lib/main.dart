import 'package:flutter/material.dart';
import 'package:park_direct_frontend/views/vehicle_owner_book_slot/slot_arrangement_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/auth/login_screen.dart';
import 'views/home_screens/officer_home_screen.dart';

void main() {
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Map<String, dynamic>>(
        future: getTokenAndUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!["token"] != null) {
            // Check user role and navigate accordingly
            String userRole = snapshot.data!["userData"]["userRole"] ?? "";
            if (userRole == "officer") {
              return const OfficerHomeScreen();
            } else if (userRole == "vehicleOwner") {
              return const SlotArrangementScreen();
            }
          }

          // If there's no data, token, or the role doesn't match, go to LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> getTokenAndUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString("token");
  String? userDataJson = prefs.getString("userData");
  Map<String, dynamic> userData = userDataJson != null ? jsonDecode(userDataJson) : {};
  return {
    "token": token,
    "userData": userData,
  };
}