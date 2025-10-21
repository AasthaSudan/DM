import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationsScreen({super.key, this.notifications = const [
    {'title': 'New Module Available', 'time': '1h ago'},
    {'title': 'Safety Drill Scheduled', 'time': '3h ago'},
    {'title': 'Weather Alert: Rain', 'time': '5h ago'},
  ]});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF21C573);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final note = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(Icons.notifications, color: green),
              title: Text(note['title']!, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              trailing: Text(note['time']!, style: GoogleFonts.poppins(color: Colors.grey[600])),
            ),
          );
        },
      ),
    );
  }
}
