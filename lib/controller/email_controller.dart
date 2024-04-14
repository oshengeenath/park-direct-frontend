import 'package:get/get.dart';

class EmailController extends GetxController {
  String _emailAddress = "";
  String get emailAddress => _emailAddress;

  void saveEmailAddress(String email) {
    _emailAddress = email;
    update();
  }
}