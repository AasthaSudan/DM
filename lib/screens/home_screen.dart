import 'package:flutter/material.dart';
import 'learning.dart';
import 'emergency_contacts_page.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _selectedIndex = 0;

    final List<Widget> _pages = const [
        LearningPage(),
        EmergencyContactsPage(),
        ProfilePage(),
    ];

    final List<String> _titles = const [
        'Learning Hub',
        'Emergency Contacts',
        'Profile',
    ];

    void _onItemTapped(int index) {
        setState(() {
            _selectedIndex = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    _titles[_selectedIndex],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: const Color(0xFF21C573),
            ),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: const Color(0xFF21C573),
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                type: BottomNavigationBarType.fixed,
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.school_outlined),
                        label: 'Learn',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.phone_in_talk_outlined),
                        label: 'Emergency',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline),
                        label: 'Profile',
                    ),
                ],
            ),
        );
    }
}
