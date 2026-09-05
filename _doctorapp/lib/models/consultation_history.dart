class ConsultationHistory {
  final String date;
  final String time;
  final String visitType;
  final String diagnosis;
  final List<String> symptoms;
  final List<String> treatment;
  final String doctorNotes;

  ConsultationHistory({
    required this.date,
    required this.time,
    required this.visitType,
    required this.diagnosis,
    required this.symptoms,
    required this.treatment,
    required this.doctorNotes,
  });
}
