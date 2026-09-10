import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final bool initialQueueAlerts;
  final bool initialConsultationReminders;
  final bool initialFollowUpReminders;
  final bool initialSystemNotifications;

  const NotificationSettingsScreen({
    super.key,
    required this.initialQueueAlerts,
    required this.initialConsultationReminders,
    required this.initialFollowUpReminders,
    required this.initialSystemNotifications,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late bool _queueAlerts;
  late bool _consultationReminders;
  late bool _followUpReminders;
  late bool _systemNotifications;

  @override
  void initState() {
    super.initState();

    _queueAlerts = widget.initialQueueAlerts;
    _consultationReminders = widget.initialConsultationReminders;
    _followUpReminders = widget.initialFollowUpReminders;
    _systemNotifications = widget.initialSystemNotifications;
  }

  void _saveSettings() {
    Navigator.pop(
      context,
      {
        'queueAlerts': _queueAlerts,
        'consultationReminders': _consultationReminders,
        'followUpReminders': _followUpReminders,
        'systemNotifications': _systemNotifications,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifications & Alerts'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notification Preferences',
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
                    _buildSwitchTile(
                      title: 'Patient Queue Alerts',
                      subtitle:
                      'Get notified when patients are waiting.',
                      icon: Icons.people_outline,
                      value: _queueAlerts,
                      onChanged: (value) {
                        setState(() {
                          _queueAlerts = value;
                        });
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: AppTheme.cardBorder,
                    ),

                    _buildSwitchTile(
                      title: 'Consultation Reminders',
                      subtitle:
                      'Receive reminders for upcoming consultations.',
                      icon: Icons.event_outlined,
                      value: _consultationReminders,
                      onChanged: (value) {
                        setState(() {
                          _consultationReminders = value;
                        });
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: AppTheme.cardBorder,
                    ),

                    _buildSwitchTile(
                      title: 'Follow-up Reminders',
                      subtitle:
                      'Get reminders about patient follow-ups.',
                      icon: Icons.history,
                      value: _followUpReminders,
                      onChanged: (value) {
                        setState(() {
                          _followUpReminders = value;
                        });
                      },
                    ),

                    const Divider(
                      height: 1,
                      color: AppTheme.cardBorder,
                    ),

                    _buildSwitchTile(
                      title: 'System Notifications',
                      subtitle:
                      'Receive important app and security updates.',
                      icon: Icons.notifications_outlined,
                      value: _systemNotifications,
                      onChanged: (value) {
                        setState(() {
                          _systemNotifications = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSettings,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Notification Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.accentGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryDarkGreen,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}