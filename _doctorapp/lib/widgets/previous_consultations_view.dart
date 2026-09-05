import 'package:flutter/material.dart';
import '../models/consultation_history.dart';
import '../screens/consultation_details_screen.dart';
import '../theme/app_theme.dart';

class PreviousConsultationsView extends StatelessWidget {
  final bool showHeader;

  const PreviousConsultationsView({
    super.key,
    this.showHeader = true,
  });

  List<ConsultationHistory> get _dummyHistory => [
        ConsultationHistory(
          date: '20 Aug 2026',
          time: '09:30 AM',
          visitType: 'Follow-up Consultation',
          diagnosis: 'Acute Tonsillitis',
          symptoms: ['Sore throat', 'Fever', 'Difficulty swallowing'],
          treatment: [
            'Paracetamol 650mg — Twice daily',
            'Amoxicillin 500mg — Thrice daily'
          ],
          doctorNotes:
              'Patient advised to take rest and maintain hydration. Follow up after 5 days if symptoms persist.',
        ),
        ConsultationHistory(
          date: '12 Jul 2026',
          time: '11:15 AM',
          visitType: 'General Consultation',
          diagnosis: 'Viral Fever',
          symptoms: ['High fever', 'Body ache', 'Fatigue'],
          treatment: [
            'Paracetamol 650mg — Twice daily',
            'ORS, as required'
          ],
          doctorNotes: 'Symptoms improving. Advice: Take light diet.',
        ),
        ConsultationHistory(
          date: '05 Jun 2026',
          time: '10:00 AM',
          visitType: 'Follow-up Consultation',
          diagnosis: 'Allergic Rhinitis',
          symptoms: ['Sneezing', 'Runny nose', 'Itchy eyes'],
          treatment: [
            'Levocetirizine 5mg — Once daily'
          ],
          doctorNotes: 'Avoid dust and allergens.',
        ),
      ];

  void _openDetails(BuildContext context, ConsultationHistory item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultationDetailsScreen(history: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Previous Consultations',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppTheme.textPrimary),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dummyHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = _dummyHistory[index];
            return InkWell(
              onTap: () => _openDetails(context, item),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date & Time Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.date,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          item.time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Visit Type & Diagnosis
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.visitType,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Diagnosis: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: item.diagnosis),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Treatment:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              ...item.treatment.map(
                                (t) => Text(
                                  '• $t',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                              if (item.doctorNotes.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textSecondary,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Doctor Notes: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: item.doctorNotes),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppTheme.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
