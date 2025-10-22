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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      // User Info Card
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildUserInfoCard(name, email, role, green, size),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Stats Section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildStatsSection(userData, green, blue, size),
                      ),

                      const SizedBox(height: 24),

                      // Section Header
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

                      // Role-specific Actions
                      _buildRoleActions(role, green, blue, size),

                      const SizedBox(height: 24),

                      // Settings Section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSettingsSection(context, size, green),
                      ),

                      const SizedBox(height: 20),

                      // Logout Button
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

  Widget _buildSliverAppBar(BuildContext context, Size size, Color green, Color blue, String name) {
    final firstName = name.split(' ').first;
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

  Widget _buildUserInfoCard(String name, String email, String role, Color green, Size size) {
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

  Widget _buildStatsSection(Map<String, dynamic> userData, Color green, Color blue, Size size) {
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
                  gradient: LinearGradient(colors: [green, green.withOpacity(0.7)]),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
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

          // Learning Progress
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

          // Safety Score
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
          {'title': 'Manage\nUsers', 'icon': Icons.group_rounded, 'color': const Color(0xFF3498DB)},
          {'title': 'Assign\nModules', 'icon': Icons.task_rounded, 'color': const Color(0xFF9B59B6)},
          {'title': 'View\nReports', 'icon': Icons.bar_chart_rounded, 'color': const Color(0xFF2ECC71)},
          {'title': 'Settings', 'icon': Icons.settings_rounded, 'color': const Color(0xFFE74C3C)},
        ];
        break;
      case 'parent':
        actions = [
          {'title': 'Child\nProgress', 'icon': Icons.child_care_rounded, 'color': const Color(0xFF4ECDC4)},
          {'title': 'Safety\nAlerts', 'icon': Icons.notifications_active_rounded, 'color': const Color(0xFFFF6B6B)},
          {'title': 'Contact\nTeachers', 'icon': Icons.message_rounded, 'color': const Color(0xFF95E1D3)},
        ];
        break;
      default:
        actions = [
          {'title': 'Complete\nModules', 'icon': Icons.menu_book_rounded, 'color': const Color(0xFF4ECDC4)},
          {'title': 'Safety\nDrills', 'icon': Icons.health_and_safety_rounded, 'color': const Color(0xFFFFBE0B)},
          {'title': 'Check\nScore', 'icon': Icons.trending_up_rounded, 'color': const Color(0xFF9B59B6)},
          {'title': 'Feedback', 'icon': Icons.feedback_rounded, 'color': const Color(0xFFFF6B6B)},
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening ${action['title'].replaceAll('\n', ' ')}...',
                      style: GoogleFonts.poppins(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
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
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
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

  Widget _buildSettingsSection(BuildContext context, Size size, Color green) {
    final settingsItems = [
      {'title': 'Edit Profile', 'icon': Icons.edit_rounded, 'trailing': Icons.chevron_right_rounded},
      {'title': 'Notifications', 'icon': Icons.notifications_rounded, 'trailing': Icons.chevron_right_rounded},
      {'title': 'Privacy', 'icon': Icons.lock_rounded, 'trailing': Icons.chevron_right_rounded},
      {'title': 'Help & Support', 'icon': Icons.help_rounded, 'trailing': Icons.chevron_right_rounded},
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
        children: settingsItems.asMap().entries.map((entry) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Opening ${item['title']}...',
                      style: GoogleFonts.poppins(),
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  border: !isLast
                      ? Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1))
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

  Widget _buildLogoutButton(BuildContext context, AuthService authService, Size size) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await authService.signOut();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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