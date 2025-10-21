import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final role = userData['role'] ?? 'student';
    final size = MediaQuery.of(context).size;
    const green = Color(0xFF21C573);
    const blue = Color(0xFF1791B6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Avatar & Name
            CircleAvatar(
              radius: size.width * 0.14,
              backgroundColor: green.withOpacity(0.2),
              child: Text(
                (userData['name'] ?? 'U')[0].toUpperCase(),
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.1,
                  color: green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              userData['name'] ?? 'User',
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Role: ${role[0].toUpperCase()}${role.substring(1)}',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),

            // Progress Card
            _buildProgressCard(userData, green, size),

            const SizedBox(height: 20),

            // Role-specific gamified actions
            _buildRoleActions(role, green, blue, size),
          ],
        ),
      ),
    );
  }

  // -------------------- PROGRESS CARD --------------------
  Widget _buildProgressCard(Map<String, dynamic> data, Color green, Size size) {
    final modulesCompleted = data['modulesCompleted'] ?? 0;
    final totalModules = data['totalModules'] ?? 5;
    final safetyScore = data['safetyScore'] ?? 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Your Progress', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: modulesCompleted / totalModules,
              minHeight: 12,
              backgroundColor: green.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(green),
            ),
            const SizedBox(height: 8),
            Text('$modulesCompleted / $totalModules Modules Completed',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: safetyScore / 100,
              minHeight: 12,
              backgroundColor: green.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(Colors.orange),
            ),
            const SizedBox(height: 8),
            Text('Safety Score: $safetyScore%',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  // -------------------- ROLE-SPECIFIC ACTIONS --------------------
  Widget _buildRoleActions(String role, Color green, Color blue, Size size) {
    List<Map<String, dynamic>> actions = [];

    switch (role) {
      case 'admin':
        actions = [
          {'title': 'Manage Users', 'icon': Icons.group_rounded},
          {'title': 'Assign Modules', 'icon': Icons.task_rounded},
          {'title': 'View Reports', 'icon': Icons.bar_chart_rounded},
          {'title': 'Settings', 'icon': Icons.settings_rounded},
        ];
        break;
      case 'parent':
        actions = [
          {'title': 'View Child Progress', 'icon': Icons.child_care_rounded},
          {'title': 'Safety Alerts', 'icon': Icons.notifications_active_rounded},
          {'title': 'Contact Teachers', 'icon': Icons.message_rounded},
        ];
        break;
      default:
        actions = [
          {'title': 'Complete Modules', 'icon': Icons.menu_book_rounded},
          {'title': 'Safety Drills', 'icon': Icons.health_and_safety_rounded},
          {'title': 'Check Score', 'icon': Icons.trending_up_rounded},
          {'title': 'Feedback', 'icon': Icons.feedback_rounded},
        ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + index * 150),
          curve: Curves.elasticOut,
          builder: (context, val, child) {
            return Transform.scale(scale: val, child: child);
          },
          child: Material(
            borderRadius: BorderRadius.circular(18),
            elevation: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                // TODO: Implement each action's navigation or functionality
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [green, blue]),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(action['icon'] as IconData, color: Colors.white, size: size.width * 0.12),
                    const SizedBox(height: 8),
                    Text(
                      action['title'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: size.width * 0.035),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
