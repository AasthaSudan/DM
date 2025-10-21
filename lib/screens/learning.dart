import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'learning_module_page.dart';

class Learning extends StatefulWidget {
  const Learning({super.key, required String moduleType});

  @override
  State<Learning> createState() => _LearningPageState();
}

class _LearningPageState extends State<Learning> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Map<String, int> _moduleProgress = {};
  Map<String, String?> _moduleBadges = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _loadAllProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _moduleProgress = {
        'earthquake': prefs.getInt('earthquake_progress') ?? 0,
        'flood': prefs.getInt('flood_progress') ?? 0,
        'fire': prefs.getInt('fire_progress') ?? 0,
        'cyclone': prefs.getInt('cyclone_progress') ?? 0,
        'firstaid': prefs.getInt('firstaid_progress') ?? 0,
      };
      _moduleBadges = {
        'earthquake': prefs.getString('badge_earthquake'),
        'flood': prefs.getString('badge_flood'),
        'fire': prefs.getString('badge_fire'),
        'cyclone': prefs.getString('badge_cyclone'),
        'firstaid': prefs.getString('badge_firstaid'),
      };
    });
  }

  List<Map<String, dynamic>> get _filteredModules {
    final modules = [
      {
        'type': 'earthquake',
        'title': 'Earthquake Safety',
        'subtitle': 'Learn how to prepare for and respond to earthquakes',
        'icon': Icons.blur_on,
        'color': const Color(0xFFFF6B35),
        'duration': '15 min',
        'lessons': 8,
      },
      {
        'type': 'flood',
        'title': 'Flood Preparedness',
        'subtitle': 'Essential knowledge about flood safety and evacuation',
        'icon': Icons.water_damage,
        'color': const Color(0xFF4ECDC4),
        'duration': '12 min',
        'lessons': 6,
      },
      {
        'type': 'fire',
        'title': 'Fire Safety',
        'subtitle': 'Fire prevention and emergency response techniques',
        'icon': Icons.local_fire_department,
        'color': const Color(0xFFFF5252),
        'duration': '10 min',
        'lessons': 7,
      },
      {
        'type': 'cyclone',
        'title': 'Cyclone Awareness',
        'subtitle': 'Understanding cyclones and protective measures',
        'icon': Icons.tornado,
        'color': const Color(0xFF9B59B6),
        'duration': '18 min',
        'lessons': 9,
      },
      {
        'type': 'firstaid',
        'title': 'First Aid Basics',
        'subtitle': 'Essential first aid skills for emergency situations',
        'icon': Icons.medical_services,
        'color': const Color(0xFF2ECC71),
        'duration': '20 min',
        'lessons': 10,
      },
    ];

    if (_searchQuery.isEmpty) return modules;

    return modules
        .where((m) =>
    m['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
        m['subtitle'].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _showAllBadgesDialog() async {
    final size = MediaQuery.of(context).size;
    final hasBadges = _moduleBadges.values.any((b) => b != null);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          constraints: BoxConstraints(maxHeight: size.height * 0.7),
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.025),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21C573).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: const Color(0xFF21C573),
                      size: size.width * 0.07,
                    ),
                  ),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                    child: Text(
                      'My Achievements',
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Expanded(
                child: hasBadges
                    ? GridView.builder(
                  shrinkWrap: true,
                  itemCount: _moduleBadges.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final module = _moduleBadges.keys.elementAt(index);
                    final badge = _moduleBadges[module];

                    Color color;
                    IconData icon;
                    String badgeText;

                    if (badge == 'Expert') {
                      color = Colors.amber;
                      icon = Icons.emoji_events;
                      badgeText = 'Expert';
                    } else if (badge == 'Learner') {
                      color = Colors.blueAccent;
                      icon = Icons.school;
                      badgeText = 'Learner';
                    } else if (badge == 'Beginner') {
                      color = Colors.grey;
                      icon = Icons.book;
                      badgeText = 'Beginner';
                    } else {
                      color = Colors.grey.shade300;
                      icon = Icons.lock_outline;
                      badgeText = 'Locked';
                    }

                    return Container(
                      decoration: BoxDecoration(
                        gradient: badge != null
                            ? LinearGradient(
                          colors: [
                            color.withOpacity(0.2),
                            color.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: badge == null ? Colors.grey.shade100 : null,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: badge != null ? color.withOpacity(0.3) : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: color,
                            size: size.width * 0.1,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            badgeText,
                            style: GoogleFonts.poppins(
                              color: color,
                              fontWeight: FontWeight.w700,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                          SizedBox(height: size.height * 0.004),
                          Text(
                            module[0].toUpperCase() + module.substring(1),
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.028,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: size.width * 0.2,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'No badges earned yet!',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'Complete quizzes to unlock achievements',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.034,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAllBadgesDialog,
        backgroundColor: const Color(0xFF21C573),
        icon: const Icon(Icons.emoji_events),
        label: Text(
          'Badges',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: size.height * 0.25,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF21C573),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: _animationController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Learning Hub',
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.07,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: size.height * 0.008),
                              Text(
                                'Master disaster preparedness and safety',
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.035,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search modules...',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: size.width * 0.038,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(size.width * 0.04),
                  ),
                ),
              ),
            ),
          ),

          // Stats Overview
          SliverToBoxAdapter(
            child: _buildStatsOverview(size),
          ),

          // Module Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.01,
            ),
            sliver: isTablet
                ? SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildModuleCard(
                  context,
                  _filteredModules[index],
                  size,
                  index,
                ),
                childCount: _filteredModules.length,
              ),
            )
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildModuleCard(
                  context,
                  _filteredModules[index],
                  size,
                  index,
                ),
                childCount: _filteredModules.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: size.height * 0.1)),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(Size size) {
    final totalProgress = _moduleProgress.values.fold(0, (a, b) => a + b);
    final avgProgress = _moduleProgress.isEmpty ? 0 : (totalProgress / (_moduleProgress.length * 100) * 100).round();
    final completedModules = _moduleProgress.values.where((v) => v == 100).length;
    final totalBadges = _moduleBadges.values.where((b) => b != null).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Container(
        padding: EdgeInsets.all(size.width * 0.04),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF21C573), Color(0xFF1791B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF21C573).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                Icons.school_rounded,
                'Completed',
                '$completedModules/5',
                size,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                Icons.emoji_events,
                'Badges',
                '$totalBadges',
                size,
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                Icons.trending_up,
                'Progress',
                '$avgProgress%',
                size,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Size size) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: size.width * 0.06),
        SizedBox(height: size.height * 0.008),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.042,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.028,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> module, Size size, int index) {
    final progress = _moduleProgress[module['type']] ?? 0;
    final badge = _moduleBadges[module['type']];
    final delay = index * 100;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay / 1000,
          (delay + 400) / 1000,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay / 1000,
              (delay + 400) / 1000,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: size.height * 0.015),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _navigateToModule(context, module['type']),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header with Icon and Badge
                    Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            module['color'],
                            module['color'].withOpacity(0.7),
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(size.width * 0.03),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              module['icon'],
                              color: Colors.white,
                              size: size.width * 0.07,
                            ),
                          ),
                          SizedBox(width: size.width * 0.03),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.004),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: size.width * 0.035,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      module['duration'],
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.03,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.03),
                                    Icon(
                                      Icons.menu_book,
                                      size: size.width * 0.035,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    Text(
                                      '${module['lessons']} lessons',
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.03,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Badge indicator
                          if (badge != null)
                            Container(
                              padding: EdgeInsets.all(size.width * 0.02),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                badge == 'Expert'
                                    ? Icons.emoji_events
                                    : badge == 'Learner'
                                    ? Icons.school
                                    : Icons.book,
                                color: badge == 'Expert'
                                    ? Colors.amber
                                    : badge == 'Learner'
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                size: size.width * 0.05,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Card Body
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module['subtitle'],
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.034,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: size.height * 0.015),

                          // Progress Section
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Progress',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.width * 0.03,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '$progress%',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.width * 0.032,
                                            fontWeight: FontWeight.w700,
                                            color: module['color'],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.008),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progress / 100,
                                        backgroundColor: Colors.grey[200],
                                        color: module['color'],
                                        minHeight: 6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Container(
                                padding: EdgeInsets.all(size.width * 0.02),
                                decoration: BoxDecoration(
                                  color: module['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: module['color'],
                                  size: size.width * 0.05,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, String moduleType) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModulePage(moduleType: moduleType),
      ),
    );
    _loadAllProgress();
  }
}