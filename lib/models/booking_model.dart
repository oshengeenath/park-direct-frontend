class Booking {
  final String id;
  final String bookingId;
  final String email;
  final String date;
  final String arrivalTime;
  final String leaveTime;
  final String vehicleNumber;
  final String status;
  final String parkingSlotId;
  Booking({
    required this.id,
    required this.bookingId,
    required this.email,
    required this.date,
    required this.arrivalTime,
    required this.leaveTime,
    required this.vehicleNumber,
    required this.status,
    required this.parkingSlotId,
  });
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      bookingId: json['bookingId'],
      email: json['email'],
      date: json['date'],
      arrivalTime: json['arrivalTime'],
      leaveTime: json['leaveTime'],
      vehicleNumber: json['vehicleNumber'],
      status: json['status'],
      parkingSlotId: json['parkingSlotId'],
    );
  }
}