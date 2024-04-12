// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park_direct_frontend/util/app_constants.dart';
import 'dart:convert';

import '../../models/parking_slot_model.dart'; // For decoding the JSON response

class SelectASlotScreen extends StatefulWidget {
  const SelectASlotScreen({super.key});
  @override
  _SelectASlotScreenState createState() => _SelectASlotScreenState();
}

class _SelectASlotScreenState extends State<SelectASlotScreen> {
  List<ParkingSlot> parkingSlots = [];
  bool isLoading = true; // Track loading state
  String? selectedSlotId; // Track the ID of the currently selected slot

  @override
  void initState() {
    super.initState();
    fetchParkingSlots();
  }

  Future<void> fetchParkingSlots() async {
    const url = '${AppConstants.baseUrl}/officer/all-parking-slots';
    try {
      final response = await http.get(Uri.parse(url));
      print('HTTP Response status: ${response.statusCode}'); // Debugging line
      final List<dynamic> fetchedSlots = json.decode(response.body);

      if (fetchedSlots.isEmpty) {
        print('No slots were fetched.'); // Debugging line
      }

      final List<ParkingSlot> loadedSlots = [];
      for (var slot in fetchedSlots) {
        loadedSlots.add(ParkingSlot.fromJson(slot));
        print('Loaded slot: ${slot['slotId']}'); // Debugging line
      }

      setState(() {
        parkingSlots = loadedSlots;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching slots: $error'); // Debugging line
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Select a Slot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: parkingSlots.length,
        itemBuilder: (context, index) {
          final parkingSlot = parkingSlots[index];
          bool isSelected = selectedSlotId == parkingSlot.slotId && !parkingSlot.isBooked;

          return GestureDetector(
            onTap: !parkingSlot.isBooked
                ? () {
                    setState(() {
                      if (isSelected) {
                        selectedSlotId = null;
                      } else {
                        selectedSlotId = parkingSlot.slotId;
                      }
                    });
                  }
                : null, // Disable tap if the slot is booked
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFFC700)
                    : parkingSlot.isBooked
                        ? Colors.red
                        : const Color(0xFFF3F6FF),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  'S${index + 1}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}