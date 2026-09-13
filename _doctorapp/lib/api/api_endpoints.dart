/// Every backend path the app calls, in one place.
///
/// Repositories reference these constants instead of writing URL strings inline,
/// so the full API surface is visible at a glance and easy to change.
///
/// Paths are taken from the Angular reference app (`lib/web/src/app/core/services`).
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ────────────────────────────────────────────────────────────────
  static const String requestOtp = '/auth/mobile-login';
  static const String confirmOtp = '/auth/confirm-otp';

  // ── Clinic ──────────────────────────────────────────────────────────────
  static const String getClinics = '/clinic/get-clinics';
  static const String getClinicDetails = '/clinic/get-clinic-details';

  // ── Doctor & schedule ──────────────────────────────────────────────────
  static const String getDoctorSchedules = '/doctors/get-doctor-schedules';
  static const String getScheduleInfo = '/doctors/get-schedule-info';
  static const String startClinicSchedule = '/doctors/start-clinic-schedule';
  static const String closeClinicSchedule = '/doctors/close-clinic-schedule';
  static const String getDoctorDashboard = '/doctors/get-doctor-dashboard';
  static const String searchIcdCodes = '/doctors/search-icd-codes';
  static const String getDoctorDetails = '/doctors/get-doctor-details';

  // ── Patient & episode ──────────────────────────────────────────────────
  static const String getPatientEpisodes = '/patient/get-patient-episodes';
  static const String saveEpisode = '/patient/save-episode';
  static const String getPatientsWithSearch = '/patient/get-patients-with-search';

  // ── Appointment ────────────────────────────────────────────────────────
  static const String updateAppointmentStatus =
      '/appointments/update-appointment-status';
}
