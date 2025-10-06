// lib/screens/emergency_contacts_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/database_service.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final List<Map<String, String>> _emergencyServices = [
    {'name': 'Emergency Services', 'number': '911', 'type': 'Police/Fire/Ambulance', 'icon': 'emergency'},
    {'name': 'Disaster Management', 'number': '1078', 'type': 'National Disaster Response', 'icon': 'shield'},
    {'name': 'Fire Department', 'number': '101', 'type': 'Fire Emergency', 'icon': 'fire'},
    {'name': 'Police', 'number': '100', 'type': 'Police Emergency', 'icon': 'security'},
    {'name': 'Ambulance', 'number': '108', 'type': 'Medical Emergency', 'icon': 'medical'},
    {'name': 'Women Helpline', 'number': '1091', 'type': 'Women Emergency', 'icon': 'support'},
  ];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    await dbService.loadEmergencyContacts();
    setState(() {}); // refresh after loading
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        _buildTabBar(),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildEmergencyTab(),
                              _buildPersonalTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog,
        backgroundColor: const Color(0xFF21C573),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const Icon(Icons.emergency, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contacts',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Quick access to important numbers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: const TabBar(
        indicator: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF21C573), Color(0xFF1791B6)]),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(icon: Icon(Icons.local_phone), text: 'Emergency'),
          Tab(icon: Icon(Icons.contacts), text: 'Personal'),
        ],
      ),
    );
  }

  Widget _buildEmergencyTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _emergencyServices.length,
      itemBuilder: (context, index) {
        final service = _emergencyServices[index];
        return _buildContactCard(
          service['name']!,
          service['number']!,
          service['type']!,
          _getServiceIcon(service['icon']!),
          const Color(0xFFE74C3C),
          isEmergency: true,
        );
      },
    );
  }

  Widget _buildPersonalTab() {
    return Consumer<DatabaseService>(
      builder: (context, dbService, _) {
        final contacts = dbService.emergencyContacts
            .where((c) => c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

        if (contacts.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _loadContacts,
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _buildContactCard(
                contact['name']!,
                contact['number']!,
                contact['relationship']!,
                Icons.person,
                const Color(0xFF21C573),
                onDelete: () => _deleteContact(contact['id']!),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0xFF21C573).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.contact_phone, size: 60, color: Color(0xFF21C573)),
          ),
          const SizedBox(height: 20),
          Text(
            'No Personal Contacts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your family and friends for quick access',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddContactDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Contact'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C573),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

// Remaining helper methods (_buildContactCard, _makeCall, _sendSMS, _showAddContactDialog, _deleteContact, _showSuccessSnackBar, _showErrorSnackBar, _getServiceIcon) remain the same as in your current code.
}
