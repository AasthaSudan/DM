import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'drill_page.dart';
import 'learning.dart';
import 'emergency_contacts_page.dart' hide DatabaseService;
import 'weather_alerts_page.dart';
import 'profile_page.dart'; // Profile page for all users

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
    int _currentIndex = 0;
    late PageController _pageController;
    late AnimationController _animationController;

    @override
    void initState() {
        super.initState();
        _pageController = PageController();
        _animationController = AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 800),
        )..forward();
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
        final role = authService.role; // student, parent, admin
        const green = Color(0xFF21C573);
        const blue = Color(0xFF1791B6);

        return Scaffold(
            body: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                    _homePage(context, role),
                    const ProfileScreen(userData: {},),
                ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                backgroundColor: Colors.white,
                selectedItemColor: green,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
                ],
                onTap: (index) {
                    setState(() => _currentIndex = index);
                    _pageController.jumpToPage(index);
                },
            ),
        );
    }

    Widget _homePage(BuildContext context, String role) {
        final size = MediaQuery.of(context).size;
        const green = Color(0xFF21C573);
        const blue = Color(0xFF1791B6);

        return Container(
            decoration: const BoxDecoration(
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
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                ),
                                child: ListView(
                                    padding: const EdgeInsets.all(20),
                                    children: [
                                        _buildProgressSection(context, size, green, blue),
                                        SizedBox(height: size.height * 0.03),
                                        _buildQuickActionsSection(context, size, green, blue, role),
                                    ],
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
                vertical: size.height * 0.015,
            ),
            child: Row(
                children: [
                    const SizedBox(width: 8),
                    Expanded(
                        child: Consumer<AuthService>(
                            builder: (context, auth, _) {
                                final name = auth.currentUser?.displayName ?? 'User';
                                final firstName = name.split(' ').first;
                                return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Text(
                                            'Hey, $firstName 👋',
                                            style: GoogleFonts.poppins(
                                                fontSize: size.width * 0.055,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                            ),
                                        ),
                                        SizedBox(height: size.height * 0.005),
                                        Text(
                                            'Stay safe. Stay prepared.',
                                            style: GoogleFonts.poppins(
                                                fontSize: size.width * 0.033,
                                                color: Colors.white.withOpacity(0.9),
                                                fontWeight: FontWeight.w400,
                                            ),
                                        ),
                                    ],
                                );
                            },
                        ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No new notifications')),
                                    );
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(size.width * 0.028),
                                    child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: size.width * 0.06),
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

                return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(size.width * 0.045),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: green.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(
                                children: [
                                    Container(
                                        padding: EdgeInsets.all(size.width * 0.025),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [green, green.withOpacity(0.8)]),
                                            borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(Icons.shield_rounded, color: Colors.white, size: size.width * 0.06),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Expanded(
                                        child: Text(
                                            'Your Progress',
                                            style: GoogleFonts.poppins(
                                                fontSize: size.width * 0.048,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.grey[800],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                            SizedBox(height: size.height * 0.02),
                            Row(
                                children: [
                                    Expanded(
                                        child: _statCard(label: 'Modules\nCompleted', value: '$modulesCompleted/5', icon: Icons.school_rounded, color: green, size: size),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Expanded(
                                        child: _statCard(label: 'Safety\nScore', value: '$safetyScore%', icon: Icons.trending_up_rounded, color: blue, size: size),
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
                {'title': 'Emergency\nContacts', 'icon': Icons.contact_phone_rounded, 'page': const EmergencyContactsPage()},
                {'title': 'Learning\nModules', 'icon': Icons.menu_book_rounded, 'page': const Learning(moduleType: 'earthquake')},
                {'title': 'Safety\nDrills', 'icon': Icons.health_and_safety_rounded, 'page': const DrillsPage()},
                {'title': 'Weather\nAlerts', 'icon': Icons.cloud_rounded, 'page': const WeatherAlertsPage()},
            ];
        } else if (role == 'parent') {
            actions = [
                {'title': 'Children\nProgress', 'icon': Icons.child_care_rounded, 'page': const Learning(moduleType: 'earthquake')},
                {'title': 'Emergency\nContacts', 'icon': Icons.contact_phone_rounded, 'page': const EmergencyContactsPage()},
            ];
        } else if (role == 'admin') {
            actions = [
                {'title': 'Manage\nUsers', 'icon': Icons.manage_accounts_rounded, 'page': const Learning(moduleType: 'earthquake')},
                {'title': 'Reports', 'icon': Icons.bar_chart_rounded, 'page': const Learning(moduleType: 'earthquake')},
            ];
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                    children: [
                        Container(
                            width: 4,
                            height: 22,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [green, blue], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.circular(2),
                            ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Text('Quick Actions', style: GoogleFonts.poppins(fontSize: size.width * 0.05, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                    ],
                ),
                SizedBox(height: size.height * 0.02),
                GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: size.width * 0.035,
                    mainAxisSpacing: size.width * 0.035,
                    childAspectRatio: 1.0,
                    children: actions.map((action) => _actionCard(context, action['title'], action['icon'], action['page'], size, green, blue)).toList(),
                ),
            ],
        );
    }

    Widget _actionCard(BuildContext context, String title, IconData icon, Widget page, Size size, Color green, Color blue) {
        return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                                padding: EdgeInsets.all(size.width * 0.035),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [green, blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [BoxShadow(color: green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
                                ),
                                child: Icon(icon, color: Colors.white, size: size.width * 0.07),
                            ),
                            SizedBox(height: size.height * 0.012),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                                child: Text(title, style: GoogleFonts.poppins(fontSize: size.width * 0.034, fontWeight: FontWeight.w600, color: Colors.grey[800]), textAlign: TextAlign.center),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _statCard({required String label, required String value, required IconData icon, required Color color, required Size size}) {
        return Container(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.03),
            decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2), width: 1.5)),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                        child: Icon(icon, color: color, size: size.width * 0.06),
                    ),
                    SizedBox(height: size.height * 0.008),
                    FittedBox(fit: BoxFit.scaleDown, child: Text(value, style: GoogleFonts.poppins(fontSize: size.width * 0.048, fontWeight: FontWeight.w700, color: color))),
                    SizedBox(height: size.height * 0.004),
                    Text(label, style: GoogleFonts.poppins(fontSize: size.width * 0.028, color: Colors.grey[600], fontWeight: FontWeight.w500, height: 1.2), textAlign: TextAlign.center),
                ],
            ),
        );
    }
}
