import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  String _gender = 'M';
  String _consultationType = 'General Consultation';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _addPatient() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isEmpty || age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid name and age.'),
        ),
      );
      return;
    }

    final patient = Patient(
      id: 'PAT${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      age: age,
      gender: _gender,
    );

    consultationService.addPatient(
      patient,
      consultationType: _consultationType,
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Patient'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Enter patient name',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Age',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter age',
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: _gender,
                items: const [
                  DropdownMenuItem(
                    value: 'M',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'F',
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Consultation Type',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: _consultationType,
                items: const [
                  DropdownMenuItem(
                    value: 'General Consultation',
                    child: Text('General Consultation'),
                  ),
                  DropdownMenuItem(
                    value: 'Follow-up',
                    child: Text('Follow-up'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _consultationType = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addPatient,
                  child: const Text('Add Patient to Queue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}