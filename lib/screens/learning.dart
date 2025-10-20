import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';
import 'learning_module_page.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  Map<String, String?> _badges = {};
  Map<String, int> _moduleScores = {}; // Preloaded scores
  final List<String> _modules = ['earthquake', 'flood', 'fire', 'cyclone', 'firstaid'];

  @override
  void initState() {
    super.initState();
    _loadBadges();
    _loadModuleScores();
  }

  // Load badges from SharedPreferences
  Future<void> _loadBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String?> tempBadges = {};
    for (var module in _modules) {
      tempBadges[module] = prefs.getString('badge_$module');
    }
    setState(() => _badges = tempBadges);
  }

  // Preload all module scores from DatabaseService
  Future<void> _loadModuleScores() async {
    final dbService = Provider.of<DatabaseService>(context, listen: false);
    final Map<String, int> tempScores = {};
    final userId = 'USER_ID'; // Replace with actual current user ID

    for (var module in _modules) {
      final score = await dbService.getModuleScore(userId, module);
      tempScores[module] = score;
    }

    setState(() => _moduleScores = tempScores);
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
              _buildHeader(context),
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
                    onRefresh: () async {
                      await _loadBadges();
                      await _loadModuleScores();
                    },
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: _modules.map((module) {
                        final score = _moduleScores[module] ?? 0;
                        return _buildLearningCard(
                          context,
                          _getModuleTitle(module),
                          _getModuleSubtitle(module),
                          _getModuleIcon(module),
                          _getModuleColor(module),
                          module,
                          score,
                        );
                      }).toList(),
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

  // ------------------- HEADER -------------------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learning Modules',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Learn disaster preparedness and safety',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------- LEARNING CARD -------------------
  Widget _buildLearningCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      String moduleType,
      int score,
      ) {
    final percentage = score > 0 ? ((score / 2) * 100).round() : 0;
    final badge = _badges[moduleType];
    IconData? badgeIcon;
    Color? badgeColor;

    if (badge == 'Expert') {
      badgeIcon = Icons.emoji_events;
      badgeColor = Colors.amber;
    } else if (badge == 'Learner') {
      badgeIcon = Icons.school;
      badgeColor = Colors.blueAccent;
    } else if (badge == 'Beginner') {
      badgeIcon = Icons.book;
      badgeColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LearningModulePage(moduleType: moduleType),
              ),
            );
            await _loadBadges();
            await _loadModuleScores();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                // Text + Progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                          ),
                          if (score > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$percentage%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (score > 0) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: color.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 4,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Badge Icon (if any)
                if (badgeIcon != null)
                  Icon(badgeIcon, color: badgeColor, size: 28)
                else
                  const Icon(Icons.arrow_forward_ios, color: Color(0xFF21C573), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- MODULE DATA HELPERS -------------------
  String _getModuleTitle(String module) {
    switch (module) {
      case 'earthquake':
        return 'Earthquake Safety';
      case 'flood':
        return 'Flood Preparedness';
      case 'fire':
        return 'Fire Safety';
      case 'cyclone':
        return 'Cyclone Awareness';
      case 'firstaid':
        return 'First Aid Basics';
      default:
        return '';
    }
  }

  String _getModuleSubtitle(String module) {
    switch (module) {
      case 'earthquake':
        return 'Learn how to prepare for and respond to earthquakes';
      case 'flood':
        return 'Essential knowledge about flood safety and evacuation';
      case 'fire':
        return 'Fire prevention and emergency response techniques';
      case 'cyclone':
        return 'Understanding cyclones and protective measures';
      case 'firstaid':
        return 'Essential first aid skills for emergency situations';
      default:
        return '';
    }
  }

  IconData _getModuleIcon(String module) {
    switch (module) {
      case 'earthquake':
        return Icons.blur_on;
      case 'flood':
        return Icons.water;
      case 'fire':
        return Icons.local_fire_department;
      case 'cyclone':
        return Icons.tornado;
      case 'firstaid':
        return Icons.medical_services;
      default:
        return Icons.school;
    }
  }

  Color _getModuleColor(String module) {
    switch (module) {
      case 'earthquake':
        return const Color(0xFFFF9800);
      case 'flood':
        return const Color(0xFF2196F3);
      case 'fire':
        return const Color(0xFFF44336);
      case 'cyclone':
        return const Color(0xFF9C27B0);
      case 'firstaid':
        return const Color(0xFF21C573);
      default:
        return Colors.grey;
    }
  }
}
