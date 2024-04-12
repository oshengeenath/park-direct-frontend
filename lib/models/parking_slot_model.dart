class ParkingSlot {
  final String slotId;
  final String status; // "available" or "booked"

  ParkingSlot({required this.slotId, required this.status});

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      slotId: json['slotId'],
      status: json['status'], // Expecting "available" or "booked"
    );
  }

  // Helper method to determine if the slot is booked
  bool get isBooked => status == "booked";
}