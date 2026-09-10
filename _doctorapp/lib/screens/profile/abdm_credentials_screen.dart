import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AbdmCredentialsScreen extends StatefulWidget {
  const AbdmCredentialsScreen({super.key});

  @override
  State<AbdmCredentialsScreen> createState() =>
      _AbdmCredentialsScreenState();
}

class _AbdmCredentialsScreenState extends State<AbdmCredentialsScreen> {
  bool _credentialsVerified = true;
  bool _prescriptionsEnabled = true;

  final TextEditingController _abhaIdController =
  TextEditingController(text: 'Not linked');

  final TextEditingController _providerIdController =
  TextEditingController(text: 'Not added');

  @override
  void dispose() {
    _abhaIdController.dispose();
    _providerIdController.dispose();
    super.dispose();
  }

  void _saveCredentials() {
    final abhaId = _abhaIdController.text.trim();
    final providerId = _providerIdController.text.trim();

    if (abhaId.isEmpty || providerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the required fields.'),
        ),
      );
      return;
    }

    setState(() {
      _credentialsVerified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ABDM credentials saved successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('ABDM Credentials'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _credentialsVerified
                          ? Icons.verified
                          : Icons.warning_amber_rounded,
                      color: _credentialsVerified
                          ? AppTheme.primaryDarkGreen
                          : Colors.orange.shade800,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            _credentialsVerified
                                ? 'Credentials Verified'
                                : 'Credentials Not Verified',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _credentialsVerified
                                ? 'Your ABDM details are marked as active.'
                                : 'Complete your ABDM details below.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'ABDM Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: _abhaIdController,
                decoration: const InputDecoration(
                  labelText: 'ABHA ID',
                  hintText: 'Enter ABHA ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _providerIdController,
                decoration: const InputDecoration(
                  labelText: 'Healthcare Provider ID',
                  hintText: 'Enter provider ID',
                  prefixIcon: Icon(
                    Icons.local_hospital_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Prescription Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.cardBorder,
                  ),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Enable Digital Prescriptions',
                  ),
                  subtitle: const Text(
                    'Allow prescriptions to be prepared digitally.',
                  ),
                  value: _prescriptionsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _prescriptionsEnabled = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveCredentials,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save ABDM Settings'),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Actual ABDM verification and health-record integration '
                    'will be connected later through the required APIs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}