import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialQualification;
  final String initialRegistrationNumber;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialQualification,
    required this.initialRegistrationNumber,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _qualificationController;
  late final TextEditingController _registrationController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName,
    );

    _qualificationController = TextEditingController(
      text: widget.initialQualification,
    );

    _registrationController = TextEditingController(
      text: widget.initialRegistrationNumber,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qualificationController.dispose();
    _registrationController.dispose();

    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final qualification = _qualificationController.text.trim();
    final registration = _registrationController.text.trim();

    if (name.isEmpty ||
        qualification.isEmpty ||
        registration.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all profile fields.'),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'name': name,
      'qualification': qualification,
      'registrationNumber': registration,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Doctor Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  hintText: 'Enter doctor name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _qualificationController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Qualification',
                  hintText: 'e.g. MBBS, MD (General Medicine)',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _registrationController,
                decoration: const InputDecoration(
                  labelText: 'Registration Number',
                  hintText: 'Enter registration number',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}