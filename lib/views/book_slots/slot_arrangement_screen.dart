// ignore_for_file: use_super_parameters, use_build_context_synchronously, deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../../util/app_constants.dart';
import '../login/login_screen.dart';
import 'history_screen.dart';
import '../profile/profile.dart';

class SlotArrangementScreen extends StatefulWidget {
  const SlotArrangementScreen({super.key});
  @override
  State<SlotArrangementScreen> createState() => _SlotArrangementScreenState();
}

class _SlotArrangementScreenState extends State<SlotArrangementScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  String _displayTime = '00:00';
  DateTime pickedDate = DateTime.now();
  int dateFieldData = 0;
  int selectedValue = 0;
  bool isPickerVisible = false;
  String newValue = ' House Full';
  String userEmail = '';
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
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 7)))
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }

  Future<void> saveSlotData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString("userEmail") ??
        'default@example.com'; // Fetch the email, or use a default if not found

    String slotDate = _dateController.text;
    String slotTime = timeValues[selectedValue];
    String vehicleNumber = _vehicleNumberController.text;

    // Specify the backend endpoint URL
    Uri url = Uri.parse(
        '${AppConstants.baseUrl}/book-slot'); // Replace with your actual backend URL

    try {
      // Send a POST request to the backend
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': userEmail,
          'date': slotDate,
          'startTime': slotTime,
          'carNumber': vehicleNumber,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Slot booking successful!!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to book slot. Please try again.")),
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
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        final String formattedTime = pickedTime.format(context);
                        _displayTime = formattedTime;

                        int closestIndex = timeValues.indexOf(formattedTime);
                        if (closestIndex != -1) {
                          selectedValue = closestIndex;
                        }
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
                          const Text('Pick a Time'),
                          Text(
                            ' $_displayTime',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                ),
                if (isPickerVisible)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(142, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
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
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 168, 168),
                                  width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 170, 168, 168),
                                  width: 2.0),
                            ),
                            hintText: 'C 9719 LJ',
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
                      saveSlotData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC700),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255)),
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
            MaterialPageRoute(
                builder: (context) => const SlotArrangementScreen()),
          );
          return false;
        });
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
  //     final response = await http
  //         .get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
          ),
          ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HistoryScreen()));
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("userEmail");
              prefs.remove("slotDate");
              prefs.remove("slotTime");
              prefs.remove("vehicleNumber");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ]),
      );
}
