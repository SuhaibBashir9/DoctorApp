import 'package:flutter/material.dart';

import '../models/consultation_history.dart';
import '../theme/app_theme.dart';

class LiveConsultationForm extends StatefulWidget {
  final String patientId;
  final String visitType;
  final void Function(ConsultationHistory history)? onComplete;

  const LiveConsultationForm({
    super.key,
    required this.patientId,
    required this.visitType,
    this.onComplete,
  });

  @override
  State<LiveConsultationForm> createState() => _LiveConsultationFormState();
}

class _LiveConsultationFormState extends State<LiveConsultationForm> {
  final TextEditingController _complaintController =
  TextEditingController();
  final TextEditingController _symptomsController =
  TextEditingController();
  final TextEditingController _bpController =
  TextEditingController();
  final TextEditingController _pulseController =
  TextEditingController();
  final TextEditingController _tempController =
  TextEditingController();
  final TextEditingController _spo2Controller =
  TextEditingController();
  final TextEditingController _diagnosisController =
  TextEditingController();
  final TextEditingController _notesController =
  TextEditingController();

  @override
  void dispose() {
    _complaintController.dispose();
    _symptomsController.dispose();
    _bpController.dispose();
    _pulseController.dispose();
    _tempController.dispose();
    _spo2Controller.dispose();
    _diagnosisController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _completeConsultation() {
    final diagnosis = _diagnosisController.text.trim();

    if (diagnosis.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a diagnosis before completing.'),
        ),
      );
      return;
    }

    final symptoms = _parseList(_symptomsController.text);

    final treatment = <String>[];

    final complaint = _complaintController.text.trim();
    if (complaint.isNotEmpty) {
      treatment.add('Chief Complaint: $complaint');
    }

    final bp = _bpController.text.trim();
    if (bp.isNotEmpty) {
      treatment.add('BP: $bp mmHg');
    }

    final pulse = _pulseController.text.trim();
    if (pulse.isNotEmpty) {
      treatment.add('Pulse: $pulse bpm');
    }

    final temp = _tempController.text.trim();
    if (temp.isNotEmpty) {
      treatment.add('Temperature: $temp °C');
    }

    final spo2 = _spo2Controller.text.trim();
    if (spo2.isNotEmpty) {
      treatment.add('SpO2: $spo2%');
    }

    final now = DateTime.now();

    final history = ConsultationHistory(
      patientId: widget.patientId,
      date: _formatDate(now),
      time: _formatTime(now),
      visitType: widget.visitType,
      diagnosis: diagnosis,
      symptoms: symptoms,
      treatment: treatment,
      doctorNotes: _notesController.text.trim(),
    );

    widget.onComplete?.call(history);
  }

  List<String> _parseList(String value) {
    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chief Complaint',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          controller: _complaintController,
          decoration: const InputDecoration(
            hintText: "Enter patient's chief complaint",
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Symptoms',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          controller: _symptomsController,
          decoration: const InputDecoration(
            hintText: 'Add symptoms separated by commas',
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Vitals',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            _buildVitalItem(
              'BP',
              'mmHg',
              _bpController,
              '--/--',
            ),
            const SizedBox(width: 8),
            _buildVitalItem(
              'Pulse',
              'bpm',
              _pulseController,
              '--',
            ),
            const SizedBox(width: 8),
            _buildVitalItem(
              'Temp',
              '°C',
              _tempController,
              '--',
            ),
            const SizedBox(width: 8),
            _buildVitalItem(
              'SpO2',
              '%',
              _spo2Controller,
              '--',
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'Diagnosis',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          controller: _diagnosisController,
          decoration: const InputDecoration(
            hintText: 'Enter diagnosis',
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Doctor Notes',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),

        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Add notes here',
          ),
        ),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeConsultation,
            child: const Text('Complete Consultation'),
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildVitalItem(
      String label,
      String unit,
      TextEditingController controller,
      String placeholder,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.cardBorder,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 4),
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              unit,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}