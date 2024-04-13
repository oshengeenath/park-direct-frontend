// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:park_direct_frontend/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

      // Sort slots by slotId in ascending order
      loadedSlots.sort((a, b) => a.slotId.compareTo(b.slotId));
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
            // onTap: !parkingSlot.isBooked
            //     ? () async {
            //         final prefs = await SharedPreferences.getInstance();
            //         await prefs.setString('selectedSlotId', parkingSlot.slotId);
            //         Navigator.pop(context, parkingSlot.slotId);
            //       }
            //     : null,
            onTap: !parkingSlot.isBooked
                ? () async {
                    final prefs = await SharedPreferences.getInstance();
                    // Optional: Check if a slot was previously selected
                    final previouslySelectedSlotId = prefs.getString('selectedSlotId');
                    if (previouslySelectedSlotId != null) {
                      // Here you could inform the user that their previously selected slot is being replaced,
                      // This could be done via a dialog, toast, snackbar, etc.
                      print('Replacing previously selected slot $previouslySelectedSlotId with new selection ${parkingSlot.slotId}');
                    }
                    // Save the new selection
                    await prefs.setString('selectedSlotId', parkingSlot.slotId);
                    // Optionally, navigate back with the selected slot's ID
                    // This might be useful if you're selecting a slot through a modal/popup and need to pass the selection back
                    Navigator.pop(context, parkingSlot.slotId);
                  }
                : null,

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
                  parkingSlot.slotId,
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