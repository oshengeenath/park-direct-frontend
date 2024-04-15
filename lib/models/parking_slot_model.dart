class ParkingSlot {
  final String slotId;
  final String status;

  ParkingSlot({required this.slotId, required this.status});

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      slotId: json['slotId'],
      status: json['status'],
    );
  }
  
  bool get isBooked => status == "booked";
}