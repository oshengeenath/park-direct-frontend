import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:park_direct_frontend/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

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
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? '';
      developer.log("email: $userEmail");
    });
  }
  Future<void> fetchHistoryData() async {
    await getUserData();
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/bookings/$userEmail'));
      if (response.statusCode == 200) {
        developer.log('body: ${response.body}');
        setState(() {
          historyData = json.decode(response.body);
          isLoading = false; // Data loading completed
        });
        developer.log('search data: $historyData');
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      developer.log('Error fetching data: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: const <Widget>[
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     // Handle search functionality
          //   },
          // ),
        ],
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
                      // Container(
                      //   alignment: Alignment.topLeft,
                      //   child: Text(
                      //     ' Result',
                      //     style: TextStyle(
                      //       fontSize: 20,
                      //       color: Color.fromARGB(255, 178, 164, 164),
                      //     ),
                      //   ),
                      // ),
                      isLoading
                          ? const CircularProgressIndicator() // Show loading indicator while data is being fetched
                          : historyData.isEmpty
                              ? const Column(
                                  children: [
                                    SizedBox(
                                      height: 170,
                                    ),
                                    // Center(
                                    //   child: Image.asset(
                                    //     'assets/Logo3.jpg',
                                    //     height: 200,
                                    //     width: 200,
                                    //   ),
                                    // ),
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
                                        color: const Color.fromARGB(255, 226, 223, 223),
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Container(
                                          constraints: const BoxConstraints(maxWidth: 300),
                                          padding: const EdgeInsets.all(10), // Add padding for better appearance
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
                                                    item['carNumber'],
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
                                                    '${item['slot']}  |  ${item['startTime']}',
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              // Add more rows for other data items
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
                SizedBox(
                  height: 50,
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}