import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:park_direct_frontend/util/app_constants.dart';

import '../../models/booking_model.dart';
import 'booking_confirmation_Screen.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  _PendingRequestsScreenState createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  late Future<List<Booking>> pendingRequests;

  @override
  void initState() {
    super.initState();
    pendingRequests = fetchPendingRequests();
  }

  Future<List<Booking>> fetchPendingRequests() async {
    final response = await http.get(Uri.parse(AppConstants.baseUrl + AppConstants.officerFetchAllPendingBookings));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Booking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pending requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Pending Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Booking>>(
        future: pendingRequests,
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
                          // Pass the selected booking object to the BookingConfirmationScreen
                          builder: (context) => BookingConfirmationScreen(booking: booking),
                        ),
                      );
                    },
                    child: Container(
                      color: const Color(0xFFE3E2E2),
                      child: ListTile(
                        title: Text(booking.email),
                        subtitle: Text('Arrival: ${booking.arrivalTime}, Leave: ${booking.leaveTime}, Vehicle: ${booking.vehicleNumber}'),
                        trailing: Text('Slot: ${booking.parkingSlotId}'),
                        // Add more details or customize as needed
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