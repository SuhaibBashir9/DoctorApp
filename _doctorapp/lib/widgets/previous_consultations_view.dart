import 'package:flutter/material.dart';

import '../models/consultation_history.dart';
import '../services/consultation_service.dart';
import '../screens/consultation_details_screen.dart';
import '../theme/app_theme.dart';

class PreviousConsultationsView extends StatelessWidget {
  final String patientId;
  final bool showHeader;

  const PreviousConsultationsView({
    super.key,
    required this.patientId,
    this.showHeader = true,
  });

  void _openDetails(
      BuildContext context,
      ConsultationHistory item,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultationDetailsScreen(
          history: item,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history =
    consultationService.getPatientHistory(patientId);

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
                icon: const Icon(
                  Icons.filter_list,
                  color: AppTheme.textPrimary,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],

        if (history.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.cardBorder,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.history,
                  size: 42,
                  color: AppTheme.textSecondary,
                ),
                SizedBox(height: 10),
                Text(
                  'No previous consultations',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Completed consultations will appear here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: history.length,
            separatorBuilder: (context, index) =>
            const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = history[index];

              return InkWell(
                onTap: () => _openDetails(context, item),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.cardBorder,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.date,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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

                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.visitType,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w600,
                                    color:
                                    AppTheme.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color:
                                      AppTheme.textSecondary,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Diagnosis: ',
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: item.diagnosis,
                                      ),
                                    ],
                                  ),
                                ),

                                if (item.symptoms.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Symptoms:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      AppTheme.textPrimary,
                                    ),
                                  ),
                                  ...item.symptoms.map(
                                        (symptom) => Text(
                                      '• $symptom',
                                      style:
                                      const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme
                                            .textSecondary,
                                      ),
                                    ),
                                  ),
                                ],

                                if (item.treatment.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Treatment:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      AppTheme.textPrimary,
                                    ),
                                  ),
                                  ...item.treatment.map(
                                        (treatment) => Text(
                                      '• $treatment',
                                      style:
                                      const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme
                                            .textSecondary,
                                      ),
                                    ),
                                  ),
                                ],

                                if (item.doctorNotes.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme
                                            .textSecondary,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Doctor Notes: ',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: item.doctorNotes,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

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