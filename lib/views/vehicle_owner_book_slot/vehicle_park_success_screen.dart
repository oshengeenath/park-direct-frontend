import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class VehicleParkSuccess extends StatefulWidget {
  const VehicleParkSuccess({super.key});
  @override
  State<VehicleParkSuccess> createState() => _VehicleParkSuccessState();
}
class _VehicleParkSuccessState extends State<VehicleParkSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(253, 255, 201, 24),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/background-3.png',
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Colors.white,
                    size: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    " Success!",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(fontSize: 40, color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "  Your vehicle is parked.",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 130),
            Container(
              alignment: Alignment.bottomLeft,
              child: Image.asset(
                'assets/background-4.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}