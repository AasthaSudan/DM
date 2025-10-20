import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'drill_page.dart';
import 'learning.dart';
import 'emergency_contacts_page.dart' hide DatabaseService;

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _currentIndex = 0;

    // Refresh user data and module progress
    Future<void> _refreshData(BuildContext context) async {
        final dbService = Provider.of<DatabaseService>(context, listen: false);
        final authService = Provider.of<AuthService>(context, listen: false);
        final currentUser = authService.currentUser;

        if (currentUser != null) {
            await dbService.loadUserData(uid: currentUser.uid);
            // Add loadModuleProgress if needed
            // await dbService.loadModuleProgress();
        }
    }

    @override
    Widget build(BuildContext context) {
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
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Consumer<AuthService>(
                                                    builder: (context, auth, _) {
                                                        final name = auth.currentUser?.displayName ?? 'User';
                                                        final firstName = name.split(' ')[0];
                                                        return Text(
                                                            'Hello, $firstName!',
                                                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                            ),
                                                        );
                                                    },
                                                ),
                                                Text(
                                                    'Stay Safe, Stay Prepared',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        color: Colors.white70,
                                                    ),
                                                ),
                                            ],
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: IconButton(
                                                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                                onPressed: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                            content: Text('No new notifications'),
                                                            backgroundColor: Color(0xFF21C573),
                                                            behavior: SnackBarBehavior.floating,
                                                        ),
                                                    );
                                                },
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
                                    child: RefreshIndicator(
                                        onRefresh: () async => _refreshData(context),
                                        child: SingleChildScrollView(
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    Consumer<DatabaseService>(
                                                        builder: (context, dbService, _) {
                                                            final userData = dbService.userData;
                                                            final modulesCompleted = userData?['modulesCompleted'] ?? 0;
                                                            final safetyScore = userData?['safetyScore'] ?? 0;

                                                            return Container(
                                                                width: double.infinity,
                                                                padding: const EdgeInsets.all(20),
                                                                decoration: BoxDecoration(
                                                                    gradient: LinearGradient(
                                                                        colors: [
                                                                            const Color(0xFF21C573).withOpacity(0.1),
                                                                            const Color(0xFF1791B6).withOpacity(0.1),
                                                                        ],
                                                                        begin: Alignment.topLeft,
                                                                        end: Alignment.bottomRight,
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(16),
                                                                    border: Border.all(
                                                                        color: const Color(0xFF21C573).withOpacity(0.2),
                                                                    ),
                                                                ),
                                                                child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                        Row(
                                                                            children: [
                                                                                Container(
                                                                                    padding: const EdgeInsets.all(8),
                                                                                    decoration: BoxDecoration(
                                                                                        color: const Color(0xFF21C573),
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                    ),
                                                                                    child: const Icon(
                                                                                        Icons.shield_outlined,
                                                                                        color: Colors.white,
                                                                                        size: 24,
                                                                                    ),
                                                                                ),
                                                                                const SizedBox(width: 12),
                                                                                Expanded(
                                                                                    child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                            Text(
                                                                                                'Your Progress',
                                                                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                    color: const Color(0xFF21C573),
                                                                                                ),
                                                                                            ),
                                                                                            const SizedBox(height: 4),
                                                                                            Text(
                                                                                                'Keep learning to stay safe',
                                                                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                                    color: Colors.grey[600],
                                                                                                ),
                                                                                            ),
                                                                                        ],
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                        const SizedBox(height: 16),
                                                                        Row(
                                                                            children: [
                                                                                Expanded(
                                                                                    child: _buildStatCard(
                                                                                        context,
                                                                                        'Modules\nCompleted',
                                                                                        '$modulesCompleted/5',
                                                                                        Icons.school,
                                                                                    ),
                                                                                ),
                                                                                const SizedBox(width: 12),
                                                                                Expanded(
                                                                                    child: _buildStatCard(
                                                                                        context,
                                                                                        'Safety\nScore',
                                                                                        '$safetyScore%',
                                                                                        Icons.trending_up,
                                                                                    ),
                                                                                ),
                                                                            ],
                                                                        ),
                                                                    ],
                                                                ),
                                                            );
                                                        },
                                                    ),

                                                    const SizedBox(height: 24),
                                                    Text(
                                                        'Quick Actions',
                                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.grey[800],
                                                        ),
                                                    ),
                                                    const SizedBox(height: 16),

                                                    GridView.count(
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        crossAxisCount: 2,
                                                        crossAxisSpacing: 16,
                                                        mainAxisSpacing: 16,
                                                        childAspectRatio: 1.1,
                                                        children: [
                                                            _buildActionCard(
                                                                context,
                                                                'Emergency\nContacts',
                                                                Icons.contact_emergency,
                                                                2, // Navigate to Emergency Contacts
                                                            ),
                                                            _buildActionCard(
                                                                context,
                                                                'Learning\nModules',
                                                                Icons.school,
                                                                1, // Navigate to Learning page
                                                            ),
                                                            _buildActionCard(
                                                                context,
                                                                'Safety\nDrills',
                                                                Icons.sports_martial_arts,
                                                                -1, // Special case for drills page
                                                            ),
                                                            _buildActionCard(
                                                                context,
                                                                'Weather\nAlerts',
                                                                Icons.cloud_circle,
                                                                null,
                                                            ),
                                                        ],
                                                    ),
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

    Widget _buildStatCard(BuildContext context, String label, String value, IconData icon) {
        return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
                children: [
                    Icon(icon, color: const Color(0xFF21C573), size: 24),
                    const SizedBox(height: 8),
                    Text(
                        value,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF21C573),
                        ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        label,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                    ),
                ],
            ),
        );
    }

    Widget _buildActionCard(
        BuildContext context,
        String title,
        IconData icon,
        int? navigationIndex,
        ) {
        return GestureDetector(
            onTap: () {
                if (navigationIndex == -1) {
                    // Navigate to Drills page
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DrillsPage()),
                    );
                } else if (navigationIndex != null) {
                    // Navigate to specific tab by changing the index in HomeScreen
                    setState(() {
                        _currentIndex = navigationIndex;
                    });
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('$title coming soon!'),
                            backgroundColor: const Color(0xFF21C573),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                    );
                }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                        ),
                    ],
                    border: Border.all(color: const Color(0xFF21C573).withOpacity(0.1)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: Colors.white, size: 28),
                            ),
                            const SizedBox(height: 12),
                            Text(
                                title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
