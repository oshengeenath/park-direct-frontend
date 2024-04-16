import 'package:get/get.dart';

class ParkingSlotController extends GetxController {
  String _selectedParkingSlot = "";
  String get selectedParkingSlot => _selectedParkingSlot;

  void saveParkingSlot(String select) {
    _selectedParkingSlot = select;
    update();
  }
}