import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import '../../models/parking_slot_model.dart';
import '../../util/app_constants.dart';

class ParkingSlotsNewScreen extends StatefulWidget {
  const ParkingSlotsNewScreen({super.key});

  @override
  State<ParkingSlotsNewScreen> createState() => _ParkingSlotsNewScreenState();
}

class _ParkingSlotsNewScreenState extends State<ParkingSlotsNewScreen> {
  List<ParkingSlot> parkingSlots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParkingSlots();
  }

  Future<void> fetchParkingSlots() async {
    const url = '${AppConstants.baseUrl}/officer/all-parking-slots';
    try {
      final response = await http.get(Uri.parse(url));
      developer.log('HTTP Response status: ${response.statusCode}');
      final List<dynamic> fetchedSlots = json.decode(response.body);

      if (fetchedSlots.isEmpty) {
        developer.log('No slots were fetched.');
      }

      final List<ParkingSlot> loadedSlots = [];
      for (var slot in fetchedSlots) {
        loadedSlots.add(ParkingSlot.fromJson(slot));
        developer.log('Loaded slot: ${slot['slotId']}');
      }

      setState(() {
        parkingSlots = loadedSlots;
        isLoading = false;
      });
    } catch (error) {
      developer.log('Error fetching slots: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Parking slots new screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.all(32),
              child: Row(
                children: [
                  // Assuming your slot IDs are sequential and match the UI slots one-to-one
                  buildColumn(1, 0, borderTopLeft()),
                  const Spacer(),
                  buildColumn(11, 1, middleBorderTopRight()),
                  buildColumn(21, 2, middleBorderTopLeft()),
                  const Spacer(),
                  buildColumn(31, 3, borderTopRight()),
                ],
              ),
            ),
    );
  }

  Widget buildColumn(int start, int colNum, BoxDecoration decoration) {
    return Column(
      children: List.generate(10, (index) {
        // Find a parking slot that matches this UI slot
        var slotId = "S${start + index}";
        var slot = parkingSlots.firstWhere((s) => s.slotId == slotId, orElse: () => ParkingSlot(slotId: slotId, status: "booked")); // Default to available if not found
        return createSlot(slotId, decoration, index == 9, colNum, slot.status == "available");
      }),
    );
  }

  Widget createSlot(String text, BoxDecoration decoration, bool isLast, int colNum, bool isAvailable) {
    var slotColor = isAvailable ? const Color(0xFFF3F6FF) : Colors.red;

    BoxDecoration finalDecoration;
    if (isLast && (colNum == 0)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 2.0),
        ),
      );
    } else if (isLast && (colNum == 2)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          left: BorderSide(color: Colors.black, width: 1.0),
        ),
      );
    } else if (isLast && (colNum == 1)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          right: BorderSide(color: Colors.black, width: 1.0),
        ),
      );
    } else if (isLast && (colNum == 3)) {
      finalDecoration = decoration.copyWith(
        border: const Border(
          top: BorderSide(color: Colors.black, width: 2.0),
          bottom: BorderSide(color: Colors.black, width: 2.0),
          right: BorderSide(color: Colors.black, width: 2.0),
        ),
      );
    } else {
      finalDecoration = decoration;
    }

    return Container(
      decoration: finalDecoration,
      //margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 50,
      width: 50,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        color: slotColor,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  BoxDecoration borderTopLeft() {
    return const BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration borderTopRight() {
    return const BoxDecoration(
      border: Border(
        right: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  BoxDecoration middleBorderTopLeft() {
    return const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        left: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    );
  }

  BoxDecoration middleBorderTopRight() {
    return const BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
        right: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    );
  }
}