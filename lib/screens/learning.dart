// lib/screens/learning_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import 'learning_module_page.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

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
                  children: [
                    const Icon(Icons.school, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
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
                  child: Consumer<DatabaseService>(
                    builder: (context, dbService, _) {
                      return ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildLearningCard(
                            context,
                            'Earthquake Safety',
                            'Learn how to prepare for and respond to earthquakes',
                            Icons.blur_on,
                            const Color(0xFFFF9800),
                            'earthquake',
                            dbService.getModuleScore('earthquake'),
                          ),
                          _buildLearningCard(
                            context,
                            'Flood Preparedness',
                            'Essential knowledge about flood safety and evacuation',
                            Icons.water,
                            const Color(0xFF2196F3),
                            'flood',
                            dbService.getModuleScore('flood'),
                          ),
                          _buildLearningCard(
                            context,
                            'Fire Safety',
                            'Fire prevention and emergency response techniques',
                            Icons.local_fire_department,
                            const Color(0xFFF44336),
                            'fire',
                            dbService.getModuleScore('fire'),
                          ),
                          _buildLearningCard(
                            context,
                            'Cyclone Awareness',
                            'Understanding cyclones and protective measures',
                            Icons.tornado,
                            const Color(0xFF9C27B0),
                            'cyclone',
                            dbService.getModuleScore('cyclone'),
                          ),
                          _buildLearningCard(
                            context,
                            'First Aid Basics',
                            'Essential first aid skills for emergency situations',
                            Icons.medical_services,
                            const Color(0xFF21C573),
                            'firstaid',
                            dbService.getModuleScore('firstaid'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LearningModulePage(moduleType: moduleType),
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF21C573).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF21C573),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}