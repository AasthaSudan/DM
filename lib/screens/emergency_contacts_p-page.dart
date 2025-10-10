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
  bool _sortByName = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    await dbService.loadEmergencyContacts();
    setState(() {});
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
                    borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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

  // 🔹 Header
  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        const Icon(Icons.emergency, color: Colors.white, size: 32),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emergency Contacts',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Text('Quick access to important numbers',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
      ],
    ),
  );

  // 🔹 Tabs
  Widget _buildTabBar() => Container(
    margin: const EdgeInsets.all(20),
    decoration:
    BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
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

  // 🔹 Emergency Tab
  Widget _buildEmergencyTab() => ListView.builder(
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

  // 🔹 Personal Tab
  Widget _buildPersonalTab() => Consumer<DatabaseService>(
    builder: (context, dbService, _) {
      List contacts = dbService.emergencyContacts
          .where((c) =>
      c['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c['relationship']!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

      if (_sortByName) {
        contacts.sort((a, b) => a['name']!.compareTo(b['name']!));
      } else {
        contacts.sort((a, b) => a['relationship']!.compareTo(b['relationship']!));
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or relationship',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(_sortByName ? Icons.sort_by_alpha : Icons.filter_list),
                  onPressed: () => setState(() => _sortByName = !_sortByName),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: contacts.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: _loadContacts,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Dismissible(
                    key: Key(contact['id']!),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.phone, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _makeCall(contact['number']!);
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        _deleteContact(contact['id']!);
                        return false;
                      }
                      return false;
                    },
                    child: _buildContactCard(
                      contact['name']!,
                      contact['number']!,
                      contact['relationship']!,
                      Icons.person,
                      const Color(0xFF21C573),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    },
  );

  // 🔹 Contact Card
  Widget _buildContactCard(String name, String number, String type, IconData icon, Color color,
      {bool isEmergency = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(type),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Color(0xFF21C573)),
          onPressed: () => _makeCall(number),
        ),
      ),
    );
  }

  // 🔹 Empty State
  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.contact_phone, size: 60, color: Color(0xFF21C573)),
        const SizedBox(height: 20),
        const Text('No Personal Contacts Added'),
      ],
    ),
  );

  // 🔹 Add Contact Dialog
  Future<void> _showAddContactDialog() async {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final relationshipController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: numberController, decoration: const InputDecoration(labelText: 'Phone Number')),
            TextField(controller: relationshipController, decoration: const InputDecoration(labelText: 'Relationship')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF21C573)),
            onPressed: () async {
              if (nameController.text.isEmpty || numberController.text.isEmpty) {
                _showErrorSnackBar('Please fill all fields');
                return;
              }
              await Provider.of<DatabaseService>(context, listen: false).addEmergencyContact(
                nameController.text,
                numberController.text,
                relationshipController.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
                _showSuccessSnackBar('Contact added successfully');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 🔹 Utility Functions
  Future<void> _makeCall(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showErrorSnackBar('Could not make the call');
    }
  }

  Future<void> _deleteContact(String id) async {
    await Provider.of<DatabaseService>(context, listen: false).deleteEmergencyContact(id);
    _showSuccessSnackBar('Contact deleted');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFF21C573)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  IconData _getServiceIcon(String key) {
    switch (key) {
      case 'emergency':
        return Icons.warning_amber_rounded;
      case 'shield':
        return Icons.shield;
      case 'fire':
        return Icons.local_fire_department;
      case 'security':
        return Icons.local_police;
      case 'medical':
        return Icons.local_hospital;
      case 'support':
        return Icons.support_agent;
      default:
        return Icons.phone;
    }
  }
}
