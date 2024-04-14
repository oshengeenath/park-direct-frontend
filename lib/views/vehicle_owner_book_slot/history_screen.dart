import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '/util/app_constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}
class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> historyData = [];
  String userEmail = '';
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchHistoryData();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userDataJson = prefs.getString("userData");
    Map<String, dynamic>? userData = userDataJson != null ? jsonDecode(userDataJson) : {};

    if (userData != null) {
      String? email = userData['email'];

      if (email != null) {
        setState(() {
          userEmail = email;
          developer.log("email: $userEmail");
        });
      } else {
        developer.log("Email was not found in stored user data.");
      }
    } else {
      developer.log("No user data found in SharedPreferences.");
    }
  }

  Future<void> fetchHistoryData() async {
    await getUserData();
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/vehicleOwner/get-all-bookings/$userEmail'),
      );
      if (response.statusCode == 200) {
        developer.log('body: ${response.body}');
        setState(() {
          historyData = json.decode(response.body);
          isLoading = false;
        });
        developer.log('search data: $historyData');
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      developer.log('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Road.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      isLoading
                          ? const CircularProgressIndicator()
                          : historyData.isEmpty
                              ? const Column(
                                  children: [
                                    SizedBox(
                                      height: 170,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        'Empty List',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Text(
                                        'You have not added any vehicles yet',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: historyData.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final item = historyData[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(maxWidth: 300),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 20),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFFFC700),
                                                      borderRadius: BorderRadius.circular(30),
                                                    ),
                                                    child: const Align(
                                                      child: Text(
                                                        'P',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text(
                                                    item['vehicleNumber'],
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 90,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child: Image.asset(
                                                      'assets/slot.png',
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const SizedBox(width: 80),
                                                  Text(
                                                    '${item['parkingSlotId']}  |  ${item['arrivalTime']}',
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}