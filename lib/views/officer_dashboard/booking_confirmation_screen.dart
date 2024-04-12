// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:park_direct_frontend/views/officer_dashboard/select_a_slot_screen.dart';
import '../../models/booking_model.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking; // Your Booking object
  const BookingConfirmationScreen({Key? key, required this.booking}) : super(key: key);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Detail')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Vehicle Number')),
                  DataCell(Text(booking.vehicleNumber)),
                ]),
                // Assuming booking.date exists and you want to display it
                DataRow(cells: [
                  const DataCell(Text('Date')),
                  DataCell(Text(booking.date.toString())), // Add your booking date here
                ]),
                DataRow(cells: [
                  const DataCell(Text('Arrival Time')),
                  DataCell(Text(booking.arrivalTime)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Leave Time')),
                  DataCell(Text(booking.leaveTime)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Parking Slot ID')),
                  DataCell(GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // Pass the selected booking object to the BookingConfirmationScreen
                          builder: (context) => const SelectASlotScreen(),
                        ),
                      );
                    },
                    child: Container(
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
                    ),
                  )),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}