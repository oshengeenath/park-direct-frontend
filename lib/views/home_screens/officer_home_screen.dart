import 'package:flutter/material.dart';
import 'package:park_direct_frontend/views/officer_dashboard/parking_slots_screen.dart';
import 'package:park_direct_frontend/views/officer_dashboard/pending_requests_screen.dart';
import 'package:park_direct_frontend/views/officer_dashboard/today_arrivals_screen.dart';
import 'package:park_direct_frontend/views/profile/profile_screen.dart';

class OfficerHomeScreen extends StatelessWidget {
  const OfficerHomeScreen({super.key});
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
                'Officer\ndashboard',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon1.png",
              cardText: "Pending requests",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PendingRequestsScreen()),
                );
              },
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon2.png",
              cardText: "Today arrivals",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodayArrivalsScreen()),
                );
              },
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon3.png",
              cardText: "Parking slots",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ParkingSlotsScreen()),
                );
              },
            ),
            ItemCard(
              iconImage: "assets/officer_home_icons/icon4.png",
              cardText: "My profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
  final String iconImage; // Path to the icon image
  final String cardText; // Text to be displayed on the card
  final VoidCallback onPressed; // Callback function for tap event
  const ItemCard({
    super.key,
    required this.iconImage,
    required this.cardText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrapping with GestureDetector to handle taps
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
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Adjust as needed
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding as needed
              child: Image.asset(iconImage), // Using the iconImage parameter
            ),
            Expanded(
              child: Text(cardText, style: const TextStyle(fontSize: 16)), // Using the cardText parameter
            ),
            // If you want an icon or image at the end, you can uncomment and adjust this:
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