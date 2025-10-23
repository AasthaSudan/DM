import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _notificationsEnabled = true;
  bool _privacyMode = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Edit Profile Dialog
  void _showEditProfileDialog(BuildContext context, String currentName,
      String currentEmail) {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('Edit Profile',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.person_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email_rounded),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    'Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save changes
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile updated successfully!',
                          style: GoogleFonts.poppins()),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21C573),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Save', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  // Notifications Settings Dialog
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setDialogState) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Notification Settings',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        title: Text(
                            'Push Notifications', style: GoogleFonts.poppins()),
                        subtitle: Text('Receive alerts and updates',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        value: _notificationsEnabled,
                        activeColor: const Color(0xFF21C573),
                        onChanged: (value) {
                          setDialogState(() => _notificationsEnabled = value);
                          setState(() => _notificationsEnabled = value);
                        },
                      ),
                      SwitchListTile(
                        title: Text('Email Notifications',
                            style: GoogleFonts.poppins()),
                        subtitle: Text('Get updates via email',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        value: true,
                        activeColor: const Color(0xFF21C573),
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: GoogleFonts.poppins(
                          color: const Color(0xFF21C573))),
                    ),
                  ],
                ),
          ),
    );
  }

  // Privacy Settings Dialog
  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
            builder: (context, setDialogState) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Privacy Settings',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        title: Text(
                            'Private Mode', style: GoogleFonts.poppins()),
                        subtitle: Text('Hide profile from others',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        value: _privacyMode,
                        activeColor: const Color(0xFF21C573),
                        onChanged: (value) {
                          setDialogState(() => _privacyMode = value);
                          setState(() => _privacyMode = value);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.security_rounded),
                        title: Text(
                            'Change Password', style: GoogleFonts.poppins()),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.pop(context);
                          _showChangePasswordDialog(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                            Icons.delete_rounded, color: Colors.red),
                        title: Text('Delete Account',
                            style: GoogleFonts.poppins(color: Colors.red)),
                        trailing: const Icon(
                            Icons.chevron_right_rounded, color: Colors.red),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteAccountDialog(context);
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close', style: GoogleFonts.poppins(
                          color: const Color(0xFF21C573))),
                    ),
                  ],
                ),
          ),
    );
  }

  // Change Password Dialog
  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('Change Password',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    'Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password changed successfully!',
                          style: GoogleFonts.poppins()),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21C573),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Change', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  // Delete Account Dialog
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('Delete Account', style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.red)),
            content: Text(
              'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                    'Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Account deletion initiated',
                          style: GoogleFonts.poppins()),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Delete', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  // Help & Support Dialog
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: Text('Help & Support',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                      Icons.question_answer_rounded, color: Color(0xFF21C573)),
                  title: Text('FAQ', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                          'Opening FAQ...', style: GoogleFonts.poppins())),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                      Icons.chat_rounded, color: Color(0xFF21C573)),
                  title: Text('Live Chat', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                          'Starting chat...', style: GoogleFonts.poppins())),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                      Icons.email_rounded, color: Color(0xFF21C573)),
                  title: Text('Email Support', style: GoogleFonts.poppins()),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                          'Opening email...', style: GoogleFonts.poppins())),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close',
                    style: GoogleFonts.poppins(color: const Color(0xFF21C573))),
              ),
            ],
          ),
    );
  }

  // Role-specific action handlers
  void _handleRoleAction(BuildContext context, String role,
      String actionTitle) {
    switch (actionTitle.replaceAll('\n', ' ').toLowerCase()) {
      case 'manage users':
        _showManageUsersScreen(context);
        break;
      case 'assign modules':
        _showAssignModulesScreen(context);
        break;
      case 'view reports':
        _showReportsScreen(context);
        break;
      case 'child progress':
        _showChildProgressScreen(context);
        break;
      case 'safety alerts':
        _showSafetyAlertsScreen(context);
        break;
      case 'complete modules':
        _showModulesScreen(context);
        break;
      case 'safety drills':
        _showDrillsScreen(context);
        break;
      case 'check score':
        _showScoreScreen(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Opening $actionTitle...', style: GoogleFonts.poppins()),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  void _showManageUsersScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) =>
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Manage Users', style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 5,
                          itemBuilder: (context, index) =>
                              Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF21C573),
                                    child: Text('U${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ),
                                  title: Text('User ${index + 1}',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text('user${index + 1}@example.com',
                                      style: GoogleFonts.poppins(fontSize: 12)),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) =>
                                    [
                                      PopupMenuItem(child: Text('Edit',
                                          style: GoogleFonts.poppins())),
                                      PopupMenuItem(child: Text('Delete',
                                          style: GoogleFonts.poppins())),
                                    ],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showAssignModulesScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            child: Column(
              children: [
                Text('Assign Modules', style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        CheckboxListTile(
                          title: Text('Module ${index + 1}',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text('Safety topic ${index + 1}',
                              style: GoogleFonts.poppins(fontSize: 12)),
                          value: index % 2 == 0,
                          activeColor: const Color(0xFF21C573),
                          onChanged: (value) {},
                        ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'Modules assigned!', style: GoogleFonts.poppins())),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21C573),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Assign Selected', style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showReportsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Reports', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildReportCard('Total Users', '248', Icons.people_rounded,
                        Colors.blue),
                    const SizedBox(height: 12),
                    _buildReportCard('Completed Modules', '1,542',
                        Icons.check_circle_rounded, Colors.green),
                    const SizedBox(height: 12),
                    _buildReportCard(
                        'Avg Safety Score', '87%', Icons.trending_up_rounded,
                        Colors.orange),
                    const SizedBox(height: 12),
                    _buildReportCard(
                        'Active Drills', '12', Icons.emergency_rounded,
                        Colors.red),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildReportCard(String title, String value, IconData icon,
      Color color) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color)),
        title: Text(
            title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        trailing: Text(value, style: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }

  void _showChildProgressScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Child Progress', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Recent Activity', style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _buildProgressItem(
                        'Fire Safety Module', '100%', Colors.green),
                    _buildProgressItem(
                        'Earthquake Drill', '75%', Colors.orange),
                    _buildProgressItem('First Aid Basics', '50%', Colors.blue),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildProgressItem(String title, String progress, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight
            .w600)),
        trailing: Text(progress, style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700, color: color)),
      ),
    );
  }

  void _showSafetyAlertsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Safety Alerts', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                            Icons.warning_rounded, color: Colors.orange),
                        title: Text('Alert ${index + 1}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text('Safety notification details',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right_rounded),
                      ),
                    ),
              ),
            ),
      ),
    );
  }

  void _showModulesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Available Modules', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 5,
                itemBuilder: (context, index) =>
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF21C573),
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Module ${index + 1}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text('Learn about safety',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        trailing: const Icon(Icons.play_arrow_rounded),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Starting Module ${index +
                                1}', style: GoogleFonts.poppins())),
                          );
                        },
                      ),
                    ),
              ),
            ),
      ),
    );
  }

  void _showDrillsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Safety Drills', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: 4,
                itemBuilder: (context, index) =>
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(
                            Icons.emergency_rounded, color: Colors.red),
                        title: Text('Drill ${index + 1}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text('Emergency procedure',
                            style: GoogleFonts.poppins(fontSize: 12)),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF21C573)),
                          child: Text('Start',
                              style: GoogleFonts.poppins(fontSize: 12)),
                        ),
                      ),
                    ),
              ),
            ),
      ),
    );
  }

  void _showScoreScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              appBar: AppBar(
                title: Text('Your Score', style: GoogleFonts.poppins()),
                backgroundColor: const Color(0xFF21C573),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21C573).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Column(
                        children: [
                          Text('Overall Score',
                              style: GoogleFonts.poppins(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('87%', style: GoogleFonts.poppins(fontSize: 48,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF21C573))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildScoreDetail('Fire Safety', 95),
                    _buildScoreDetail('First Aid', 82),
                    _buildScoreDetail('Earthquake Safety', 85),
                    _buildScoreDetail('General Awareness', 86),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildScoreDetail(String title, int score) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                Text('$score%', style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF21C573))),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: score / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Color(0xFF21C573)),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    const green = Color(0xFF21C573);
    const blue = Color(0xFF1791B6);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer2<AuthService, DatabaseService>(
        builder: (context, authService, dbService, _) {
          final user = authService.currentUser;
          final userData = dbService.userData ?? widget.userData;
          final role = authService.role;
          final name = user?.displayName ?? userData['name'] ?? 'User';
          final email = user?.email ?? userData['email'] ?? '';

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, size, green, blue, name),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildUserInfoCard(
                              name, email, role, green, size),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStatsSection(userData, green, blue, size),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: 28,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [green, blue],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            SizedBox(width: size.width * 0.035),
                            Text(
                              'Quick Actions',
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.052,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[850],
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRoleActions(role, green, blue, size),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSettingsSection(
                            context, size, green, name, email),
                      ),
                      const SizedBox(height: 20),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildLogoutButton(context, authService, size),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Size size, Color green,
      Color blue, String name) {
    final firstName = name
        .split(' ')
        .first;
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

    return SliverAppBar(
      expandedHeight: size.height * 0.25,
      floating: false,
      pinned: true,
      backgroundColor: green,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [green, blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Hero(
                    tag: 'profile_avatar',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: size.width * 0.12,
                        backgroundColor: Colors.white,
                        child: Text(
                          initial,
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.1,
                            color: green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(String name, String email, String role, Color green,
      Size size) {
    return Container(
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.058,
              fontWeight: FontWeight.w700,
              color: Colors.grey[850],
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            email,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.036,
              color: Colors.grey[600],
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [green.withOpacity(0.1), green.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: green.withOpacity(0.3), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_rounded, color: green, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${role[0].toUpperCase()}${role.substring(1)}',
                  style: GoogleFonts.poppins(
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.w600,
                    color: green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> userData, Color green,
      Color blue, Size size) {
    final modulesCompleted = userData['modulesCompleted'] ?? 0;
    final totalModules = userData['totalModules'] ?? 5;
    final safetyScore = userData['safetyScore'] ?? 0;
    final progress = modulesCompleted / totalModules;

    return Container(
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [green, green.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                    Icons.bar_chart_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                'Statistics',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.048,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[850],
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learning Progress',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$modulesCompleted/$totalModules',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w700,
                  color: green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(green),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Safety Score',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$safetyScore%',
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.w700,
                  color: blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: safetyScore / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleActions(String role, Color green, Color blue, Size size) {
    List<Map<String, dynamic>> actions = [];

    switch (role) {
      case 'admin':
        actions = [
          {
            'title': 'Manage\nUsers',
            'icon': Icons.group_rounded,
            'color': const Color(0xFF3498DB)
          },
          {
            'title': 'Assign\nModules',
            'icon': Icons.task_rounded,
            'color': const Color(0xFF9B59B6)
          },
          {
            'title': 'View\nReports',
            'icon': Icons.bar_chart_rounded,
            'color': const Color(0xFF2ECC71)
          },
          {
            'title': 'Settings',
            'icon': Icons.settings_rounded,
            'color': const Color(0xFFE74C3C)
          },
        ];
        break;
      case 'parent':
        actions = [
          {
            'title': 'Child\nProgress',
            'icon': Icons.child_care_rounded,
            'color': const Color(0xFF4ECDC4)
          },
          {
            'title': 'Safety\nAlerts',
            'icon': Icons.notifications_active_rounded,
            'color': const Color(0xFFFF6B6B)
          },
          {
            'title': 'Contact\nTeachers',
            'icon': Icons.message_rounded,
            'color': const Color(0xFF95E1D3)
          },
        ];
        break;
      default:
        actions = [
          {
            'title': 'Complete\nModules',
            'icon': Icons.menu_book_rounded,
            'color': const Color(0xFF4ECDC4)
          },
          {
            'title': 'Safety\nDrills',
            'icon': Icons.health_and_safety_rounded,
            'color': const Color(0xFFFFBE0B)
          },
          {
            'title': 'Check\nScore',
            'icon': Icons.trending_up_rounded,
            'color': const Color(0xFF9B59B6)
          },
          {
            'title': 'Feedback',
            'icon': Icons.feedback_rounded,
            'color': const Color(0xFFFF6B6B)
          },
        ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: size.width * 0.04,
        crossAxisSpacing: size.width * 0.04,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () =>
                  _handleRoleAction(context, role, action['title'] as String),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: action['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'],
                        size: size.width * 0.08,
                      ),
                    ),
                    SizedBox(height: size.height * 0.012),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025),
                      child: Text(
                        action['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.3,
                        ),
                      ),
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

  Widget _buildSettingsSection(BuildContext context, Size size, Color green,
      String name, String email) {
    final settingsItems = [
      {
        'title': 'Edit Profile',
        'icon': Icons.edit_rounded,
        'trailing': Icons.chevron_right_rounded,
        'action': 'edit'
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications_rounded,
        'trailing': Icons.chevron_right_rounded,
        'action': 'notifications'
      },
      {
        'title': 'Privacy',
        'icon': Icons.lock_rounded,
        'trailing': Icons.chevron_right_rounded,
        'action': 'privacy'
      },
      {
        'title': 'Help & Support',
        'icon': Icons.help_rounded,
        'trailing': Icons.chevron_right_rounded,
        'action': 'help'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: settingsItems
            .asMap()
            .entries
            .map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == settingsItems.length - 1;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? const Radius.circular(20) : Radius.zero,
                bottom: isLast ? const Radius.circular(20) : Radius.zero,
              ),
              onTap: () {
                switch (item['action']) {
                  case 'edit':
                    _showEditProfileDialog(context, name, email);
                    break;
                  case 'notifications':
                    _showNotificationsDialog(context);
                    break;
                  case 'privacy':
                    _showPrivacyDialog(context);
                    break;
                  case 'help':
                    _showHelpDialog(context);
                    break;
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: !isLast
                      ? Border(bottom: BorderSide(color: Colors.grey[200]!,
                      width: 1))
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: green,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Icon(
                      item['trailing'] as IconData,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthService authService,
      Size size) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) =>
                AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Text('Logout',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel',
                          style: GoogleFonts.poppins(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Logout',
                          style: GoogleFonts.poppins(color: Colors.red)),
                    ),
                  ],
                ),
          );

          if (confirm == true) {
            await authService.signOut();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (route) => false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: size.width * 0.042,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}