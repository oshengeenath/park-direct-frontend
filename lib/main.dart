import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/email_controller.dart';
import 'controllers/parking_slot_controller.dart';
import 'views/auth/vehicle_owner_login_screen.dart';
import 'views/home_screens/officer_home_screen.dart';
import '/views/home_screens/vehicle_owner_home_screen.dart';

void main() {
  Get.put(EmailController());
  Get.put(ParkingSlotController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
              return const VehicleOwnerHomeScreen();
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