import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../../models/booking_model.dart';
import '/util/app_constants.dart';
import 'booking_shistrory_detail_screen.dart';

class VehicleOwnerBookingHistoryScreen extends StatefulWidget {
  const VehicleOwnerBookingHistoryScreen({super.key});

  @override
  State<VehicleOwnerBookingHistoryScreen> createState() => _VehicleOwnerBookingHistoryScreenState();
}

class _VehicleOwnerBookingHistoryScreenState extends State<VehicleOwnerBookingHistoryScreen> {
  late Future<List<Booking>> historyData;
  String userEmail = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    historyData = fetchHistoryData();
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

  Future<List<Booking>> fetchHistoryData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? '';
    await getUserData();

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/vehicleOwner/get-all-bookings/$userEmail'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Booking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Booking History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Booking>>(
        future: historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final booking = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingHistoryDetailScreen(
                                  booking: booking,
                                )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFE3E2E2),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 80,
                            color: getStatusColor(booking.status),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                booking.vehicleNumber,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Date: ${booking.date}"), Text("From ${booking.arrivalTime} to ${booking.leaveTime}")],
                              ),
                              trailing: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: getStatusColor(booking.status),
                                    ),
                                    child: Text(
                                      booking.status,
                                      style: const TextStyle(
                                        color: Color(0xFF192342),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    "booking status",
                                    style: TextStyle(
                                      color: Color(0xFF192342),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'failed':
      return Colors.red;
    case 'confirmed':
      return Colors.green;
    case 'pending':
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}