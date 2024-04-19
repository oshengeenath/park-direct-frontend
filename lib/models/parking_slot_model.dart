import 'package:intl/intl.dart'; // For date formatting

class ParkingSlot {
  final String slotId;
  final List<Booking> bookings;

  ParkingSlot({required this.slotId, required this.bookings});

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    List<Booking> bookingsList = (json['bookedDates'] as List).map((item) => Booking.fromJson(item)).toList();
    return ParkingSlot(
      slotId: json['slotId'],
      bookings: bookingsList,
    );
  }

  bool isBookedOn(DateTime date) {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);
    return bookings.any((booking) => formatter.format(booking.date) == formattedDate);
  }
}

class Booking {
  final String bookingId;
  final DateTime date;

  Booking({required this.bookingId, required this.date});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      date: DateTime.parse(json['date']),
    );
  }
}