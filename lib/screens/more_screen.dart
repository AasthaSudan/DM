import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreScreen extends StatelessWidget {
  final void Function()? onLogout;

  const MoreScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF21C573);

    final List<Map<String, dynamic>> options = [
      {'title': 'Settings', 'icon': Icons.settings_rounded, 'action': () {}},
      {'title': 'Help & Support', 'icon': Icons.help_rounded, 'action': () {}},
      {'title': 'About', 'icon': Icons.info_rounded, 'action': () {}},
      {'title': 'Logout', 'icon': Icons.logout_rounded, 'action': onLogout ?? () {}},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('More', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: green,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final Map<String, dynamic> item = options[index];
          return InkWell(
            onTap: () {
              final action = item['action'] as void Function()?;
              action?.call();
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  Icon(item['icon'] as IconData, color: green),
                  const SizedBox(width: 12),
                  Text(item['title'] as String, style: GoogleFonts.poppins(fontSize: 16)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
