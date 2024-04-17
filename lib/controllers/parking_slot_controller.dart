import 'package:get/get.dart';

class ParkingSlotController extends GetxController {
  RxString _selectedParkingSlot = "".obs;
  RxString get selectedParkingSlot => _selectedParkingSlot;

  void saveParkingSlot(String selection) {
    _selectedParkingSlot.value = selection;
    update();
  }

  void clearSelection() {
    _selectedParkingSlot.value = "";
    update();
  }
}