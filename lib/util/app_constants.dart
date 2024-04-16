class AppConstants {
  static const String baseUrl = "http://park-direct-backend.northeurope.cloudapp.azure.com:3004";

  static const String sendVerificationEmail = "/auth/send-verification-email";
  static const String verifyEmail = "/auth/verify-email";
  static const String registerUser = "/auth/register-user";
  static const String loginUser = "/auth/login-user";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String vehicleOwnerBookSlot = "/vehicleOwner/book-slot";
  static const String vehicleOwnerGetAllBookings = "/vehicleOwner/get-all-bookings/chanakanbonline@gmail.com";
  static const String officerFetchAllPendingBookings = "/officer/fetch-all-pending-requests";
  static const String officerFetchAllConfirmedBookings = "/officer/fetch-all-confirmed-bookings";
  static const String officerConfirmBookingRequest = "/officer/confirm-booking-request";
}