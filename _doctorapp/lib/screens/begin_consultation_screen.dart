import 'package:flutter/material.dart';
import '../models/consultation_history.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';
import '../widgets/live_consultation_form.dart';
import '../widgets/patient_info_header.dart';
import '../widgets/previous_consultations_view.dart';

class BeginConsultationScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final int age;
  final String gender;
  final String consultationType;

  const BeginConsultationScreen({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
    this.consultationType = 'General Consultation',
  });

  @override
  State<BeginConsultationScreen> createState() =>
      _BeginConsultationScreenState();
}

class _BeginConsultationScreenState extends State<BeginConsultationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _completeConsultation(ConsultationHistory history) {
    // Save the consultation history.
    consultationService.addConsultationHistory(history);

    // Move the patient from Waiting to Completed.
    consultationService.completeConsultation(widget.patientId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Consultation completed successfully!'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Begin Consultation'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'cancel') {
                Navigator.pop(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'patient_history',
                  child: Text('Full Medical History'),
                ),
                const PopupMenuItem(
                  value: 'cancel',
                  child: Text('Cancel Consultation'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: PatientInfoHeader(
                patientId: widget.patientId,
                patientName: widget.patientName,
                age: widget.age,
                gender: widget.gender,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppTheme.primaryDarkGreen,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.all(4),
                tabs: const [
                  Tab(text: 'Live Consultation'),
                  Tab(text: 'Previous Consultations'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Live Consultation
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: LiveConsultationForm(
                      patientId: widget.patientId,
                      visitType: widget.consultationType,
                      onComplete: _completeConsultation,
                    ),
                  ),

                  // Previous Consultations
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: PreviousConsultationsView(
                      patientId: widget.patientId,
                      showHeader: false,
                    ),
                  ),

                  // Private Notes
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Doctor Private Notes',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: _notesController,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText:
                            'Type any internal or temporary notes for this session here...',
                          ),
                        ),

                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Notes saved successfully',
                                ),
                              ),
                            );
                          },
                          child: const Text('Save Notes'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}