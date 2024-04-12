// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }

  Future<String?> getSavedSlotId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedSlotId'); // This returns null if no slot ID was saved
  }
}