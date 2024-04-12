// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../../models/booking_model.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking; // Add this line

  // Modify the constructor to accept a Booking object
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${booking.email}'),
            Text('Arrival Time: ${booking.arrivalTime}'),
            Text('Leave Time: ${booking.leaveTime}'),
            Text('Vehicle Number: ${booking.vehicleNumber}'),
            Text('Parking Slot ID: ${booking.parkingSlotId}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}