import 'package:flutter/material.dart';

import 'package:park_direct_frontend/views/vehicle_owner_book_slot/booking_history_screen.dart';
import 'package:park_direct_frontend/views/vehicle_owner_book_slot/create_a_booking_screen.dart';
import '../common_screens/profile_screen.dart';

class VehicleOwnerHomeScreen extends StatelessWidget {
  const VehicleOwnerHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background1.png',
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Text(
                'Vehicle Owner\ndashboard',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon3.png",
              cardText: "Create a booking",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateABookingScreen()),
                );
              },
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon7.png",
              cardText: "Booking history",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VehicleOwnerBookingHistoryScreen()),
                );
              },
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon6.png",
              cardText: "My Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyProfileScreen()),
                );
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
class ItemCard extends StatelessWidget {
  final String iconImage;
  final String cardText;
  final VoidCallback onPressed;
  const ItemCard({
    super.key,
    required this.iconImage,
    required this.cardText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(iconImage),
            ),
            Expanded(
              child: Text(cardText, style: const TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset("assets/officer_home_icons/next_icon.png"),
            ),
          ],
        ),
      ),
    );
  }
}