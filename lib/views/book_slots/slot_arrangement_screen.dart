import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../login/login_screen.dart';
import 'history_screen.dart';
import 'map_screen.dart';
@@ -408,7 +409,7 @@ class _NavigationDrawerState extends State<NavigationDrawer> {
  Future<void> fetchProfileData() async {
    await getUserData();
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
@@ -549,7 +550,7 @@ class _NavigationDrawerState extends State<NavigationDrawer> {
//   Future<void> fetchProfileData() async {
//     await getUserData();
//     try {
//       final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
//       if (response.statusCode == 200) {
//         setState(() {
//           profileData = json.decode(response.body);