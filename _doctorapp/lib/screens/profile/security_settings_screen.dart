import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController =
  TextEditingController();

  bool _pinEnabled = false;
  bool _biometricEnabled = false;
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _saveSecuritySettings() {
    final pin = _pinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (_pinEnabled) {
      if (!RegExp(r'^\d{4,6}$').hasMatch(pin)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN must contain 4 to 6 digits.'),
          ),
        );
        return;
      }

      if (pin != confirmPin) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PINs do not match.'),
          ),
        );
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Security settings saved successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Security & PIN'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security',
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
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Enable PIN Lock',
                      ),
                      subtitle: const Text(
                        'Require a PIN when opening the app.',
                      ),
                      value: _pinEnabled,
                      onChanged: (value) {
                        setState(() {
                          _pinEnabled = value;

                          if (!value) {
                            _pinController.clear();
                            _confirmPinController.clear();
                          }
                        });
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: AppTheme.cardBorder,
                    ),
                    SwitchListTile(
                      title: const Text(
                        'Biometric Lock',
                      ),
                      subtitle: const Text(
                        'Use fingerprint or device biometrics.',
                      ),
                      value: _biometricEnabled,
                      onChanged: _pinEnabled
                          ? (value) {
                        setState(() {
                          _biometricEnabled = value;
                        });
                      }
                          : null,
                    ),
                  ],
                ),
              ),

              if (_pinEnabled) ...[
                const SizedBox(height: 24),

                const Text(
                  'Set PIN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: _obscurePin,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    hintText: 'Enter 4-6 digit PIN',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePin = !_obscurePin;
                        });
                      },
                      icon: Icon(
                        _obscurePin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: _confirmPinController,
                  keyboardType: TextInputType.number,
                  obscureText: _obscureConfirmPin,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: 'Confirm PIN',
                    hintText: 'Re-enter your PIN',
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPin =
                          !_obscureConfirmPin;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPin
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSecuritySettings,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Security Settings'),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Biometric authentication uses the security features '
                    'available on the device. Actual persistent PIN storage '
                    'will be added later.',
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