import 'package:flutter/material.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      {'name': 'Fire Department', 'number': '101'},
      {'name': 'Police', 'number': '100'},
      {'name': 'Ambulance', 'number': '102'},
      {'name': 'Disaster Helpline', 'number': '108'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF21C573)),
            title: Text(
              contact['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Dial: ${contact['number']}'),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('Dialing ${contact['number']} (${contact['name']})...'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
