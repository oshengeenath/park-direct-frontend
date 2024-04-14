import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/booking_model.dart';
import '../../util/app_constants.dart';
class ConfirmedRequestsScreen extends StatefulWidget {
  const ConfirmedRequestsScreen({super.key});
  @override
  State<ConfirmedRequestsScreen> createState() => _ConfirmedRequestsScreenState();
}
class _ConfirmedRequestsScreenState extends State<ConfirmedRequestsScreen> {
  late Future<List<Booking>> pendingRequests;
  @override
  void initState() {
    super.initState();
    pendingRequests = fetchConfirmedRequests();
  }
  Future<List<Booking>> fetchConfirmedRequests() async {
    final response = await http.get(Uri.parse(AppConstants.baseUrl + AppConstants.officerFetchAllConfirmedBookings));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Booking.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load confirmed bookings');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Confirmed Bookings',
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
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 244, 240, 240),
                      border: Border(
                        bottom: BorderSide(
                        color: Color(0xFFE3E2E2),
                        width: 1.0,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text("The vehicle '${booking.vehicleNumber}' is requesting a location."),
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