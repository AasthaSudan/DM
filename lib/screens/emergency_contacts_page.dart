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
    {
      'name': 'Emergency Services',
      'number': '911',
      'type': 'Police/Fire/Ambulance',
      'icon': 'emergency',
    },
    {
      'name': 'Disaster Management',
      'number': '1078',
      'type': 'National Disaster Response',
      'icon': 'shield',
    },
    {
      'name': 'Fire Department',
      'number': '101',
      'type': 'Fire Emergency',
      'icon': 'fire',
    },
    {
      'name': 'Police',
      'number': '100',
      'type': 'Police Emergency',
      'icon': 'security',
    },
    {
      'name': 'Ambulance',
      'number': '108',
      'type': 'Medical Emergency',
      'icon': 'medical',
    },
    {
      'name': 'Women Helpline',
      'number': '1091',
      'type': 'Women Emergency',
      'icon': 'support',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final currentUserId = 'someUserId'; // TODO: Replace with actual logged-in user ID
    await dbService.loadEmergencyContacts(currentUserId);
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
              Padding(
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
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey.shade600,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(icon: Icon(Icons.local_phone), text: 'Emergency'),
                              Tab(icon: Icon(Icons.contacts), text: 'Personal'),
                            ],
                          ),
                        ),
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
        final contacts = dbService.emergencyContacts;

        if (contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF21C573).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.contact_phone,
                    size: 60,
                    color: Color(0xFF21C573),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'No Personal Contacts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add your family and friends for quick access',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
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

  Widget _buildContactCard(
      String name,
      String number,
      String type,
      IconData icon,
      Color color, {
        bool isEmergency = false,
        VoidCallback? onDelete,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _makeCall(number),
                      icon: Icon(Icons.phone, color: color, size: 20),
                      tooltip: 'Call',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () => _sendSMS(number),
                      icon: const Icon(Icons.message, color: Colors.blue, size: 20),
                      tooltip: 'SMS',
                    ),
                  ),
                  if (!isEmergency && onDelete != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        tooltip: 'Delete',
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getServiceIcon(String iconType) {
    switch (iconType) {
      case 'emergency':
        return Icons.emergency;
      case 'shield':
        return Icons.shield;
      case 'fire':
        return Icons.local_fire_department;
      case 'security':
        return Icons.security;
      case 'medical':
        return Icons.medical_services;
      case 'support':
        return Icons.support_agent;
      default:
        return Icons.phone;
    }
  }

  Future<void> _makeCall(String number) async {
    final url = Uri.parse('tel:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorSnackBar('Could not make call to $number');
    }
  }

  Future<void> _sendSMS(String number) async {
    final url = Uri.parse('sms:$number');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorSnackBar('Could not send SMS to $number');
    }
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final relationshipController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF21C573).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_add, color: Color(0xFF21C573)),
            ),
            const SizedBox(width: 12),
            const Text('Add Contact'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: relationshipController,
              decoration: InputDecoration(
                labelText: 'Relationship',
                prefixIcon: const Icon(Icons.group),
                hintText: 'e.g., Family, Friend, Doctor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && numberController.text.isNotEmpty) {
                final dbService = Provider.of<DatabaseService>(context, listen: false);
                final currentUserId = 'someUserId'; // TODO: Replace with actual user ID

                try {
                  await dbService.addEmergencyContact(
                    currentUserId,
                    {
                      'name': nameController.text,
                      'number': numberController.text,
                      'relationship': relationshipController.text.isEmpty
                          ? 'Contact'
                          : relationshipController.text,
                    },
                  );
                  Navigator.pop(context);
                  _showSuccessSnackBar('Contact added successfully');
                } catch (_) {
                  Navigator.pop(context);
                  _showErrorSnackBar('Failed to add contact');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C573),
            ),
            child: const Text('Add Contact'),
          ),
        ],
      ),
    );
  }

  void _deleteContact(String contactId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final dbService = Provider.of<DatabaseService>(context, listen: false);
              final currentUserId = 'someUserId'; // TODO: Replace with actual user ID

              try {
                await dbService.deleteEmergencyContact(currentUserId, contactId);
                Navigator.pop(context);
                _showSuccessSnackBar('Contact deleted');
              } catch (_) {
                Navigator.pop(context);
                _showErrorSnackBar('Failed to delete contact');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF21C573),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
