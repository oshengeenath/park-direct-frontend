// ignore_for_file: deprecated_member_use, use_build_context_synchronously, use_super_parameters
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
import 'map_screen.dart';
import '../profile/profile.dart';
class SlotArrangementScreen extends StatefulWidget {
  const SlotArrangementScreen({super.key});
  @override
  State<SlotArrangementScreen> createState() => _SlotArrangementScreenState();
}
class _SlotArrangementScreenState extends State<SlotArrangementScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
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
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 7))).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dateController.text = DateFormat.yMd().format(pickedDate);
      });
    });
  }
  saveSlotData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String slotDate = _dateController.text;
    String slotTime = timeValues[selectedValue];
    String vehicleNumber = _vehicleNumberController.text;
    await prefs.setString("slotDate", slotDate);
    await prefs.setString("slotTime", slotTime);
    await prefs.setString("vehicleNumber", vehicleNumber);
    developer.log('Slot Date: $slotDate');
    developer.log('Slot Time: $slotTime');
    developer.log('Vehicle Number: $vehicleNumber');
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFFFC700),
            title: const Text(
              '    Slot Arrangement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: const NavigationDrawer(), // Use the NavigationDrawer widget as the drawer
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () => _datePicker(),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 223, 223),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      width: 360,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFFFFC700),
                          ),
                          const SizedBox(width: 10),
                          const Text('Pick a Date'),
                          const SizedBox(
                            width: 100,
                          ),
                          Text(
                            _dateController.text,
                            //' ${timeValues[selectedValue]}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                //cupertino time selecter
                GestureDetector(
                  onTap: () => togglePickerVisibility(),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 223, 223),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 50,
                      width: 360,
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.timer,
                            color: Color(0xFFFFC700),
                          ),
                          const SizedBox(width: 10),
                          const Text('Pick a Time'),
                          const SizedBox(
                            width: 120,
                          ),
                          Text(
                            ' ${timeValues[selectedValue]}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'You Can Stay 30 Minutes only',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (isPickerVisible)
                  Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(color: const Color.fromARGB(142, 255, 255, 255), borderRadius: BorderRadius.circular(10), boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ]),
                    //child: CupertinoActionSheet(
                    // actions: [
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
                const SizedBox(height: 10),
                if (isPickerVisible)
                  GestureDetector(
                    onTap: () => togglePickerVisibility(),
                    child: Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ]),
                      child: const Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Icon(Icons.check_circle),
                          SizedBox(width: 10),
                          Text('Select'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                //vehicle Number
                Container(
                  width: 350,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 223, 223),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '       Vehicle',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _vehicleNumberController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                              borderSide: const BorderSide(color: Color.fromARGB(255, 170, 168, 168), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30), // Adjust the radius to make it circular
                              borderSide: const BorderSide(color: Color.fromARGB(255, 170, 168, 168), width: 2.0),
                            ),
                            hintText: 'C 9719 LJ',
                            hintStyle: const TextStyle(color: Color.fromARGB(255, 40, 38, 38)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 170,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    //image
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 226, 223, 223),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.topLeft,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/slot.png',
                          ),
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 280,
                      child: ElevatedButton(
                        onPressed: () async {
                          saveSlotData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC700),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SlotArrangementScreen()),
          );
          return false; // Return false to prevent the default back action
        });
  }
}
class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);
  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}
class _NavigationDrawerState extends State<NavigationDrawer> {
  String userEmail = ''; // Move userEmail to the state class
  Map<String, dynamic> profileData = {};
  @override
  void initState() {
    super.initState();
    fetchProfileData();
    getUserData(); // Call getUserData when the state is initialized
  }
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail') ?? '';
      developer.log("email: $userEmail");
    });
  }
  Future<void> fetchProfileData() async {
    await getUserData();
    try {
      final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
      if (response.statusCode == 200) {
        setState(() {
          profileData = json.decode(response.body);
        });
        developer.log('user data: $profileData');
      } else {
        throw Exception('Failed to get profile details');
      }
    } catch (error) {
      developer.log('Error fetching profile details: $error');
    }
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
                const SizedBox(height: 12),
                Text(
                  profileData["fullname"] ?? '',
                  style: const TextStyle(fontSize: 28, color: Colors.white),
                ),
                Text(
                  userEmail, // Display userEmail
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("userEmail");
              prefs.remove("slotDate");
              prefs.remove("slotTime");
              prefs.remove("vehicleNumber");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
        ]),
      );
}
// class NavigationDrawer extends StatelessWidget{
//   NavigationDrawer({Key? key}) : super(key: key);
//   String userEmail = '';
//   Map<String, dynamic> profileData = {};
//   getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userEmail = prefs.getString('userEmail') ?? '';
//     });
//   }
//   Future<void> fetchProfileData() async {
//     await getUserData();
//     try {
//       final response = await http.get(Uri.parse('${AppConstants.baseUrl}/getuserdetails/$userEmail'));
//       if (response.statusCode == 200) {
//         setState(() {
//           profileData = json.decode(response.body);
//         });
//         developer.log('user data: ${profileData}');
//       } else {
//         throw Exception('Failed to get profile details');
//       }
//     } catch (error) {
//       developer.log('Error fetching profile details: $error');
//     }
//   }
//   @override
//   Widget build(BuildContext context) => Drawer(
//         child: SingleChildScrollView(
//             child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             buildHeader(context),
//             buildMenuItems(context),
//           ],
//         )),
//       );
//   Widget buildHeader(BuildContext context) => Material(
//       color: Colors.blue.shade700,
//       child: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//               color: Color(0xFFFFC700),
//               padding: EdgeInsets.only(
//                 top: 24 + MediaQuery.of(context).padding.top,
//                 bottom: 24,
//               ),
//               child: Column(
//                 children: const [
//                   CircleAvatar(
//                     radius: 52,
//                     backgroundImage: AssetImage('assets/profile.png'),
//                   ),
//                   SizedBox(
//                     height: 12,
//                   ),
//                   Text(
//                     'Sadeepa Ranasinghe',
//                     style: TextStyle(fontSize: 28, color: Colors.white),
//                   ),
//                   Text(
//                     'userEmail',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   )
//                 ],
//               ))));
//   Widget buildMenuItems(BuildContext context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Wrap(runSpacing: 16, children: [
//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('profile'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => Profile()));
//             },
//           ),
//           ListTile(
//               leading: const Icon(Icons.history_rounded),
//               title: const Text('History'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => const HistoryPage()));
//               }),
//           ListTile(
//             leading: const Icon(Icons.payment),
//             title: const Text('Payment'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.support_agent),
//             title: const Text('Support'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.people),
//             title: const Text('Community'),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//               ),
//           ListTile(
//             leading: const Icon(
//               Icons.logout,
//               color: Colors.red,
//             ),
//             title: const Text(
//               'Log Out',
//               style: TextStyle(color: Colors.red),
//             ),
//             onTap: () async{
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.remove("userEmail");
//               prefs.remove("slotDate");
//               prefs.remove("slotTime");
//               prefs.remove("vehicleNumber");
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => const loginpage()));
//             },
//           ),
//         ]),
//       );
// }