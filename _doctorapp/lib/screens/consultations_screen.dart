import 'package:flutter/material.dart';

import '../models/consultation_queue_item.dart';
import '../services/consultation_service.dart';
import '../theme/app_theme.dart';
import 'begin_consultation_screen.dart';

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});

  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );

    consultationService.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    consultationService.removeListener(_refresh);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueItems = consultationService.queueItems;
    final followUpItems = consultationService.followUpItems;
    final completedItems = consultationService.completedItems;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Consultations Overview'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Statistics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildStatCard(
                    'Total Today',
                    '${consultationService.totalCount}',
                    AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'In Queue',
                    '${consultationService.queueCount}',
                    Colors.orange.shade800,
                  ),
                  const SizedBox(width: 8),
                  _buildStatCard(
                    'Completed',
                    '${consultationService.completedCount}',
                    Colors.blue.shade700,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tabs
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
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppTheme.primaryDarkGreen,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                tabs: [
                  Tab(
                    text: 'In Queue (${queueItems.length})',
                  ),
                  Tab(
                    text: 'Follow-ups (${followUpItems.length})',
                  ),
                  Tab(
                    text: 'Completed (${completedItems.length})',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Lists
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildConsultationList(
                    queueItems,
                    isWaiting: true,
                  ),
                  _buildConsultationList(
                    followUpItems,
                    isWaiting: true,
                  ),
                  _buildConsultationList(
                    completedItems,
                    isWaiting: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationList(
      List<ConsultationQueueItem> items, {
        required bool isWaiting,
      }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWaiting
                  ? Icons.people_outline
                  : Icons.check_circle_outline,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isWaiting
                  ? 'No consultations here'
                  : 'No completed consultations',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _buildConsultationCard(
          items[index],
          isWaiting: isWaiting,
        );
      },
    );
  }

  Widget _buildStatCard(
      String label,
      String count,
      Color color,
      ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.cardBorder,
          ),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
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

  Widget _buildConsultationCard(
      ConsultationQueueItem item, {
        required bool isWaiting,
      }) {
    final isFollowUp = item.type == 'Follow-up';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.cardBorder,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.accentGreen,
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryDarkGreen,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.patientName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'ID: ${item.patientId}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.type,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isFollowUp
                        ? Colors.blue.shade700
                        : AppTheme.primaryDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.status} at ${item.time}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isWaiting
                        ? isFollowUp
                        ? Colors.blue.shade700
                        : Colors.orange.shade800
                        : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          if (isWaiting)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BeginConsultationScreen(
                      patientId: item.patientId,
                      patientName: item.patientName,
                      age: item.age,
                      gender: item.gender == 'M'
                          ? 'Male'
                          : 'Female',
                      consultationType: item.type,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Begin',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            )
          else
            const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}