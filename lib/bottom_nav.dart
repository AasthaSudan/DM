// lib/bottom_nav.dart

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final ValueNotifier<int> currentIndex;
  final List<NavigationItem> items;

  BottomNavBar({required this.currentIndex, required this.items});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      containerColor: Colors.white,
      tonalElevation: 8.dp,
      children: items.map((item) {
        return NavigationBarItem(
          icon: Icon(item.icon),
          label: Text(item.title),
          selected: currentIndex.value == item.index,
          onTap: () => currentIndex.value = item.index,
        );
      }).toList(),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final int index;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.index,
  });
}
