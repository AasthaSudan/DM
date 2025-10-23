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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadContacts();
    });
  }

  Future<void> _loadContacts() async {
    try {
      final dbService = Provider.of<DatabaseService>(context, listen: false);
      final currentUserId = 'someUserId'; // TODO: Replace with actual logged-in user ID
      await dbService.loadEmergencyContacts(currentUserId);
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLandscape = size.width > size.height;

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
                padding: EdgeInsets.all(isTablet ? 24.0 : 20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.emergency,
                      color: Colors.white,
                      size: isTablet ? 40 : 32,
                    ),
                    SizedBox(width: isTablet ? 16 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Contacts',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 28 : null,
                            ),
                          ),
                          Text(
                            'Quick access to important numbers',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                              fontSize: isTablet ? 16 : null,
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
                          margin: EdgeInsets.all(isTablet ? 24 : 20),
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 600 : double.infinity,
                          ),
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
                            labelStyle: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                            ),
                            tabs: [
                              Tab(
                                icon: Icon(Icons.local_phone, size: isTablet ? 28 : 24),
                                text: 'Emergency',
                              ),
                              Tab(
                                icon: Icon(Icons.contacts, size: isTablet ? 28 : 24),
                                text: 'Personal',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildEmergencyTab(isTablet, isLandscape),
                              _buildPersonalTab(isTablet, isLandscape),
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
        child: Icon(Icons.add, color: Colors.white, size: isTablet ? 28 : 24),
      ),
    );
  }

  Widget _buildEmergencyTab(bool isTablet, bool isLandscape) {
    if (isTablet || isLandscape) {
      return GridView.builder(
        padding: EdgeInsets.all(isTablet ? 24 : 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isLandscape ? 2 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isTablet ? 2.5 : 2.2,
        ),
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
            isTablet: isTablet,
          );
        },
      );
    }

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
          isTablet: false,
        );
      },
    );
  }

  Widget _buildPersonalTab(bool isTablet, bool isLandscape) {
    return Consumer<DatabaseService>(
      builder: (context, dbService, _) {
        final contacts = dbService.emergencyContacts;

        if (contacts.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 32 : 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21C573).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.contact_phone,
                        size: isTablet ? 80 : 60,
                        color: const Color(0xFF21C573),
                      ),
                    ),
                    SizedBox(height: isTablet ? 32 : 20),
                    Text(
                      'No Personal Contacts',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 28 : null,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Text(
                      'Add your family and friends for quick access',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: isTablet ? 18 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isTablet ? 32 : 24),
                    ElevatedButton.icon(
                      onPressed: _showAddContactDialog,
                      icon: Icon(Icons.add, size: isTablet ? 24 : 20),
                      label: Text(
                        'Add Contact',
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF21C573),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 24,
                          vertical: isTablet ? 16 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (isTablet || isLandscape) {
          return RefreshIndicator(
            onRefresh: _loadContacts,
            child: GridView.builder(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isLandscape ? 2 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isTablet ? 2.5 : 2.2,
              ),
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
                  isTablet: isTablet,
                );
              },
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
                isTablet: false,
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
        bool isTablet = false,
      }) {
    final iconSize = isTablet ? 60.0 : 50.0;
    final contentPadding = isTablet ? 20.0 : 16.0;

    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 0 : 12),
      child: Card(
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: EdgeInsets.all(contentPadding),
          child: isTablet
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 16,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildActionButtons(number, color, isEmergency, onDelete, isTablet),
                ],
              ),
            ],
          )
              : Row(
            children: [
              Container(
                width: iconSize,
                height: iconSize,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
              _buildActionButtons(number, color, isEmergency, onDelete, isTablet),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      String number, Color color, bool isEmergency, VoidCallback? onDelete, bool isTablet) {
    final buttonSize = isTablet ? 44.0 : 36.0;
    final iconSize = isTablet ? 22.0 : 20.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _makeCall(number),
            icon: Icon(Icons.phone, color: color, size: iconSize),
            tooltip: 'Call',
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _sendSMS(number),
            icon: Icon(Icons.message, color: Colors.blue, size: iconSize),
            tooltip: 'SMS',
            padding: EdgeInsets.zero,
          ),
        ),
        if (!isEmergency && onDelete != null) ...[
          const SizedBox(width: 8),
          Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete, color: Colors.red, size: iconSize),
              tooltip: 'Delete',
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ],
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
    final formKey = GlobalKey<FormState>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color: const Color(0xFF21C573).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_add,
                color: const Color(0xFF21C573),
                size: isTablet ? 28 : 24,
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Text(
              'Add Contact',
              style: TextStyle(fontSize: isTablet ? 22 : 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 500 : double.infinity,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      prefixIcon: Icon(Icons.person, size: isTablet ? 28 : 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      prefixIcon: Icon(Icons.phone, size: isTablet ? 28 : 24),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  TextFormField(
                    controller: relationshipController,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                    decoration: InputDecoration(
                      labelText: 'Relationship',
                      labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      prefixIcon: Icon(Icons.group, size: isTablet ? 28 : 24),
                      hintText: 'e.g., Family, Friend, Doctor',
                      hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isTablet ? 18 : 16),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                // Show loading indicator
                showDialog(
                  context: dialogContext,
                  barrierDismissible: false,
                  builder: (loadingContext) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  final dbService = Provider.of<DatabaseService>(context, listen: false);
                  final currentUserId = 'someUserId'; // TODO: Replace with actual user ID

                  final contactData = {
                    'name': nameController.text.trim(),
                    'number': numberController.text.trim(),
                    'relationship': relationshipController.text.trim().isEmpty
                        ? 'Contact'
                        : relationshipController.text.trim(),
                  };

                  debugPrint('Adding contact: $contactData');

                  await dbService.addEmergencyContact(currentUserId, contactData);

                  // Close loading dialog
                  if (mounted) Navigator.pop(dialogContext);
                  // Close add contact dialog
                  if (mounted) Navigator.pop(dialogContext);

                  // Reload contacts to show the new one
                  await _loadContacts();

                  if (mounted) {
                    _showSuccessSnackBar('Contact added successfully');
                  }
                } catch (e) {
                  debugPrint('Error adding contact: $e');
                  // Close loading dialog
                  if (mounted) Navigator.pop(dialogContext);
                  // Close add contact dialog
                  if (mounted) Navigator.pop(dialogContext);

                  if (mounted) {
                    _showErrorSnackBar('Failed to add contact: ${e.toString()}');
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C573),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 14 : 12,
              ),
            ),
            child: Text(
              'Add Contact',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteContact(String contactId) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Contact',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        content: Text(
          'Are you sure you want to delete this contact?',
          style: TextStyle(fontSize: isTablet ? 18 : 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(fontSize: isTablet ? 18 : 16),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Show loading indicator
              showDialog(
                context: dialogContext,
                barrierDismissible: false,
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                final dbService = Provider.of<DatabaseService>(context, listen: false);
                final currentUserId = 'someUserId'; // TODO: Replace with actual user ID

                await dbService.deleteEmergencyContact(currentUserId, contactId);

                // Close loading dialog
                if (mounted) Navigator.pop(dialogContext);
                // Close delete dialog
                if (mounted) Navigator.pop(dialogContext);

                // Reload contacts
                await _loadContacts();

                if (mounted) {
                  _showSuccessSnackBar('Contact deleted');
                }
              } catch (e) {
                debugPrint('Error deleting contact: $e');
                // Close loading dialog
                if (mounted) Navigator.pop(dialogContext);
                // Close delete dialog
                if (mounted) Navigator.pop(dialogContext);

                if (mounted) {
                  _showErrorSnackBar('Failed to delete contact: ${e.toString()}');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 24 : 20,
                vertical: isTablet ? 14 : 12,
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(fontSize: isTablet ? 18 : 16),
            ),
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
        duration: const Duration(seconds: 4),
      ),
    );
  }
}