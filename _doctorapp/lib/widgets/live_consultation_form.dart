import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LiveConsultationForm extends StatefulWidget {
  final VoidCallback? onComplete;

  const LiveConsultationForm({
    super.key,
    this.onComplete,
  });

  @override
  State<LiveConsultationForm> createState() => _LiveConsultationFormState();
}

class _LiveConsultationFormState extends State<LiveConsultationForm> {
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _pulseController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _spo2Controller = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chief Complaint
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

        // Symptoms
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
            hintText: 'Add symptoms',
          ),
        ),
        const SizedBox(height: 16),

        // Vitals Section
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
            _buildVitalItem('BP', 'mmHg', _bpController, '--/--'),
            const SizedBox(width: 8),
            _buildVitalItem('Pulse', 'bpm', _pulseController, '--'),
            const SizedBox(width: 8),
            _buildVitalItem('Temp', '°C', _tempController, '--'),
            const SizedBox(width: 8),
            _buildVitalItem('SpO2', '%', _spo2Controller, '--'),
          ],
        ),
        const SizedBox(height: 16),

        // Diagnosis
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

        // Doctor Notes
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

        // Complete Consultation Button
        ElevatedButton(
          onPressed: () {
            if (widget.onComplete != null) {
              widget.onComplete!();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Consultation completed successfully!'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Complete Consultation'),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.cardBorder),
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
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                hintText: placeholder,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
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
