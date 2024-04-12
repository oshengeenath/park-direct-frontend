// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SelectASlotScreen extends StatefulWidget {
  const SelectASlotScreen({super.key});

  @override
  _SelectASlotScreenState createState() => _SelectASlotScreenState();
}

class _SelectASlotScreenState extends State<SelectASlotScreen> {
  // Track the index of the currently selected slot
  int? selectedSlotIndex;

  @override
  Widget build(BuildContext context) {
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
        itemCount: 40,
        itemBuilder: (context, index) {
          // Determine if the current slot is selected
          bool isSelected = selectedSlotIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                // Update the selected slot index
                if (isSelected) {
                  // If the current slot is already selected, deselect it
                  selectedSlotIndex = null;
                  print('No slot is selected.'); // Print when no slot is selected
                } else {
                  // Select the tapped slot
                  selectedSlotIndex = index;
                  print('Selected slot: S${index + 1}'); // Print the selected slot name
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFC700) : const Color(0xFFF3F6FF),
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