// lib/screens/safety_checklist_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SafetyChecklistPage extends StatefulWidget {
  const SafetyChecklistPage({super.key});

  @override
  State<SafetyChecklistPage> createState() => _SafetyChecklistPageState();
}

class _SafetyChecklistPageState extends State<SafetyChecklistPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, List<ChecklistItem>> _checklists = {};
  Map<String, int> _completionStats = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeChecklists();
    _loadChecklistProgress();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeChecklists() {
    _checklists = {
      'emergency_kit': [
        ChecklistItem(
          id: 'ek_water',
          title: 'Water Supply',
          description: '1 gallon per person per day for 3 days',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_food',
          title: 'Non-perishable Food',
          description: '3-day supply of ready-to-eat food',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_flashlight',
          title: 'Flashlight & Extra Batteries',
          description: 'LED flashlight with backup batteries',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_radio',
          title: 'Battery-powered Radio',
          description: 'Weather radio with backup batteries',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_firstaid',
          title: 'First Aid Kit',
          description: 'Complete with medications and supplies',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_whistle',
          title: 'Whistle',
          description: 'To signal for help',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_masks',
          title: 'Dust Masks',
          description: 'N95 or surgical masks',
          category: 'emergency_kit',
        ),
        ChecklistItem(
          id: 'ek_tools',
          title: 'Basic Tools',
          description: 'Wrench, pliers, scissors, knife',
          category: 'emergency_kit',
        ),
      ],
      'home_safety': [
        ChecklistItem(
          id: 'hs_smoke',
          title: 'Smoke Detectors',
          description: 'Install on every floor and test monthly',
          category: 'home_safety',
        ),
        ChecklistItem(
          id: 'hs_extinguisher',
          title: 'Fire Extinguisher',
          description: 'Keep in kitchen and check annually',
          category: 'home_safety',
        ),
        ChecklistItem(
          id: 'hs_escape',
          title: 'Escape Plan',
          description: 'Create and practice evacuation routes',
          category: 'home_safety',
        ),
        ChecklistItem(
          id: 'hs_meeting',
          title: 'Meeting Point',
          description: 'Designate safe meeting location',
          category: 'home_safety',
        ),
        ChecklistItem(
          id: 'hs_utilities',
          title: 'Utility Shutoff',
          description: 'Know how to turn off gas, water, electricity',
          category: 'home_safety',
        ),
        ChecklistItem(
          id: 'hs_insurance',
          title: 'Insurance Documents',
          description: 'Keep copies in waterproof container',
          category: 'home_safety',
        ),
      ],
      'communication': [
        ChecklistItem(
          id: 'com_contacts',
          title: 'Emergency Contacts List',
          description: 'Family, friends, and emergency services',
          category: 'communication',
        ),
        ChecklistItem(
          id: 'com_outofstate',
          title: 'Out-of-State Contact',
          description: 'Designate someone outside your area',
          category: 'communication',
        ),
        ChecklistItem(
          id: 'com_phone',
          title: 'Charged Phone',
          description: 'Keep phone charged and have backup charger',
          category: 'communication',
        ),
        ChecklistItem(
          id: 'com_alerts',
          title: 'Emergency Alerts',
          description: 'Sign up for local emergency notifications',
          category: 'communication',
        ),
        ChecklistItem(
          id: 'com_radio',
          title: 'Emergency Radio',
          description: 'Battery or hand-crank emergency radio',
          category: 'communication',
        ),
      ],
      'important_docs': [
        ChecklistItem(
          id: 'doc_id',
          title: 'Identification Documents',
          description: 'Copies of ID cards, passports, driver\'s license',
          category: 'important_docs',
        ),
        ChecklistItem(
          id: 'doc_medical',
          title: 'Medical Records',
          description: 'Prescriptions, allergies, medical history',
          category: 'important_docs',
        ),
        ChecklistItem(
          id: 'doc_insurance',
          title: 'Insurance Policies',
          description: 'Health, home, auto insurance documents',
          category: 'important_docs',
        ),
        ChecklistItem(
          id: 'doc_bank',
          title: 'Bank Account Info',
          description: 'Account numbers and contact information',
          category: 'important_docs',
        ),
        ChecklistItem(
          id: 'doc_property',
          title: 'Property Documents',
          description: 'Deeds, rental agreements, vehicle titles',
          category: 'important_docs',
        ),
      ],
      'special_needs': [
        ChecklistItem(
          id: 'sn_medications',
          title: 'Prescription Medications',
          description: '7-day supply of essential medications',
          category: 'special_needs',
        ),
        ChecklistItem(
          id: 'sn_medical',
          title: 'Medical Equipment',
          description: 'Glasses, hearing aids, mobility devices',
          category: 'special_needs',
        ),
        ChecklistItem(
          id: 'sn_infant',
          title: 'Infant Supplies',
          description: 'Formula, diapers, bottles if applicable',
          category: 'special_needs',
        ),
        ChecklistItem(
          id: 'sn_pet',
          title: 'Pet Supplies',
          description: 'Food, water, medication for pets',
          category: 'special_needs',
        ),
        ChecklistItem(
          id: 'sn_elderly',
          title: 'Elderly Care Items',
          description: 'Special dietary needs, mobility aids',
          category: 'special_needs',
        ),
      ],
    };

    _updateCompletionStats();
  }

  Future<void> _loadChecklistProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('checklist_progress');

    if (savedData != null) {
      final Map<String, dynamic> decoded = json.decode(savedData);
      setState(() {
        decoded.forEach((key, value) {
          if (_checklists.containsKey(key)) {
            for (int i = 0; i < _checklists[key]!.length; i++) {
              if (i < (value as List).length) {
                _checklists[key]![i].isCompleted = value[i] as bool;
              }
            }
          }
        });
        _updateCompletionStats();
      });
    }
  }

  Future<void> _saveChecklistProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> saveData = {};

    _checklists.forEach((category, items) {
      saveData[category] = items.map((item) => item.isCompleted).toList();
    });

    await prefs.setString('checklist_progress', json.encode(saveData));
  }

  void _updateCompletionStats() {
    _completionStats.clear();
    _checklists.forEach((category, items) {
      int completed = items.where((item) => item.isCompleted).length;
      _completionStats[category] = ((completed / items.length) * 100).round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Navigation', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Safety Checklists'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SafetyChecklistPage()),
                );
              },
            ),
            // Add other menu items here
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF21C573), Color(0xFF1791B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Safety Checklist',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Track your emergency preparedness',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // White card with stats and tabs
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Overall stats
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF21C573).withOpacity(0.1),
                              const Color(0xFF1791B6).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOverallStat(
                              'Total Items',
                              _checklists.values.fold(0, (sum, items) => sum + items.length).toString(),
                              Icons.list_alt,
                            ),
                            Container(height: 40, width: 1, color: Colors.grey.shade300),
                            _buildOverallStat(
                              'Completed',
                              _checklists.values
                                  .fold(0, (sum, items) => sum + items.where((i) => i.isCompleted).length)
                                  .toString(),
                              Icons.check_circle,
                            ),
                            Container(height: 40, width: 1, color: Colors.grey.shade300),
                            _buildOverallStat(
                              'Progress',
                              '${_calculateOverallProgress()}%',
                              Icons.trending_up,
                            ),
                          ],
                        ),
                      ),

                      // Tabs
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: const Color(0xFF21C573),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF21C573),
                        tabs: const [
                          Tab(text: 'Emergency Kit'),
                          Tab(text: 'Home Safety'),
                          Tab(text: 'Communication'),
                          Tab(text: 'Documents'),
                          Tab(text: 'Special Needs'),
                        ],
                      ),

                      // Tab content
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildChecklistTab('emergency_kit'),
                            _buildChecklistTab('home_safety'),
                            _buildChecklistTab('communication'),
                            _buildChecklistTab('important_docs'),
                            _buildChecklistTab('special_needs'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF21C573), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF21C573),
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildChecklistTab(String category) {
    final items = _checklists[category] ?? [];
    final progress = _completionStats[category] ?? 0;

    return Column(
      children: [
        // Progress bar
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Completion', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  Text('$progress%', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF21C573))),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF21C573)),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildChecklistItem(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(ChecklistItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: item.isCompleted ? const Color(0xFF21C573).withOpacity(0.3) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: CheckboxListTile(
          value: item.isCompleted,
          onChanged: (value) {
            setState(() {
              item.isCompleted = value ?? false;
              _updateCompletionStats();
            });
            _saveChecklistProgress();
          },
          activeColor: const Color(0xFF21C573),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted ? Colors.grey : const Color(0xFF2C3E50),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              item.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.isCompleted ? const Color(0xFF21C573).withOpacity(0.1) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: item.isCompleted ? const Color(0xFF21C573) : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  int _calculateOverallProgress() {
    int totalItems = 0;
    int completedItems = 0;

    _checklists.forEach((category, items) {
      totalItems += items.length;
      completedItems += items.where((item) => item.isCompleted).length;
    });

    return totalItems > 0 ? ((completedItems / totalItems) * 100).round() : 0;
  }
}

class ChecklistItem {
  final String id;
  final String title;
  final String description;
  final String category;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
  });
}
