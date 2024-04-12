class AppConstants {
  static const String baseUrl = "http://10.0.2.2:8000"; // for now the backend is locally hosted

  // Auth
  static const String sendVerificationEmail = "/auth/send-verification-email";
  static const String verifyEmail = "/auth/verify-email";
  static const String registerUser = "/auth/register-user";
  static const String loginUser = "/auth/login-user";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";

  // vehicle owner
  static const String vehicleOwnerBookSlot = "/vehicleOwner/book-slot";
  static const String vehicleOwnerGetAllBookings = "/vehicleOwner/get-all-bookings/chanakanbonline@gmail.com";

  // officer
  static const String officerFetchAllPendingBookings = "/officer/fetch-all-pending-requests";
  static const String officerFetchAllConfirmedBookings = "/officer/fetch-all-confirmed-bookings";
  static const String officerConfirmBookingRequest = "/officer/confirm-booking-request";
}