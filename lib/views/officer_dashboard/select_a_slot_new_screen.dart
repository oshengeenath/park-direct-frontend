import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:park_direct_frontend/controllers/parking_slot_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;
import '../../models/parking_slot_model.dart';
import '../../util/app_constants.dart';

class SelectASlotNewScreen extends StatefulWidget {
  final String bookingDate;

  const SelectASlotNewScreen({super.key, required this.bookingDate});

  @override
  State<SelectASlotNewScreen> createState() => _SelectASlotNewScreenState();
}
class _SelectASlotNewScreenState extends State<SelectASlotNewScreen> {
  List<ParkingSlot> parkingSlots = [];
  bool isLoading = true;
  String? selectedSlotId;
  @override
  void initState() {
    super.initState();
    fetchParkingSlots();
  }
  Future<void> fetchParkingSlots() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? '';
    const url = AppConstants.baseUrl + AppConstants.offficerFetchAllParkingSlots;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
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
          'Parking slots availability',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      buildColumn(1, 0, borderTopLeft(), widget.bookingDate),
                      const Spacer(),
                      buildColumn(11, 1, middleBorderTopRight(), widget.bookingDate),
                      buildColumn(21, 2, middleBorderTopLeft(), widget.bookingDate),
                      const Spacer(),
                      buildColumn(31, 3, borderTopRight(), widget.bookingDate),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

// Assume parkingSlots and selectedDate are available in the scope or passed appropriately
  Widget buildColumn(int start, int colNum, BoxDecoration decoration, String selectedDate) {
    return Column(
      children: List.generate(10, (index) {
        // Find a parking slot that matches this UI slot
        var slotId = "S${start + index}";
        var slot = parkingSlots.firstWhere((s) => s.slotId == slotId, orElse: () => ParkingSlot(slotId: slotId, bookings: []));
        // Determine if the slot is available on the selected date
        DateTime parsedDate = DateTime.parse(selectedDate);
        bool isAvailable = !slot.isBookedOn(parsedDate);
        return createSlot(slotId, decoration, index == 9, colNum, isAvailable);
      }),
    );
  }
  Widget createSlot(String slotId, BoxDecoration decoration, bool isLast, int colNum, bool isAvailable) {
    var isSelected = selectedSlotId == slotId;
    var slotColor = isSelected ? Colors.yellow : (isAvailable ? const Color(0xFFF3F6FF) : Colors.red);
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
    return GestureDetector(
      onTap: isAvailable
          ? () {
              ParkingSlotController parkingSlotController = Get.find<ParkingSlotController>();
              parkingSlotController.saveParkingSlot(slotId);
              setState(() {
                selectedSlotId = slotId;
              });
            }
          : null,
      child: Container(
        decoration: finalDecoration,
        height: 50,
        width: 50,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(4),
          color: slotColor,
          child: Text(
            slotId,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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