import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<Profile> createState() => _ProfileState();
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userEmail = '';
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }
  Future<void> _fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userDataString = prefs.getString("userData") ?? '{}'; // Retrieve the user data JSON string
    final Map<String, dynamic> userData = json.decode(userDataString); // Decode the JSON string
    setState(() {
      profileData = userData;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC700),
       
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const SlotArrangementScreen()),
        //     );
        //   },
        // ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background1.png',
                alignment: Alignment.topRight,
              ),
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'assets/profile.png',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Personal Details',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 223, 223),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  hintText: profileData["fullname"],
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 223, 223),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                  hintText: profileData["email"],
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 226, 223, 223),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  hintText: profileData["mobilenum"],
                  hintStyle: const TextStyle(color: Color.fromARGB(255, 93, 89, 89)),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  logOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Log out',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> logOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove the saved token and user data
  await prefs.remove('token');
  await prefs.remove('userData');
  // Add any other keys you have saved and wish to clear upon logout

  developer.log("User logged out. Data cleared from SharedPreferences.");

  // Navigate to the login screen
  // Make sure to replace the navigation with whatever fits your app structure
  // For example, if you're using named routes, it could look different
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (Route<dynamic> route) => false,
  );
}