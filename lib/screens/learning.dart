import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'learning_module_page.dart';

class Learning extends StatefulWidget {
  const Learning({super.key, required String moduleType});

  @override
  State<Learning> createState() => _LearningPageState();
}

class _LearningPageState extends State<Learning> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabController;
  late Animation<double> _fabScaleAnimation;

  Map<String, int> _moduleProgress = {};
  Map<String, String?> _moduleBadges = {};
  String _searchQuery = '';
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
    );

    _loadAllProgress();

    // Delay FAB animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
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

  void _showAllBadgesDialog() {
    final size = MediaQuery.of(context).size;
    final hasBadges = _moduleBadges.values.any((b) => b != null);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          constraints: BoxConstraints(maxHeight: size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(size.width * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: Colors.white,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: hasBadges
                      ? GridView.builder(
                    shrinkWrap: true,
                    itemCount: _moduleBadges.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.width > 600 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final module = _moduleBadges.keys.elementAt(index);
                      final badge = _moduleBadges[module];

                      Color color;
                      IconData icon;
                      String badgeText;

                      if (badge == 'Expert') {
                        color = const Color(0xFFFFD700);
                        icon = Icons.emoji_events;
                        badgeText = 'Expert';
                      } else if (badge == 'Learner') {
                        color = const Color(0xFF4ECDC4);
                        icon = Icons.school;
                        badgeText = 'Learner';
                      } else if (badge == 'Beginner') {
                        color = const Color(0xFF95A5A6);
                        icon = Icons.book;
                        badgeText = 'Beginner';
                      } else {
                        color = Colors.grey.shade300;
                        icon = Icons.lock_outline;
                        badgeText = 'Locked';
                      }

                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: badge != null
                                ? LinearGradient(
                              colors: [
                                color.withOpacity(0.15),
                                color.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            color: badge == null ? Colors.grey.shade50 : null,
                            borderRadius: BorderRadius.circular(20),
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
                                size: size.width * 0.12,
                              ),
                              SizedBox(height: size.height * 0.012),
                              Text(
                                badgeText,
                                style: GoogleFonts.poppins(
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: size.width * 0.038,
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                module[0].toUpperCase() + module.substring(1),
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.03,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          'No badges earned yet!',
                          style: GoogleFonts.poppins(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                          child: Text(
                            'Complete quizzes to unlock achievements',
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.034,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showAllBadgesDialog,
          backgroundColor: const Color(0xFF21C573),
          elevation: 8,
          icon: const Icon(Icons.emoji_events),
          label: Text(
            'My Badges',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: size.height * 0.26,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF21C573),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(_showSearch ? Icons.close : Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showSearch = !_showSearch;
                    if (!_showSearch) _searchQuery = '';
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
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
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(size.width * 0.025),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.school_rounded,
                                      color: Colors.white,
                                      size: size.width * 0.07,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  Expanded(
                                    child: Text(
                                      'Learning Hub',
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.07,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Text(
                                'Master disaster preparedness and safety',
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.038,
                                  color: Colors.white.withOpacity(0.95),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
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

          // Search Bar (conditionally shown)
          if (_showSearch)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  size.width * 0.04,
                  size.height * 0.02,
                  size.width * 0.04,
                  0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: GoogleFonts.poppins(fontSize: size.width * 0.04),
                    decoration: InputDecoration(
                      hintText: 'Search modules...',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: size.width * 0.04,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[400]),
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.04,
                size.height * 0.02,
                size.width * 0.04,
                size.height * 0.02,
              ),
              child: _buildStatsOverview(size),
            ),
          ),

          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.04,
                0,
                size.width * 0.04,
                size.height * 0.015,
              ),
              child: FadeTransition(
                opacity: _animationController,
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(width: size.width * 0.035),
                    Text(
                      'Available Modules',
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[850],
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Module Grid/List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            sliver: isTablet
                ? SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
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

          SliverToBoxAdapter(child: SizedBox(height: size.height * 0.12)),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(Size size) {
    final totalProgress = _moduleProgress.values.fold(0, (a, b) => a + b);
    final avgProgress = _moduleProgress.isEmpty ? 0 : (totalProgress / (_moduleProgress.length * 100) * 100).round();
    final completedModules = _moduleProgress.values.where((v) => v == 100).length;
    final totalBadges = _moduleBadges.values.where((b) => b != null).length;

    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.all(size.width * 0.045),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF21C573), Color(0xFF1791B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF21C573).withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
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
              width: 1.5,
              height: 50,
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
              width: 1.5,
              height: 50,
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
        Icon(icon, color: Colors.white, size: size.width * 0.065),
        SizedBox(height: size.height * 0.01),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.048,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: size.height * 0.003),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.03,
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModuleCard(BuildContext context, Map<String, dynamic> module, Size size, int index) {
    final progress = _moduleProgress[module['type']] ?? 0;
    final badge = _moduleBadges[module['type']];
    final delay = index * 0.1;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          delay,
          delay + 0.4,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              delay,
              delay + 0.4,
              curve: Curves.easeOutCubic,
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: size.height * 0.02),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _navigateToModule(context, module['type']),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: module['color'].withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Header
                    Container(
                      padding: EdgeInsets.all(size.width * 0.045),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            module['color'],
                            module['color'].withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(size.width * 0.035),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              module['icon'],
                              color: Colors.white,
                              size: size.width * 0.075,
                            ),
                          ),
                          SizedBox(width: size.width * 0.035),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: size.width * 0.048,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.006),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: size.width * 0.038,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                    SizedBox(width: size.width * 0.012),
                                    Text(
                                      module['duration'],
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.032,
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.035),
                                    Icon(
                                      Icons.menu_book,
                                      size: size.width * 0.038,
                                      color: Colors.white.withOpacity(0.95),
                                    ),
                                    SizedBox(width: size.width * 0.012),
                                    Text(
                                      '${module['lessons']} lessons',
                                      style: GoogleFonts.poppins(
                                        fontSize: size.width * 0.032,
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w500,
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
                              padding: EdgeInsets.all(size.width * 0.022),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                badge == 'Expert'
                                    ? Icons.emoji_events
                                    : badge == 'Learner'
                                    ? Icons.school
                                    : Icons.book,
                                color: badge == 'Expert'
                                    ? const Color(0xFFFFD700)
                                    : badge == 'Learner'
                                    ? const Color(0xFF4ECDC4)
                                    : const Color(0xFF95A5A6),
                                size: size.width * 0.055,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Card Body
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.045),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module['subtitle'],
                            style: GoogleFonts.poppins(
                              fontSize: size.width * 0.036,
                              color: Colors.grey[600],
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: size.height * 0.018),

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
                                            fontSize: size.width * 0.032,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '$progress%',
                                          style: GoogleFonts.poppins(
                                            fontSize: size.width * 0.038,
                                            fontWeight: FontWeight.w700,
                                            color: module['color'],
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: LinearProgressIndicator(
                                        value: progress / 100,
                                        backgroundColor: Colors.grey[200],
                                        color: module['color'],
                                        minHeight: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: size.width * 0.035),
                              Container(
                                padding: EdgeInsets.all(size.width * 0.025),
                                decoration: BoxDecoration(
                                  color: module['color'].withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: module['color'],
                                  size: size.width * 0.055,
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