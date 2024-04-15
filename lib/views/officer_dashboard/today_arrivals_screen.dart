import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/booking_model.dart';
import '../../util/app_constants.dart';

class TodayArrivalsScreen extends StatefulWidget {
  const TodayArrivalsScreen({super.key});
  
  @override
  State<TodayArrivalsScreen> createState() => _TodayArrivalsScreenState();
}
class _TodayArrivalsScreenState extends State<TodayArrivalsScreen> {
  late Future<List<Booking>> pendingRequests;
  @override
  void initState() {
    super.initState();
    pendingRequests = fetchTodayArrivals();
  }
  Future<List<Booking>> fetchTodayArrivals() async {
    final response = await http.get(Uri.parse("${AppConstants.baseUrl}/officer/today-arrivals"));

    // Handling OK response
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Booking.fromJson(data)).toList();
    } else if (response.statusCode == 404) {
      // Handling Not Found response
      throw Exception('No arrivals found for today (404 Not Found).');
    } else {
      throw Exception('Failed to load today arrivals');
      // Handling other errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Today Arrivals',
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
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            // Checking if the snapshot has data and that data is an empty list
            return const Center(
              child: Text(
                'No Today Arrivals.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else {
            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final booking = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      // Your onTap functionality
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
                            width: 6, // Width of the color line
                            height: 80, // Adjust the height according to your ListTile height
                            color: Colors.yellow, // Color based on booking status
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
                                      color: Colors.yellow,
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