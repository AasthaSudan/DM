// lib/utils/constants.dart
import 'package:flutter/material.dart';

/// App-wide constants, colors, validators, and utility functions
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'PrepareEd';
  static const String appTagline = 'Disaster Preparedness & Awareness';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@prepared.com';
  static const String websiteUrl = 'https://prepared.com';

  // Colors
  static const Color primaryGreen = Color(0xFF21C573);
  static const Color primaryBlue = Color(0xFF1791B6);
  static const Color darkGrey = Color(0xFF2C3E50);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient lightGradient = LinearGradient(
    colors: [
      primaryGreen.withOpacity(0.1),
      primaryBlue.withOpacity(0.1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Emergency Numbers (India)
  static const Map<String, Map<String, String>> emergencyNumbers = {
    'general': {
      'name': 'Emergency Services',
      'number': '112',
      'description': 'Single emergency number for all services',
    },
    'police': {
      'name': 'Police',
      'number': '100',
      'description': 'Police emergency',
    },
    'fire': {
      'name': 'Fire Department',
      'number': '101',
      'description': 'Fire emergency',
    },
    'ambulance': {
      'name': 'Ambulance',
      'number': '108',
      'description': 'Medical emergency',
    },
    'disaster': {
      'name': 'Disaster Management',
      'number': '1078',
      'description': 'National Disaster Response Force',
    },
    'women': {
      'name': 'Women Helpline',
      'number': '1091',
      'description': 'Women in distress',
    },
    'child': {
      'name': 'Child Helpline',
      'number': '1098',
      'description': 'Child in need of care and protection',
    },
    'senior': {
      'name': 'Senior Citizens Helpline',
      'number': '14567',
      'description': 'Elder line for senior citizens',
    },
  };

  // Safety Tips
  static const Map<String, List<String>> safetyTips = {
    'earthquake': [
      'Drop, Cover, and Hold On during shaking',
      'Stay away from windows and heavy objects',
      'If outdoors, move away from buildings',
      'After shaking stops, check for injuries',
      'Be prepared for aftershocks',
    ],
    'flood': [
      'Move to higher ground immediately',
      'Never walk through moving water',
      'Avoid driving through flooded areas',
      'Turn off utilities if instructed',
      'Listen to emergency broadcasts',
    ],
    'fire': [
      'Stay low under smoke',
      'Feel doors before opening them',
      'Use stairs, never elevators',
      'Stop, Drop, and Roll if clothes catch fire',
      'Have a meeting point outside',
    ],
    'cyclone': [
      'Stay indoors away from windows',
      'Move to an interior room on lowest floor',
      'Listen to weather updates',
      'Secure outdoor objects',
      'Have emergency supplies ready',
    ],
    'general': [
      'Keep emergency contacts handy',
      'Maintain emergency supply kit',
      'Know your evacuation routes',
      'Practice emergency drills regularly',
      'Stay informed about local risks',
    ],
  };

  // App Settings
  static const int splashScreenDuration = 3; // seconds
  static const int minimumPasswordLength = 6;
  static const int maxEmergencyContacts = 20;
  static const int questionsPerModule = 2;
  static const int passingScore = 70; // percentage

  // Database Collections
  static const String usersCollection = 'users';
  static const String contactsCollection = 'emergency_contacts';
  static const String progressCollection = 'module_progress';
  static const String drillsCollection = 'drill_progress';

  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyChecklistProgress = 'checklist_progress';

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double iconSize = 24.0;
  static const double largePadding = 20.0;
  static const double mediumPadding = 16.0;
  static const double smallPadding = 8.0;
}

// Disaster Types Enum
enum DisasterType {
  earthquake,
  flood,
  fire,
  cyclone,
  tsunami,
  landslide,
  heatwave,
  coldwave,
}

extension DisasterTypeExtension on DisasterType {
  String get displayName {
    switch (this) {
      case DisasterType.earthquake:
        return 'Earthquake';
      case DisasterType.flood:
        return 'Flood';
      case DisasterType.fire:
        return 'Fire';
      case DisasterType.cyclone:
        return 'Cyclone';
      case DisasterType.tsunami:
        return 'Tsunami';
      case DisasterType.landslide:
        return 'Landslide';
      case DisasterType.heatwave:
        return 'Heat Wave';
      case DisasterType.coldwave:
        return 'Cold Wave';
    }
  }

  IconData get icon {
    switch (this) {
      case DisasterType.earthquake:
        return Icons.blur_on;
      case DisasterType.flood:
        return Icons.water;
      case DisasterType.fire:
        return Icons.local_fire_department;
      case DisasterType.cyclone:
        return Icons.tornado;
      case DisasterType.tsunami:
        return Icons.waves;
      case DisasterType.landslide:
        return Icons.terrain;
      case DisasterType.heatwave:
        return Icons.wb_sunny;
      case DisasterType.coldwave:
        return Icons.ac_unit;
    }
  }

  Color get color {
    switch (this) {
      case DisasterType.earthquake:
        return const Color(0xFFFF9800);
      case DisasterType.flood:
        return const Color(0xFF2196F3);
      case DisasterType.fire:
        return const Color(0xFFF44336);
      case DisasterType.cyclone:
        return const Color(0xFF9C27B0);
      case DisasterType.tsunami:
        return const Color(0xFF00BCD4);
      case DisasterType.landslide:
        return const Color(0xFF795548);
      case DisasterType.heatwave:
        return const Color(0xFFFF5722);
      case DisasterType.coldwave:
        return const Color(0xFF03A9F4);
    }
  }
}

// Utility Extensions
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(this) && length >= 10;
  }
}

extension DateTimeExtension on DateTime {
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

// Custom Validators
class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minimumPasswordLength) {
      return 'Password must be at least ${AppConstants.minimumPasswordLength} characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!value.isValidPhone) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
}