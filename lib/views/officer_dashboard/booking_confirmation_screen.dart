// ignore_for_file: use_super_parameters

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:park_direct_frontend/util/app_constants.dart';
import 'package:park_direct_frontend/views/officer_dashboard/select_a_slot_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/booking_model.dart';
class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking; // Your Booking object
  const BookingConfirmationScreen({Key? key, required this.booking}) : super(key: key);
  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String? savedSlotId;
  // bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedSlotId();
  }
  Future<void> _loadSavedSlotId() async {
    final slotId = await getSavedSlotId();
    setState(() {
      savedSlotId = slotId;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Detail')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Vehicle Number')),
                  DataCell(Text(widget.booking.vehicleNumber)),
                ]),
                // Assuming booking.date exists and you want to display it
                DataRow(cells: [
                  const DataCell(Text('Date')),
                  DataCell(Text(widget.booking.date.toString())), // Add your booking date here
                ]),
                DataRow(cells: [
                  const DataCell(Text('Arrival Time')),
                  DataCell(Text(widget.booking.arrivalTime)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Leave Time')),
                  DataCell(Text(widget.booking.leaveTime)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Parking Slot ID')),
                  DataCell(GestureDetector(
                    onTap: () async {
                      final selectedSlotId = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectASlotScreen(),
                        ),
                      );
                      if (selectedSlotId != null) {
                        setState(() {
                          savedSlotId = selectedSlotId.toString();
                        });
                      }
                    },
                    child: savedSlotId == null
                        ? Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFFFC700),
                            ),
                            child: const Text(
                              'Select a Slot',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Text(savedSlotId!),
                  )),
                ]),
              ],
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  confirmBooking();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
  Future<String?> getSavedSlotId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedSlotId'); // This returns null if no slot ID was saved
  }

  Future<void> confirmBooking() async {
    // setState(() {
    //   _isLoading = true;
    // });
    final url = Uri.parse('${AppConstants.baseUrl}/officer/confirm-booking-request');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'bookingId': widget.booking.bookingId, // Assuming `id` is a property of your Booking model
        'parkingSlotId': savedSlotId!,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Booking confirmed successfully');
      // Optionally, navigate away or show a success message
    } else {
      // Handle error
      print('Failed to confirm booking');
      // Optionally, show an error message
    }

    // setState(() {
    //   _isLoading = false;
    // });
  }
}