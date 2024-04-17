// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../models/booking_model.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: Text(
          "Vehicle Number: ${widget.booking.vehicleNumber}",
          style: const TextStyle(
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
                  DataCell(
                    GestureDetector(
                      //onTap: () => _selectDate(context),
                      child: Text(widget.booking.date.toString()),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Arrival Time')),
                  DataCell(
                    GestureDetector(
                      //onTap: () => _selectTime(context, true),
                      child: Text(widget.booking.arrivalTime),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Leave Time')),
                  DataCell(
                    GestureDetector(
                      //onTap: () => _selectTime(context, false),
                      child: Text(widget.booking.leaveTime),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Parking Slot ID')),
                  DataCell(GestureDetector(
                    onTap: () async {},
                    child: Text(widget.booking.parkingSlotId == "parkingSlotId" ? "Not confirmed yet" : widget.booking.parkingSlotId),
                  )),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Booking status')),
                  DataCell(GestureDetector(
                    onTap: () async {},
                    child: Text(widget.booking.status),
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