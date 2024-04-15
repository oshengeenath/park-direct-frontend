import 'package:flutter/material.dart';
import '../officer_dashboard/parking_slots_screen.dart';
import '../officer_dashboard/pending_requests_screen.dart';
import '../officer_dashboard/today_arrivals_screen.dart';
import '../officer_dashboard/confirmed_bookings_screen.dart';
import '../common_screens/profile_screen.dart';

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
              iconImage: "assets/officer_home_icons/icon5.png",
              cardText: "Confirmed requests",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfirmedRequestsScreen()),
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