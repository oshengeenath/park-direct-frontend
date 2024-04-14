// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import '/util/app_constants.dart';
import '/views/officer_dashboard/select_a_slot_screen.dart';
import '../../models/booking_model.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String? savedSlotId;

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
                DataRow(cells: [
                  const DataCell(Text('Date')),
                  DataCell(Text(widget.booking.date.toString())),
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
    return prefs.getString('selectedSlotId');
  }

  Future<void> confirmBooking() async {
    final url = Uri.parse('${AppConstants.baseUrl}/officer/confirm-booking-request');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'bookingId': widget.booking.bookingId,
        'parkingSlotId': savedSlotId!,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Delete the parking slot ID from SharedPreferences after successful confirmation
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selectedSlotId');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to confirm booking.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}