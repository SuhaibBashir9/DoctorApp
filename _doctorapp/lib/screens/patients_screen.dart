import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import 'begin_consultation_screen.dart';
import 'patient_profile_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All Patients';

  final List<Patient> _patients = [
    Patient(id: 'PAT1042', name: 'Rahul Sharma', age: 28, gender: 'Male'),
    Patient(id: 'PAT1043', name: 'Priya Verma', age: 34, gender: 'Female'),
    Patient(id: 'PAT1044', name: 'Aman Khan', age: 40, gender: 'Male'),
    Patient(id: 'PAT1045', name: 'Sunita Devi', age: 52, gender: 'Female'),
    Patient(id: 'PAT1046', name: 'Vikram Singh', age: 45, gender: 'Male'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final filteredPatients = _patients.where((p) {
      return p.name.toLowerCase().contains(query) ||
          p.id.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Patients Directory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => _showAddPatientDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by patient name or PAT ID...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All Patients', 'In Queue', 'Follow-ups', 'Completed']
                      .map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: AppTheme.accentGreen,
                        checkmarkColor: AppTheme.primaryDarkGreen,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryDarkGreen
                              : AppTheme.textSecondary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.cardBorder,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Patient List
              Expanded(
                child: filteredPatients.isEmpty
                    ? const Center(
                        child: Text(
                          'No patients found',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredPatients.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final patient = filteredPatients[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                radius: 22,
                                backgroundColor: AppTheme.accentGreen,
                                child: const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryDarkGreen,
                                ),
                              ),
                              title: Text(
                                patient.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                'ID: ${patient.id}  •  ${patient.age} Y, ${patient.gender}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.play_circle_fill,
                                      color: AppTheme.primaryGreen,
                                      size: 28,
                                    ),
                                    tooltip: 'Begin Consultation',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BeginConsultationScreen(
                                            patientId: patient.id,
                                            patientName: patient.name,
                                            age: patient.age,
                                            gender: patient.gender,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Icon(Icons.chevron_right,
                                      color: AppTheme.textSecondary),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientProfileScreen(
                                      patientId: patient.id,
                                      patientName: patient.name,
                                      age: patient.age,
                                      gender: patient.gender,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Age'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _patients.add(
                    Patient(
                      id: 'PAT10${_patients.length + 42}',
                      name: nameController.text.trim(),
                      age: int.tryParse(ageController.text) ?? 30,
                      gender: 'Male',
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add Patient'),
          ),
        ],
      ),
    );
  }
}
