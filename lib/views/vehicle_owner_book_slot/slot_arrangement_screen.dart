// ignore_for_file: use_super_parameters, use_build_context_synchronously, deprecated_member_use
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

import '../../util/app_constants.dart';
import '../auth/login_screen.dart';
import 'history_screen.dart';
import '../profile/profile.dart';
class SlotArrangementScreen extends StatefulWidget {
  const SlotArrangementScreen({super.key});
  @override
  State<SlotArrangementScreen> createState() => _SlotArrangementScreenState();
}
class _SlotArrangementScreenState extends State<SlotArrangementScreen> {
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
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 7))).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  Future<void> createBooking() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString("token") ?? ''; // Retrieve the saved token
    final String userDataString = prefs.getString("userData") ?? '{}'; // Retrieve the user data JSON string
    final Map<String, dynamic> userData = json.decode(userDataString); // Decode the user data
    final String userEmail = userData['email'] ?? 'default@example.com'; // Use the email from the decoded user data

    String slotDate = _dateController.text;

    String arrivalTime = _arrivalTime; // Ensure this is formatted correctly for your backend
    String leaveTime = _leaveTime; // Ensure this is formatted correctly for your backend
    String vehicleNumber = _vehicleNumberController.text;

     var uuid = const Uuid();
    String bookingId = uuid.v4(); // Generate a unique UUID for bookingId

    Uri url = Uri.parse('${AppConstants.baseUrl}/vehicleOwner/book-slot'); // Update the endpoint URL to the new path

    try {
       final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add the Authorization header with the token
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
          const SnackBar(content: Text("Slot booking successful!!")),
        );
      } else {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody['error'] ?? "Failed to book slot. Please try again.";
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error booking slot: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xFFFFC700),
            title: const Text(
              'Slot Arrangement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: const NavigationDrawer(),
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
                      color: const Color.fromARGB(255, 226, 223, 223),
                      borderRadius: BorderRadius.circular(30),
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
                    color: const Color.fromARGB(255, 226, 223, 223),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Vehicle',
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
                        child: TextField(
                          controller: _vehicleNumberController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 170, 168, 168), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 170, 168, 168), width: 2.0),
                            ),
                             hintText: 'ABC123',
                          ),
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
                       createBooking();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SlotArrangementScreen()),
          );
          return false;
        });
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

            // Optionally, update the closest index for the selected time
            // int closestIndex = timeValues.indexOf(formattedTime);
            // if (closestIndex != -1) {
            //   selectedValue = closestIndex;
            // }
          });
        }
      },
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 226, 223, 223),
            borderRadius: BorderRadius.circular(30),
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
    // TODO: Get user details thourgh login endpoint
    // fetchProfileData();
    getUserData();
  }
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? '';
      developer.log("email: $userEmail");
    });
  }
  // Future<void> fetchProfileData() async {
  //   await getUserData();
  //   try {
  //     final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         profileData = json.decode(response.body);
  //       });
  //       developer.log('user data: $profileData');
  //     } else {
  //       throw Exception('Failed to get profile details');
  //     }
  //   } catch (error) {
  //     developer.log('Error fetching profile details: $error');
  //   }
  // }
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryScreen()));
              }),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Payment'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Support'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
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
              //
              logOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ]),
      );
}
// TODO: Remove the JWT token from local storage
logOut() {}