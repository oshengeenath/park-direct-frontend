// ignore_for_file: use_build_context_synchronously, use_super_parameters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../auth/vehicle_owner_login_screen.dart';
import 'booking_history_screen.dart';
import '../common_screens/profile_screen.dart';

class CreateABookingScreen extends StatefulWidget {
  const CreateABookingScreen({super.key});

  @override
  State<CreateABookingScreen> createState() => _CreateABookingScreenState();
}

class _CreateABookingScreenState extends State<CreateABookingScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();

  String _arrivalTime = '00:00';
  String _leaveTime = '00:00';

  DateTime pickedDate = DateTime.now();
  int dateFieldData = 0;
  int selectedValue = 0;
  bool isPickerVisible = false;

  void togglePickerVisibility() {
    setState(() {
      isPickerVisible = !isPickerVisible;
    });
  }

  void updateSelectedValue(int newValue) {
    setState(() {
      selectedValue = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    const NavigationDrawer();
  }

  List<String> timeValues = [
    '00:00',
    '01:00',
    '02:00',
    '03:00',
    '04:00',
    '05:00',
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
    '23:00',
  ];

  void _datePicker() {
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }

  bool isValidVehicleNumber(String vehicleNumber) {
    RegExp regex = RegExp(r'^(?=.*[A-Z]{2,})(?=.*\d{4,})[A-Z\d]+$');
    return regex.hasMatch(vehicleNumber);
  }

  bool areFieldsValid() {
    return _dateController.text.isNotEmpty && _arrivalTime != '00:00' && _leaveTime != '00:00' && _vehicleNumberController.text.isNotEmpty && isValidVehicleNumber(_vehicleNumberController.text);
  }

  Future<void> createBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? '';
    final String userDataString = prefs.getString("userData") ?? '{}';
    final Map<String, dynamic> userData = json.decode(userDataString);
    final String userEmail = userData['email'] ?? 'default@example.com';

    String slotDate = _dateController.text;
    String arrivalTime = _arrivalTime;
    String leaveTime = _leaveTime;
    String vehicleNumber = _vehicleNumberController.text;

    if (_arrivalTime.compareTo(_leaveTime) >= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Leave time must be later than arrival time."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    var uuid = const Uuid();
    String bookingId = uuid.v4();

    Uri url = Uri.parse('${AppConstants.baseUrl}/vehicleOwner/book-slot');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'bookingId': bookingId,
          'email': userEmail,
          'date': slotDate,
          'arrivalTime': arrivalTime,
          'leaveTime': leaveTime,
          'vehicleNumber': vehicleNumber,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Slot booking successful!!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VehicleOwnerBookingHistoryScreen()),
        );
      } else {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['error'] ?? "Failed to book slot. Please try again.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error booking slot: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFC700),
        title: const Text(
          'Create a Booking',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _datePicker(),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color.fromARGB(255, 226, 223, 223),
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFFFFC700),
                    ),
                    const Text('Pick a Date'),
                    Text(
                      _dateController.text,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
            buildTimePickerWidget(context, "Arrival Time", _arrivalTime, (selectedTime) => _arrivalTime = selectedTime),
            buildTimePickerWidget(context, "Leave Time", _leaveTime, (selectedTime) => _leaveTime = selectedTime),
            if (isPickerVisible)
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color.fromARGB(142, 255, 255, 255), borderRadius: BorderRadius.circular(10), boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ]),
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    updateSelectedValue(index);
                  },
                  children: timeValues.map((time) {
                    return Center(
                      child: Text(
                        time,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (isPickerVisible)
              GestureDetector(
                onTap: () => togglePickerVisibility(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ]),
                  child: const Row(
                    children: <Widget>[
                      Icon(Icons.check_circle),
                      Text('Select'),
                    ],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F6FF),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color.fromARGB(255, 226, 223, 223),
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Vehicle Number',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _vehicleNumberController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 226, 223, 223), width: 1.0),
                        ),
                        hintText: 'Enter Vehicle Number',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle number';
                        } else if (!isValidVehicleNumber(value)) {
                          return 'Vehicle number must contain at least 2 capital letters and 4 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (areFieldsValid()) {
                    await createBooking();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all the details before confirming."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC700),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildTimePickerWidget(BuildContext context, String timeLabel, String timeValue, Function(String) onTimeSelected) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            final String formattedTime = pickedTime.format(context);
            onTimeSelected(formattedTime);
          });
        }
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F6FF),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color.fromARGB(255, 226, 223, 223),
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const Icon(
                Icons.timer,
                color: Color(0xFFFFC700),
              ),
              Text(timeLabel),
              Text(
                ' $timeValue',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          )),
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  String userEmail = '';
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? '';
      developer.log("email: $userEmail");
    });
  }

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.blue.shade700,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: const Color(0xFFFFC700),
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                Text(
                  profileData["fullname"] ?? '',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(runSpacing: 16, children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('profile'),
            onTap: () {
              Navigator.pop(context);

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyProfileScreen()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VehicleOwnerBookingHistoryScreen()));
              }),
          const ListTile(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              logOut(context);
            },
          ),
        ]),
      );
}

Future<void> logOut(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('token');
  await prefs.remove('userData');

  developer.log("User logged out. Data cleared from SharedPreferences.");

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const VehicleOwnerLoginScreen()),
    (Route<dynamic> route) => false,
  );
}