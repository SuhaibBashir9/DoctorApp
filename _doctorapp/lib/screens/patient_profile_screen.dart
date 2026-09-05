import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/previous_consultations_view.dart';

class PatientProfileScreen extends StatelessWidget {
  final String patientId;
  final String patientName;
  final int age;
  final String gender;

  const PatientProfileScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Patient Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppTheme.accentGreen,
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.primaryDarkGreen,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient ID: $patientId  •  $age Y, $gender',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.cardBorder),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Blood Group', 'O+'),
                      _buildProfileStat('Height', '175 cm'),
                      _buildProfileStat('Weight', '72 kg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Consultation History Header & List
            const PreviousConsultationsView(showHeader: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
