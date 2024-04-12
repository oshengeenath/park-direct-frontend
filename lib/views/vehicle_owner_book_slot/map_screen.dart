// // ignore_for_file: use_super_parameters, use_build_context_synchronously

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:developer' as developer;

// import '../../util/app_constants.dart';
// import 'parkalert_screen.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({Key? key}) : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   String firstDropDown = 'Side A';
//   String secondDropDown = 'A01';
//   String userEmail = '';
//   String slotDate = '';
//   String slotTime = '';
//   String vehicleNumber = '';

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userEmail = prefs.getString('userEmail') ?? '';
//       slotDate = prefs.getString('slotDate') ?? '';
//       slotTime = prefs.getString('slotTime') ?? '';
//       vehicleNumber = prefs.getString('vehicleNumber') ?? '';
//     });
//   }

//   Future<void> bookSlot() async {
//     await getUserData();
//     const String apiUrl = '${AppConstants.baseUrl}${AppConstants.bookSlot}';

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{"email": userEmail, "slot": secondDropDown, "date": slotDate, "startTime": slotTime, "carNumber": vehicleNumber}),
//     );

//     if (response.statusCode == 200) {
//       // Successfully posted data
//       developer.log('Slot Booked successfully: ${response.body}');
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const ParkAlertScreen()),
//       );
//     } else if (response.statusCode == 400) {
//       developer.log('Slot already booked: ${response.body}');
//       showSlotAlreadyBookedMessage(context);
//     } else {
//       // Failed to post data
//       developer.log('Failed to save map data: ${response.body}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: const Color(0xFFFFC700),
//         title: const Text(
//           'Select a slot',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Container(
//               alignment: Alignment.center,
//               margin: const EdgeInsets.only(top: 30),
//               child: Image.asset(
//                 'assets/Map.jpg',
//               ),
//             ),
//             const Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Select side',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: Colors.grey,
//                 ),
//                 child: Row(
//                   children: [
//                     DropdownButton<String>(
//                       value: firstDropDown,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           firstDropDown = newValue!;
//                           // Reset the second dropdown value when the first dropdown changes
//                           if (firstDropDown == 'Side A') {
//                             secondDropDown = 'A01';
//                           } else if (firstDropDown == 'Side B') {
//                             secondDropDown = 'B01';
//                           }
//                         });
//                       },
//                       icon: null,
//                       items: <String>['Side A', 'Side B'].map((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                     const Icon(Icons.arrow_downward),
//                   ],
//                 )),
//             const Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Select Parking Slot',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//                 padding: const EdgeInsets.all(8),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: Colors.grey,
//                 ),
//                 child: Row(
//                   children: [
//                     DropdownButton<String>(
//                       value: secondDropDown,
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           secondDropDown = newValue!;
//                         });
//                       },
//                       icon: null,
//                       items: (firstDropDown == 'Side A')
//                           ? <String>['A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10'].map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList()
//                           : <String>['B01', 'B02', 'B03', 'B04', 'B05', 'B06', 'B07', 'B08', 'B09', 'B10'].map<DropdownMenuItem<String>>((String value) {
//                               return DropdownMenuItem<String>(
//                                 value: value,
//                                 child: Text(value),
//                               );
//                             }).toList(),
//                     ),
//                     const Icon(Icons.arrow_downward),
//                   ],
//                 )),
//             SizedBox(
//               height: 40,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   bookSlot();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFFFC700),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
//                 ),
//                 child: const Text(
//                   'Confirm',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void showSlotAlreadyBookedMessage(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//         content: const SizedBox(
//           width: 200, // Adjust the width to your desired value
//           child: Text(
//             'Slot Already Booked!',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         behavior: SnackBarBehavior.floating, // Makes the SnackBar smaller
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }
// }