import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/vehicle_owner_book_slot/slot_arrangement_screen.dart';
import 'views/auth/vehicle_owner_login_screen.dart';
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
            String userRole = snapshot.data!["userData"]["userRole"] ?? "";
            if (userRole == "officer") {
              return const OfficerHomeScreen();
            } else if (userRole == "vehicleOwner") {
              return const SlotArrangementScreen();
            }
          }
          return const VehicleOwnerLoginScreen();
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