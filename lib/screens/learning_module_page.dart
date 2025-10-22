import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class LearningModulePage extends StatefulWidget {
  final String moduleType;

  const LearningModulePage({super.key, required this.moduleType});

  @override
  State<LearningModulePage> createState() => _LearningModulePageState();
}

class _LearningModulePageState extends State<LearningModulePage>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  int _score = 0;
  int _questionIndex = 0;
  bool _isAnswered = false;
  bool _showVideo = true;
  int _selectedAnswerIndex = -1;
  String? _earnedBadge;
  bool _showConfetti = false;
  late AnimationController _progressController;
  late AnimationController _cardController;
  late AnimationController _confettiController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  int _streak = 0;
  bool _showExplanation = false;
  int _coins = 0;
  int _hearts = 3;
  bool _perfectStreak = false;
  bool _videoWatched = false;
  int _videoWatchTime = 0;
  bool _earnedVideoBonus = false;
  late AnimationController _videoProgressController;
  late Animation<double> _videoProgressAnimation;

  final Map<String, Map<String, dynamic>> _moduleData = {
    'earthquake': {
      'title': 'Earthquake Safety',
      'description': 'Master earthquake response techniques through interactive challenges.',
      'videoAsset': 'assets/video/earthquake_video.mp4',
      'color': const Color(0xFFFF6B35),
      'icon': Icons.blur_on,
      'emoji': '🌍',
      'tips': [
        'Drop, Cover, and Hold On during shaking',
        'Stay away from windows and heavy objects',
        'Have an emergency kit ready with supplies',
        'Know safe spots in each room',
      ],
      'questions': [
        {
          'question': 'What\'s the safest action during an earthquake?',
          'options': [
            'Drop, Cover, Hold On',
            'Run Outside',
            'Stand in Doorway',
            'Hide in Closet'
          ],
          'correctAnswer': 0,
          'explanation': 'Drop, Cover, and Hold On protects you from falling debris and keeps you stable.',
          'difficulty': 'easy',
          'coins': 10,
        },
        {
          'question': 'Where is the safest place indoors?',
          'options': [
            'Near a window',
            'Under sturdy table',
            'In elevator',
            'On stairs'
          ],
          'correctAnswer': 1,
          'explanation': 'A sturdy table shields you from falling objects. Avoid windows, elevators, and stairs.',
          'difficulty': 'medium',
          'coins': 15,
        },
        {
          'question': 'If trapped under debris, you should:',
          'options': [
            'Shout loudly',
            'Tap on pipe/wall',
            'Light a match',
            'Move around'
          ],
          'correctAnswer': 1,
          'explanation': 'Tapping helps rescuers locate you while saving energy and avoiding dust inhalation.',
          'difficulty': 'hard',
          'coins': 20,
        },
        {
          'question': 'After shaking stops, what next?',
          'options': [
            'Stand immediately',
            'Wait for aftershocks',
            'Leave building',
            'Check phone'
          ],
          'correctAnswer': 1,
          'explanation': 'Aftershocks are common. Stay protected and be ready to Drop, Cover, and Hold On again.',
          'difficulty': 'medium',
          'coins': 15,
        },
        {
          'question': 'Essential emergency kit item?',
          'options': [
            'Only food',
            'Full supplies kit',
            'Just flashlight',
            'Only meds'
          ],
          'correctAnswer': 1,
          'explanation': 'A complete kit needs water, food, first aid, flashlight, radio, and medications.',
          'difficulty': 'easy',
          'coins': 10,
        },
      ],
    },
    'flood': {
      'title': 'Flood Preparedness',
      'description': 'Learn life-saving flood response strategies.',
      'videoAsset': 'assets/video/flood_video.mp4',
      'color': const Color(0xFF4ECDC4),
      'icon': Icons.water_damage,
      'emoji': '🌊',
      'tips': [
        'Never walk or drive through flood water',
        'Move to higher ground immediately',
        'Turn off utilities before evacuating',
        'Monitor weather alerts continuously',
      ],
      'questions': [
        {
          'question': 'During flood warning, you should:',
          'options': [
            'Stay and watch',
            'Move to high ground',
            'Check neighbors',
            'Wait for water'
          ],
          'correctAnswer': 1,
          'explanation': 'Always move to higher ground immediately. Don\'t wait for visible flooding.',
          'difficulty': 'easy',
          'coins': 10,
        },
        {
          'question': 'How much water sweeps a car away?',
          'options': ['3 feet', '2 feet', '1 foot', '6 inches'],
          'correctAnswer': 2,
          'explanation': 'Just 1 foot of moving water can sweep away vehicles. Turn around, don\'t drown!',
          'difficulty': 'medium',
          'coins': 15,
        },
        {
          'question': 'After flood, before entering home:',
          'options': [
            'Rush in quickly',
            'Check for damage',
            'Turn on lights',
            'Use candles'
          ],
          'correctAnswer': 1,
          'explanation': 'Always check for structural damage, gas leaks, and electrical hazards first.',
          'difficulty': 'hard',
          'coins': 20,
        },
      ],
    },
    'fire': {
      'title': 'Fire Safety',
      'description': 'Master fire prevention and response techniques.',
      'videoAsset': 'assets/video/fire_video.mp4',
      'color': const Color(0xFFFF5252),
      'icon': Icons.local_fire_department,
      'emoji': '🔥',
      'tips': [
        'Install smoke alarms on every level',
        'Plan and practice escape routes',
        'Keep fire extinguishers accessible',
        'Never leave cooking unattended',
      ],
      'questions': [
        {
          'question': 'PASS stands for:',
          'options': [
            'Pull, Aim, Squeeze, Sweep',
            'Point, Activate, Spray',
            'Prepare, Alert, Spray',
            'Pull, Alert, Squeeze'
          ],
          'correctAnswer': 0,
          'explanation': 'Pull pin, Aim at base, Squeeze handle, Sweep side to side.',
          'difficulty': 'medium',
          'coins': 15,
        },
        {
          'question': 'If clothes catch fire:',
          'options': [
            'Run for help',
            'Stop, Drop, Roll',
            'Jump in water',
            'Wave arms'
          ],
          'correctAnswer': 1,
          'explanation': 'Stop, Drop, and Roll smothers flames. Running feeds oxygen to fire.',
          'difficulty': 'easy',
          'coins': 10,
        },
      ],
    },
    'cyclone': {
      'title': 'Cyclone Awareness',
      'description': 'Prepare for powerful storm systems.',
      'videoAsset': 'assets/video/cyclone_video.mp4',
      'color': const Color(0xFF9B59B6),
      'icon': Icons.tornado,
      'emoji': '🌪️',
      'tips': [
        'Know your cyclone shelter location',
        'Prepare emergency supplies in advance',
        'Secure outdoor items before storm',
        'Stay indoors during cyclone',
      ],
      'questions': [
        {
          'question': 'Safest room during cyclone:',
          'options': [
            'Room with windows',
            'Interior room, no windows',
            'Basement near exit',
            'Top floor room'
          ],
          'correctAnswer': 1,
          'explanation': 'Interior room without windows on lowest floor protects from winds and debris.',
          'difficulty': 'medium',
          'coins': 15,
        },
      ],
    },
    'firstaid': {
      'title': 'First Aid Basics',
      'description': 'Learn essential life-saving techniques.',
      'videoAsset': 'assets/video/firstaid_video.mp4',
      'color': const Color(0xFF2ECC71),
      'icon': Icons.medical_services,
      'emoji': '⚕️',
      'tips': [
        'Always ensure scene safety first',
        'Call emergency services immediately',
        'Apply pressure to stop bleeding',
        'Keep victim calm and comfortable',
      ],
      'questions': [
        {
          'question': 'Correct CPR compression rate:',
          'options': [
            '50-60 per minute',
            '80-100 per minute',
            '100-120 per minute',
            '140-160 per minute'
          ],
          'correctAnswer': 2,
          'explanation': '100-120 compressions per minute matches the beat of "Stayin\' Alive".',
          'difficulty': 'hard',
          'coins': 20,
        },
        {
          'question': 'For severe burn:',
          'options': [
            'Apply ice directly',
            'Apply butter/oil',
            'Cool with running water',
            'Pop blisters'
          ],
          'correctAnswer': 2,
          'explanation': 'Cool with running water for 10-20 minutes. Never use ice, butter, or oil.',
          'difficulty': 'medium',
          'coins': 15,
        },
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeVideoPlayer();
    _loadProgress();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    _cardController.forward();
    _fadeController.forward();
  }

  void _initializeVideoPlayer() {
    final videoAsset = _moduleData[widget.moduleType]?['videoAsset'];
    if (videoAsset != null) {
      _controller = VideoPlayerController.asset(videoAsset)
        ..initialize().then((_) {
          if (mounted) setState(() {});
        }).catchError((error) {
          debugPrint('Video initialization error: $error');
        });
    }
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _score = prefs.getInt('${widget.moduleType}_score') ?? 0;
        _streak = prefs.getInt('${widget.moduleType}_streak') ?? 0;
        _coins = prefs.getInt('${widget.moduleType}_coins') ?? 0;
      });
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.moduleType}_score', _score);
    await prefs.setInt('${widget.moduleType}_streak', _streak);
    await prefs.setInt('${widget.moduleType}_coins', _coins);
  }

  void _checkAnswer(int selectedIndex) {
    if (_isAnswered) return;

    final questions = _moduleData[widget.moduleType]!['questions'] as List;
    final correctAnswer = questions[_questionIndex]['correctAnswer'] as int;
    final isCorrect = selectedIndex == correctAnswer;
    final coinReward = questions[_questionIndex]['coins'] as int;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswered = true;
      _showExplanation = true;

      if (isCorrect) {
        _score += 10;
        _coins += coinReward;
        _streak++;

        if (_streak >= 3) {
          _showConfetti = true;
          _perfectStreak = true;
          _confettiController.forward(from: 0);
        }
        _progressController.forward(from: 0);
      } else {
        _hearts = (_hearts - 1).clamp(0, 3);
        _streak = 0;
        _perfectStreak = false;
        _shakeController.forward(from: 0);
      }
    });

    _saveProgress();

    if (_questionIndex == questions.length - 1) {
      _determineBadge(questions.length);
    }
  }

  void _determineBadge(int totalQuestions) {
    final percentage = (_score / (totalQuestions * 10) * 100).round();
    String badge;

    if (percentage >= 80 && _perfectStreak) {
      badge = 'Master';
    } else if (percentage >= 80) {
      badge = 'Expert';
    } else if (percentage >= 50) {
      badge = 'Learner';
    } else {
      badge = 'Beginner';
    }

    setState(() => _earnedBadge = badge);
  }

  void _nextQuestion() {
    final questions = _moduleData[widget.moduleType]!['questions'] as List;

    if (_questionIndex < questions.length - 1) {
      setState(() {
        _questionIndex++;
        _isAnswered = false;
        _selectedAnswerIndex = -1;
        _showExplanation = false;
        _showConfetti = false;
      });
      _cardController.forward(from: 0);
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final questions = _moduleData[widget.moduleType]!['questions'] as List;
    final percentage = (_score / (questions.length * 10) * 100).round();
    final color = _moduleData[widget.moduleType]!['color'] as Color;
    final emoji = _moduleData[widget.moduleType]!['emoji'] as String;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [Colors.white, color.withOpacity(0.05)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 56),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _earnedBadge == 'Master' ? 'Perfect!' : 'Great Job!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '$_earnedBadge',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCompletionStat('🏆', '$_score', 'Points', color),
                  _buildCompletionStat('🪙', '$_coins', 'Coins', color),
                  _buildCompletionStat('🔥', '$_streak', 'Streak', color),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _questionIndex = 0;
                          _isAnswered = false;
                          _selectedAnswerIndex = -1;
                          _showVideo = true;
                          _hearts = 3;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Retry',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Done',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionStat(String emoji, String value, String label, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _progressController.dispose();
    _cardController.dispose();
    _confettiController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleData = _moduleData[widget.moduleType];

    if (moduleData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module Not Found')),
        body: const Center(child: Text('This module is not available.')),
      );
    }

    final questions = List<Map<String, dynamic>>.from(moduleData['questions']);
    final color = moduleData['color'] as Color;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(moduleData, color, questions.length),
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _showVideo
                        ? _buildVideoSection(moduleData, color)
                        : _buildQuizSection(questions, color),
                  ),
                ),
              ),
            ],
          ),
          if (_showConfetti) _buildConfetti(),
        ],
      ),
    );
  }

  Widget _buildAppBar(Map<String, dynamic> moduleData, Color color, int totalQuestions) {
    final emoji = moduleData['emoji'] as String;

    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: color,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16, right: 16),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                moduleData['title'],
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!_showVideo)
                    Row(
                      children: [
                        _buildStatBubble('🔥', _streak.toString(), color),
                        const SizedBox(width: 10),
                        _buildStatBubble('🪙', _coins.toString(), color),
                        const SizedBox(width: 10),
                        ...List.generate(3, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              i < _hearts ? '❤️' : '🖤',
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(_showVideo ? Icons.play_arrow : Icons.video_library),
            color: Colors.white,
            onPressed: () {
              setState(() {
                _showVideo = !_showVideo;
                if (!_showVideo) _cardController.forward(from: 0);
              });
            },
          ),
        ),
      ],
      bottom: !_showVideo
          ? PreferredSize(
        preferredSize: const Size.fromHeight(6),
        child: Container(
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (_questionIndex + 1) / totalQuestions,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildStatBubble(String emoji, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(Map<String, dynamic> moduleData, Color color) {
    final tips = List<String>.from(moduleData['tips']);
    final emoji = moduleData['emoji'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  moduleData['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _controller?.value.isInitialized == true
                  ? Stack(
                children: [
                  VideoPlayer(_controller!),
                  if (!_controller!.value.isPlaying)
                    GestureDetector(
                      onTap: () => setState(() => _controller!.play()),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Icon(Icons.play_arrow, color: color, size: 48),
                          ),
                        ),
                      ),
                    ),
                ],
              )
                  : Container(
                color: color.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'Video Preview',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.lightbulb_rounded, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Quick Tips',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[850],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...tips.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${entry.key + 1}',
                          style: GoogleFonts.poppins(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() {
                  _showVideo = false;
                  _cardController.forward(from: 0);
                }),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_circle_filled, color: Colors.white, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Start Quiz',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuizSection(List<Map<String, dynamic>> questions, Color color) {
    if (_questionIndex >= questions.length) return const SizedBox();

    final question = questions[_questionIndex];
    final options = List<String>.from(question['options']);
    final correctAnswer = question['correctAnswer'] as int;
    final difficulty = question['difficulty'] as String;
    final coinReward = question['coins'] as int;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final offset = math.sin(_shakeAnimation.value * math.pi * 2) * 5;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: ScaleTransition(
        scale: _cardAnimation,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: difficulty == 'easy'
                          ? const Color(0xFF2ECC71).withOpacity(0.15)
                          : difficulty == 'medium'
                          ? const Color(0xFFFF9500).withOpacity(0.15)
                          : const Color(0xFFE74C3C).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          difficulty == 'easy'
                              ? Icons.sentiment_satisfied
                              : difficulty == 'medium'
                              ? Icons.sentiment_neutral
                              : Icons.sentiment_dissatisfied,
                          color: difficulty == 'easy'
                              ? const Color(0xFF2ECC71)
                              : difficulty == 'medium'
                              ? const Color(0xFFFF9500)
                              : const Color(0xFFE74C3C),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          difficulty.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: difficulty == 'easy'
                                ? const Color(0xFF2ECC71)
                                : difficulty == 'medium'
                                ? const Color(0xFFFF9500)
                                : const Color(0xFFE74C3C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text('🪙', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        '+$coinReward',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.help_outline, color: Colors.white, size: 36),
                  const SizedBox(height: 16),
                  Text(
                    question['question'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = _selectedAnswerIndex == index;
              final isCorrect = index == correctAnswer;
              final showResult = _isAnswered;

              Color cardColor = Colors.white;
              Color borderColor = Colors.grey[300]!;
              IconData? resultIcon;

              if (showResult) {
                if (isSelected) {
                  if (isCorrect) {
                    cardColor = const Color(0xFFD4EDDA);
                    borderColor = const Color(0xFF28A745);
                    resultIcon = Icons.check_circle;
                  } else {
                    cardColor = const Color(0xFFF8D7DA);
                    borderColor = const Color(0xFFDC3545);
                    resultIcon = Icons.cancel;
                  }
                } else if (isCorrect) {
                  cardColor = const Color(0xFFD4EDDA);
                  borderColor = const Color(0xFF28A745);
                  resultIcon = Icons.check_circle;
                }
              } else if (isSelected) {
                borderColor = color;
                cardColor = color.withOpacity(0.05);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showResult ? null : () => _checkAnswer(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: borderColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: showResult && (isSelected || isCorrect)
                                  ? borderColor.withOpacity(0.2)
                                  : color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: showResult && (isSelected || isCorrect)
                                      ? borderColor
                                      : color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (resultIcon != null) ...[
                            const SizedBox(width: 8),
                            Icon(resultIcon, color: borderColor, size: 24),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            if (_showExplanation) ...[
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        (_selectedAnswerIndex == correctAnswer
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFFF9500))
                            .withOpacity(0.15),
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: (_selectedAnswerIndex == correctAnswer
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFFF9500))
                          .withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _selectedAnswerIndex == correctAnswer ? '✅' : '💡',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedAnswerIndex == correctAnswer
                                  ? 'Perfect!'
                                  : 'Learn & Improve',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[850],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question['explanation'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        maxLines: 10,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _questionIndex < questions.length - 1
                            ? 'Next Question'
                            : 'Complete',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            return CustomPaint(
              painter: ConfettiPainter(_confettiController.value),
            );
          },
        ),
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFF45B7D1),
      const Color(0xFFFFA07A),
      const Color(0xFF98D8C8),
      const Color(0xFFFFD93D),
    ];

    for (int i = 0; i < 40; i++) {
      final random = math.Random(i);
      final x = size.width * random.nextDouble();
      final y = size.height * progress * (0.5 + random.nextDouble() * 0.5);
      final rotation = progress * math.pi * 4 * random.nextDouble();
      final color = colors[random.nextInt(colors.length)];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = color.withOpacity((1 - progress * 0.7).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      if (i % 2 == 0) {
        canvas.drawCircle(Offset.zero, 5, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(-5, -5, 10, 10),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}