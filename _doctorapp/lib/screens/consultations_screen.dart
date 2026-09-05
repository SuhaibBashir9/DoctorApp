import 'package:flutter/material.dart';
import '../models/consultation_queue_item.dart';
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

  final List<ConsultationQueueItem> _queueItems = [
    ConsultationQueueItem(
      patientId: 'PAT1042',
      patientName: 'Rahul Sharma',
      age: 28,
      gender: 'M',
      type: 'General Consultation',
      status: 'Waiting',
      time: '09:42 AM',
    ),
    ConsultationQueueItem(
      patientId: 'PAT1043',
      patientName: 'Priya Verma',
      age: 34,
      gender: 'F',
      type: 'Follow-up',
      status: 'Waiting',
      time: '09:48 AM',
    ),
    ConsultationQueueItem(
      patientId: 'PAT1044',
      patientName: 'Aman Khan',
      age: 40,
      gender: 'M',
      type: 'General Consultation',
      status: 'Waiting',
      time: '09:55 AM',
    ),
  ];

  final List<ConsultationQueueItem> _completedItems = [
    ConsultationQueueItem(
      patientId: 'PAT1038',
      patientName: 'Karan Mehra',
      age: 31,
      gender: 'M',
      type: 'Follow-up',
      status: 'Completed',
      time: '09:15 AM',
    ),
    ConsultationQueueItem(
      patientId: 'PAT1039',
      patientName: 'Neha Gupta',
      age: 26,
      gender: 'F',
      type: 'General Consultation',
      status: 'Completed',
      time: '09:25 AM',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Consultations Overview'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Metrics Summary Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildStatCard('Total Today', '20', AppTheme.primaryGreen),
                  const SizedBox(width: 8),
                  _buildStatCard('In Queue', '08', Colors.orange.shade800),
                  const SizedBox(width: 8),
                  _buildStatCard('Completed', '12', Colors.blue.shade700),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'In Queue (08)'),
                  Tab(text: 'Completed Today (12)'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Queue List
                  ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _queueItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _queueItems[index];
                      return _buildConsultationCard(item, isQueue: true);
                    },
                  ),

                  // Completed List
                  ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _completedItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _completedItems[index];
                      return _buildConsultationCard(item, isQueue: false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.cardBorder),
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

  Widget _buildConsultationCard(ConsultationQueueItem item, {required bool isQueue}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.accentGreen,
            child: const Icon(Icons.person, color: AppTheme.primaryDarkGreen),
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
                const SizedBox(height: 2),
                Text(
                  'ID: ${item.patientId}  •  ${item.type}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.status} at ${item.time}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isQueue ? Colors.orange.shade800 : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (isQueue)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BeginConsultationScreen(
                      patientId: item.patientId,
                      patientName: item.patientName,
                      age: item.age,
                      gender: item.gender == 'M' ? 'Male' : 'Female',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Begin', style: TextStyle(fontSize: 12)),
            )
          else
            const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }
}
