import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'drill_page.dart';
import 'learning.dart';
import 'emergency_contacts_page.dart' hide DatabaseService;
import 'weather_alerts_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
    int _currentIndex = 0;
    late PageController _pageController;
    late AnimationController _animationController;
    Animation<double>? _fadeAnimation;
    Animation<Offset>? _slideAnimation;

    @override
    void initState() {
        super.initState();
        _pageController = PageController();
        _animationController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1200),
        );

        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
        );

        _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic)),
        );

        _animationController.forward();
    }

    @override
    void dispose() {
        _pageController.dispose();
        _animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        final authService = Provider.of<AuthService>(context);
        final role = authService.role;
        const green = Color(0xFF21C573);

        return Scaffold(
            body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                    _homePage(context, role),
                    const ProfileScreen(userData: {},),
                ],
            ),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                        ),
                    ],
                ),
                child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    backgroundColor: Colors.white,
                    selectedItemColor: green,
                    unselectedItemColor: Colors.grey[400],
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
                    unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 11),
                    items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
                    ],
                    onTap: (index) {
                        setState(() => _currentIndex = index);
                        _pageController.jumpToPage(index);
                    },
                ),
            ),
        );
    }

    Widget _homePage(BuildContext context, String role) {
        final size = MediaQuery.of(context).size;
        const green = Color(0xFF21C573);
        const blue = Color(0xFF1791B6);

        return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [green, blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                ),
            ),
            child: SafeArea(
                child: Column(
                    children: [
                        _buildHeader(context, size, green),
                        Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                                ),
                                child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                                    child: ListView(
                                        padding: EdgeInsets.fromLTRB(20, size.height * 0.025, 20, 20),
                                        children: [
                                            FadeTransition(
                                                opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
                                                child: SlideTransition(
                                                    position: _slideAnimation ?? const AlwaysStoppedAnimation(Offset.zero),
                                                    child: _buildProgressSection(context, size, green, blue),
                                                ),
                                            ),
                                            SizedBox(height: size.height * 0.025),
                                            FadeTransition(
                                                opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1.0),
                                                child: _buildQuickActionsSection(context, size, green, blue, role),
                                            ),
                                        ],
                                    ),
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildHeader(BuildContext context, Size size, Color green) {
        return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
            ),
            child: Row(
                children: [
                    Expanded(
                        child: Consumer<AuthService>(
                            builder: (context, auth, _) {
                                final name = auth.currentUser?.displayName ?? 'User';
                                final firstName = name.split(' ').first;
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        FadeTransition(
                                            opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                                            child: Text(
                                                'Hey, $firstName 👋',
                                                style: GoogleFonts.poppins(
                                                    fontSize: size.width * 0.065,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                    letterSpacing: -0.5,
                                                ),
                                            ),
                                        ),
                                        SizedBox(height: size.height * 0.006),
                                        FadeTransition(
                                            opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                                            child: Text(
                                                'Stay safe. Stay prepared.',
                                                style: GoogleFonts.poppins(
                                                    fontSize: size.width * 0.036,
                                                    color: Colors.white.withOpacity(0.95),
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.2,
                                                ),
                                            ),
                                        ),
                                    ],
                                );
                            },
                        ),
                    ),
                    FadeTransition(
                        opacity: _fadeAnimation ?? AlwaysStoppedAnimation(1.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                            ),
                            child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text('No new notifications', style: GoogleFonts.poppins()),
                                                behavior: SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                        );
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.all(size.width * 0.032),
                                        child: Icon(
                                            Icons.notifications_none_rounded,
                                            color: Colors.white,
                                            size: size.width * 0.062,
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                ],
            ),
        );
    }

    Widget _buildProgressSection(BuildContext context, Size size, Color green, Color blue) {
        return Consumer<DatabaseService>(
            builder: (context, dbService, _) {
                final userData = dbService.userData;
                final modulesCompleted = userData?['modulesCompleted'] ?? 0;
                final safetyScore = userData?['safetyScore'] ?? 0;
                final progress = modulesCompleted / 5;

                return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.05),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.white.withOpacity(0.95)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                            BoxShadow(
                                color: green.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                            ),
                        ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                children: [
                                    Container(
                                        padding: EdgeInsets.all(size.width * 0.028),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [green, green.withOpacity(0.7)],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                            boxShadow: [
                                                BoxShadow(
                                                    color: green.withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                ),
                                            ],
                                        ),
                                        child: Icon(Icons.shield_rounded, color: Colors.white, size: size.width * 0.065),
                                    ),
                                    SizedBox(width: size.width * 0.035),
                                    Expanded(
                                        child: Text(
                                            'Your Progress',
                                            style: GoogleFonts.poppins(
                                                fontSize: size.width * 0.052,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[850],
                                                letterSpacing: -0.5,
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                            SizedBox(height: size.height * 0.02),

                            // Progress bar
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Text(
                                                'Learning Journey',
                                                style: GoogleFonts.poppins(
                                                    fontSize: size.width * 0.036,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[700],
                                                ),
                                            ),
                                            Text(
                                                '${(progress * 100).toInt()}%',
                                                style: GoogleFonts.poppins(
                                                    fontSize: size.width * 0.036,
                                                    fontWeight: FontWeight.w700,
                                                    color: green,
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height: size.height * 0.012),
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                            height: 12,
                                            child: LinearProgressIndicator(
                                                value: progress,
                                                backgroundColor: Colors.grey[200],
                                                valueColor: AlwaysStoppedAnimation(green),
                                            ),
                                        ),
                                    ),
                                ],
                            ),

                            SizedBox(height: size.height * 0.025),
                            Row(
                                children: [
                                    Expanded(
                                        child: _statCard(
                                            label: 'Modules\nCompleted',
                                            value: '$modulesCompleted/5',
                                            icon: Icons.school_rounded,
                                            color: green,
                                            size: size,
                                        ),
                                    ),
                                    SizedBox(width: size.width * 0.035),
                                    Expanded(
                                        child: _statCard(
                                            label: 'Safety\nScore',
                                            value: '$safetyScore%',
                                            icon: Icons.trending_up_rounded,
                                            color: blue,
                                            size: size,
                                        ),
                                    ),
                                ],
                            ),
                        ],
                    ),
                );
            },
        );
    }

    Widget _buildQuickActionsSection(BuildContext context, Size size, Color green, Color blue, String role) {
        List<Map<String, dynamic>> actions = [];

        if (role == 'student') {
            actions = [
                {'title': 'Emergency\nContacts', 'icon': Icons.contact_phone_rounded, 'page': const EmergencyContactsPage(), 'color': const Color(0xFFFF6B6B)},
                {'title': 'Learning\nModules', 'icon': Icons.menu_book_rounded, 'page': const Learning(moduleType: 'earthquake'), 'color': const Color(0xFF4ECDC4)},
                {'title': 'Safety\nDrills', 'icon': Icons.health_and_safety_rounded, 'page': const DrillsPage(), 'color': const Color(0xFFFFBE0B)},
                {'title': 'Weather\nAlerts', 'icon': Icons.cloud_rounded, 'page': const WeatherAlertsPage(), 'color': const Color(0xFF9B59B6)},
            ];
        } else if (role == 'parent') {
            actions = [
                {'title': 'Children\nProgress', 'icon': Icons.child_care_rounded, 'page': const Learning(moduleType: 'earthquake'), 'color': const Color(0xFF4ECDC4)},
                {'title': 'Emergency\nContacts', 'icon': Icons.contact_phone_rounded, 'page': const EmergencyContactsPage(), 'color': const Color(0xFFFF6B6B)},
            ];
        } else if (role == 'admin') {
            actions = [
                {'title': 'Manage\nUsers', 'icon': Icons.manage_accounts_rounded, 'page': const Learning(moduleType: 'earthquake'), 'color': const Color(0xFF3498DB)},
                {'title': 'Reports', 'icon': Icons.bar_chart_rounded, 'page': const Learning(moduleType: 'earthquake'), 'color': const Color(0xFF2ECC71)},
            ];
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
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
                SizedBox(height: size.height * 0.02),
                GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: size.width * 0.04,
                    mainAxisSpacing: size.width * 0.04,
                    childAspectRatio: 1.05,
                    children: actions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final action = entry.value;
                        return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 400 + (index * 100)),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) {
                                return Transform.scale(
                                    scale: value,
                                    child: _actionCard(
                                        context,
                                        action['title'],
                                        action['icon'],
                                        action['page'],
                                        action['color'],
                                        size,
                                    ),
                                );
                            },
                        );
                    }).toList(),
                ),
            ],
        );
    }

    Widget _actionCard(BuildContext context, String title, IconData icon, Widget page, Color actionColor, Size size) {
        return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                            ),
                        ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                                padding: EdgeInsets.all(size.width * 0.04),
                                decoration: BoxDecoration(
                                    color: actionColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(icon, color: actionColor, size: size.width * 0.08),
                            ),
                            SizedBox(height: size.height * 0.015),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
                                child: Text(
                                    title,
                                    style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.036,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                        height: 1.3,
                                    ),
                                    textAlign: TextAlign.center,
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _statCard({
        required String label,
        required String value,
        required IconData icon,
        required Color color,
        required Size size,
    }) {
        return Container(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.022,
                horizontal: size.width * 0.035,
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                        color.withOpacity(0.08),
                        color.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withOpacity(0.2), width: 1.5),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        padding: EdgeInsets.all(size.width * 0.024),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: color, size: size.width * 0.065),
                    ),
                    SizedBox(height: size.height * 0.01),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            value,
                            style: GoogleFonts.poppins(
                                fontSize: size.width * 0.052,
                                fontWeight: FontWeight.w700,
                                color: color,
                                letterSpacing: -0.5,
                            ),
                        ),
                    ),
                    SizedBox(height: size.height * 0.005),
                    Text(
                        label,
                        style: GoogleFonts.poppins(
                            fontSize: size.width * 0.03,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                    ),
                ],
            ),
        );
    }
}