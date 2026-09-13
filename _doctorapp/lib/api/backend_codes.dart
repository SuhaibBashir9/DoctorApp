/// Backend status codes and constants matching the ShifaQ Angular reference app.

class UserType {
  UserType._();

  static const String doctor = 'D';
  static const String patient = 'P';
  static const String clinic = 'C';
}

class AppointmentStatus {
  AppointmentStatus._();

  static const String booked = 'BKD';
  static const String checkedIn = 'CKD';
  static const String onHold = 'HLD';
  static const String visited = 'VST';
  static const String skipped = 'SKP';
  static const String cancelled = 'CNL';
}

class RequeuePosition {
  RequeuePosition._();

  static const String end = 'END';
  static const String front = 'FRONT';
}

class ScheduleStatus {
  ScheduleStatus._();

  static const String active = 'ACT';
  static const String completed = 'CMP';
  static const String newSchedule = 'NEW';
  static const String ready = 'RDY';
  static const String skipped = 'SKP';
  static const String cancelled = 'CNL';
}
