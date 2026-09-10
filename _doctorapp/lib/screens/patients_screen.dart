import 'package:flutter/material.dart';

import '../models/patient.dart';
import '../theme/app_theme.dart';
import '../services/consultation_service.dart';
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

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();

    final filteredPatients = consultationService.patients.where((patient) {
      final matchesSearch =
          patient.name.toLowerCase().contains(query) ||
              patient.id.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All Patients') return true;

      final consultation = consultationService.allConsultations
          .where((item) => item.patientId == patient.id)
          .toList();

      if (consultation.isEmpty) return false;

      final item = consultation.first;

      switch (_selectedFilter) {
        case 'In Queue':
          return item.status == 'Waiting' && item.type != 'Follow-up';

        case 'Follow-ups':
          return item.status == 'Waiting' && item.type == 'Follow-up';

        case 'Completed':
          return item.status == 'Completed';

        default:
          return true;
      }
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
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by patient name or PAT ID...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.textSecondary,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'All Patients',
                    'In Queue',
                    'Follow-ups',
                    'Completed',
                  ].map((filter) {
                    final isSelected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) {
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
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
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

              Expanded(
                child: filteredPatients.isEmpty
                    ? const Center(
                  child: Text(
                    'No patients found',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                )
                    : ListView.separated(
                  itemCount: filteredPatients.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];

                    final consultation = consultationService
                        .allConsultations
                        .where(
                          (item) => item.patientId == patient.id,
                    )
                        .toList();

                    final item = consultation.isEmpty
                        ? null
                        : consultation.first;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.cardBorder,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
                            if (item?.status == 'Waiting')
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
                                      builder: (_) =>
                                          BeginConsultationScreen(
                                            patientId: patient.id,
                                            patientName: patient.name,
                                            age: patient.age,
                                            gender: patient.gender,
                                            consultationType: item!.type
                                          ),
                                    ),
                                  );
                                },
                              ),
                            if (item?.status == 'Completed')
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PatientProfileScreen(
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

    String gender = 'Male';
    String consultationType = 'General Consultation';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add New Patient'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: gender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            gender = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: consultationType,
                      decoration: const InputDecoration(
                        labelText: 'Consultation Type',
                      ),
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
                          setDialogState(() {
                            consultationType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final age = int.tryParse(
                      ageController.text.trim(),
                    );

                    if (name.isEmpty || age == null || age <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Enter a valid name and age.',
                          ),
                        ),
                      );
                      return;
                    }

                    final id =
                        'PAT${DateTime.now().millisecondsSinceEpoch}';

                    final patient = Patient(
                      id: id,
                      name: name,
                      age: age,
                      gender: gender,
                    );

                    consultationService.addPatient(
                      patient,
                      consultationType: consultationType,
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Add Patient'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}