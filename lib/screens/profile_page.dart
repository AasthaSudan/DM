import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          const SizedBox(height: 15),
          const Text(
            'Aastha Sudan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Disaster Preparedness Volunteer',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _buildProfileCard(Icons.email, 'Email', 'aastha@example.com'),
          _buildProfileCard(Icons.phone, 'Phone', '+91 98765 43210'),
          _buildProfileCard(Icons.verified_user, 'Role', 'Registered User'),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logging out...')),
              );
              Navigator.pushReplacementNamed(context, '/auth');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C573),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(IconData icon, String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF21C573)),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
