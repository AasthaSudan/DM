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
  late Animation<double> _progressAnimation;
  late Animation<double> _cardAnimation;
  int _streak = 0;
  bool _showExplanation = false;

  final Map<String, Map<String, dynamic>> _moduleData = {
    'earthquake': {
      'title': 'Earthquake Safety',
      'description':
      'Earthquakes are sudden and violent shakings of the ground caused by movements within the earth\'s crust. Understanding proper safety measures can significantly reduce injury risk and save lives during these unpredictable natural disasters.',
      'videoAsset': 'assets/video/earthquake_video.mp4',
      'color': const Color(0xFFFF6B35),
      'icon': Icons.blur_on,
      'tips': [
        'Drop, Cover, and Hold On during shaking',
        'Stay away from windows and heavy objects',
        'Have an emergency kit ready with supplies',
        'Know safe spots in each room of your home',
        'Secure heavy furniture to walls',
        'Practice earthquake drills regularly',
      ],
      'questions': [
        {
          'question': 'What is the correct action during an earthquake?',
          'options': [
            'Drop, Cover, and Hold On',
            'Run Outside Immediately',
            'Stand in a Doorway',
            'Hide in a Closet'
          ],
          'correctAnswer': 0,
          'explanation':
          'Drop, Cover, and Hold On is the internationally recommended action. It protects you from falling debris and helps you stay in place during shaking.',
          'difficulty': 'easy',
        },
        {
          'question': 'Where is the safest place during an earthquake?',
          'options': [
            'Near a window',
            'Under a sturdy table',
            'In an elevator',
            'On stairs'
          ],
          'correctAnswer': 1,
          'explanation':
          'A sturdy table provides protection from falling objects. Stay away from windows, elevators, and stairs during earthquakes.',
          'difficulty': 'medium',
        },
        {
          'question': 'If trapped under debris, what should you do?',
          'options': [
            'Shout loudly',
            'Tap on a pipe or wall',
            'Light a match',
            'Move around'
          ],
          'correctAnswer': 1,
          'explanation':
          'Tapping on pipes or walls helps rescuers locate you while conserving energy. Shouting can cause you to inhale dangerous dust.',
          'difficulty': 'hard',
        },
        {
          'question': 'How long should you stay in a safe position after shaking stops?',
          'options': [
            'Stand up immediately',
            'Wait a few minutes for aftershocks',
            'Wait for official clearance',
            'Leave the building right away'
          ],
          'correctAnswer': 1,
          'explanation':
          'Aftershocks are common after earthquakes. Wait a few minutes and be prepared to Drop, Cover, and Hold On again if needed.',
          'difficulty': 'medium',
        },
        {
          'question': 'What should be in your earthquake emergency kit?',
          'options': [
            'Only food and water',
            'Water, food, first aid, flashlight, radio',
            'Just a flashlight',
            'Only medications'
          ],
          'correctAnswer': 1,
          'explanation':
          'A comprehensive emergency kit should include water (1 gallon per person per day), non-perishable food, first aid supplies, flashlight, battery-powered radio, and essential medications.',
          'difficulty': 'easy',
        },
      ],
    },
    'flood': {
      'title': 'Flood Preparedness',
      'description':
      'Floods are the most common natural disaster worldwide. They can develop slowly or flash flood within minutes. Understanding flood risks, evacuation procedures, and water safety can protect you and your family.',
      'videoAsset': 'assets/video/flood_video.mp4',
      'color': const Color(0xFF4ECDC4),
      'icon': Icons.water_damage,
      'tips': [
        'Never walk or drive through flood water',
        'Move to higher ground immediately when warned',
        'Turn off utilities before evacuating',
        'Keep emergency supplies on upper floors',
        'Monitor weather alerts continuously',
        'Know your evacuation routes',
      ],
      'questions': [
        {
          'question': 'What should you do during a flood warning?',
          'options': [
            'Stay and monitor',
            'Move to higher ground',
            'Check on neighbors',
            'Wait for water'
          ],
          'correctAnswer': 1,
          'explanation':
          'Always move to higher ground immediately when a flood warning is issued. Don\'t wait for visible flooding.',
          'difficulty': 'easy',
        },
        {
          'question': 'How much moving water can sweep a car away?',
          'options': ['3 feet', '2 feet', '1 foot', '6 inches'],
          'correctAnswer': 2,
          'explanation':
          'Just 1 foot of moving water can sweep away most vehicles. Never drive through flooded roads - turn around, don\'t drown!',
          'difficulty': 'medium',
        },
        {
          'question': 'After a flood, before entering your home:',
          'options': [
            'Rush in quickly',
            'Check for damage',
            'Turn on lights',
            'Use candles'
          ],
          'correctAnswer': 1,
          'explanation':
          'Always check for structural damage, gas leaks, and electrical hazards before entering. Have authorities inspect if unsure.',
          'difficulty': 'hard',
        },
      ],
    },
    'fire': {
      'title': 'Fire Safety',
      'description':
      'Fire safety knowledge is crucial for preventing fires and responding effectively when they occur. Understanding fire behavior, prevention methods, and evacuation procedures can save lives.',
      'videoAsset': 'assets/video/fire_video.mp4',
      'color': const Color(0xFFFF5252),
      'icon': Icons.local_fire_department,
      'tips': [
        'Install smoke alarms on every level',
        'Plan and practice escape routes',
        'Keep fire extinguishers accessible',
        'Never leave cooking unattended',
        'Check electrical cords regularly',
        'Keep flammable materials away from heat',
      ],
      'questions': [
        {
          'question': 'What does PASS stand for when using a fire extinguisher?',
          'options': [
            'Pull, Aim, Squeeze, Sweep',
            'Point, Activate, Spray, Stop',
            'Prepare, Alert, Spray, Safety',
            'Pull, Alert, Squeeze, Stop'
          ],
          'correctAnswer': 0,
          'explanation':
          'PASS stands for Pull the pin, Aim at the base of the fire, Squeeze the handle, and Sweep from side to side.',
          'difficulty': 'medium',
        },
        {
          'question': 'If your clothes catch fire, you should:',
          'options': [
            'Run to get help',
            'Stop, Drop, and Roll',
            'Jump in water',
            'Wave your arms'
          ],
          'correctAnswer': 1,
          'explanation':
          'Stop, Drop, and Roll is the correct technique. Running makes the fire worse by feeding it oxygen.',
          'difficulty': 'easy',
        },
      ],
    },
    'cyclone': {
      'title': 'Cyclone Awareness',
      'description':
      'Cyclones are powerful rotating storm systems with high winds and heavy rain. Understanding cyclone formation, warning systems, and shelter procedures is essential for coastal communities.',
      'videoAsset': 'assets/video/cyclone_video.mp4',
      'color': const Color(0xFF9B59B6),
      'icon': Icons.tornado,
      'tips': [
        'Know your cyclone shelter location',
        'Prepare emergency supplies in advance',
        'Secure outdoor items before the storm',
        'Board up windows and doors',
        'Stay indoors during the cyclone',
        'Monitor official weather updates',
      ],
      'questions': [
        {
          'question': 'What is the safest room during a cyclone?',
          'options': [
            'Room with windows',
            'Interior room without windows',
            'Basement near exit',
            'Top floor room'
          ],
          'correctAnswer': 1,
          'explanation':
          'An interior room without windows on the lowest floor provides the best protection from high winds and flying debris.',
          'difficulty': 'medium',
        },
      ],
    },
    'firstaid': {
      'title': 'First Aid Basics',
      'description':
      'First aid skills are essential life-saving techniques everyone should know. Quick and correct first aid can prevent complications, reduce recovery time, and save lives in emergency situations.',
      'videoAsset': 'assets/video/firstaid_video.mp4',
      'color': const Color(0xFF2ECC71),
      'icon': Icons.medical_services,
      'tips': [
        'Always ensure scene safety first',
        'Call emergency services immediately',
        'Apply pressure to stop bleeding',
        'Keep the victim calm and comfortable',
        'Don\'t move injured persons unnecessarily',
        'Know CPR and basic life support',
      ],
      'questions': [
        {
          'question': 'What is the correct compression rate for CPR?',
          'options': [
            '50-60 per minute',
            '80-100 per minute',
            '100-120 per minute',
            '140-160 per minute'
          ],
          'correctAnswer': 2,
          'explanation':
          'The correct rate is 100-120 compressions per minute. This can be remembered by the beat of "Stayin\' Alive" by the Bee Gees.',
          'difficulty': 'hard',
        },
        {
          'question': 'For a severe burn, you should:',
          'options': [
            'Apply ice directly',
            'Apply butter or oil',
            'Cool with running water',
            'Pop any blisters'
          ],
          'correctAnswer': 2,
          'explanation':
          'Cool the burn with cool (not cold) running water for at least 10-20 minutes. Never use ice, butter, or oil.',
          'difficulty': 'medium',
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
      duration: const Duration(milliseconds: 1000),
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

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutCubic),
    );

    _cardAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _cardController.forward();
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
      });
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final questions = _moduleData[widget.moduleType]!['questions'] as List;
    final progress = ((_questionIndex + 1) / questions.length * 100).round();
    await prefs.setInt('${widget.moduleType}_score', _score);
    await prefs.setInt('${widget.moduleType}_progress', progress);
    await prefs.setInt('${widget.moduleType}_streak', _streak);
  }

  Future<void> _saveBadge(String badge) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('badge_${widget.moduleType}', badge);
  }

  void _checkAnswer(int selectedIndex) {
    if (_isAnswered) return;

    final questions = _moduleData[widget.moduleType]!['questions'] as List;
    final correctAnswer = questions[_questionIndex]['correctAnswer'] as int;
    final isCorrect = selectedIndex == correctAnswer;

    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswered = true;
      _showExplanation = true;

      if (isCorrect) {
        _score += 10;
        _streak++;
        if (_streak >= 3) {
          _showConfetti = true;
          _confettiController.forward(from: 0);
        }
      } else {
        _streak = 0;
      }
    });

    _progressController.forward(from: 0);
    _saveProgress();

    // Check for badge
    if (_questionIndex == questions.length - 1) {
      _determineBadge(questions.length);
    }
  }

  void _determineBadge(int totalQuestions) {
    final percentage = (_score / (totalQuestions * 10) * 100).round();
    String badge;

    if (percentage >= 80) {
      badge = 'Expert';
    } else if (percentage >= 50) {
      badge = 'Learner';
    } else {
      badge = 'Beginner';
    }

    setState(() => _earnedBadge = badge);
    _saveBadge(badge);
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  _earnedBadge == 'Expert'
                      ? Icons.emoji_events
                      : _earnedBadge == 'Learner'
                      ? Icons.school
                      : Icons.book,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Quiz Completed!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You earned the $_earnedBadge badge!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildStatRow(Icons.stars, 'Score', '$_score points', color),
                    const SizedBox(height: 12),
                    _buildStatRow(Icons.check_circle, 'Accuracy', '$percentage%', color),
                    const SizedBox(height: 12),
                    _buildStatRow(Icons.local_fire_department, 'Best Streak', '$_streak', color),
                  ],
                ),
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
                          _score = 0;
                          _streak = 0;
                          _isAnswered = false;
                          _selectedAnswerIndex = -1;
                          _showVideo = true;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Review',
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final moduleData = _moduleData[widget.moduleType];

    if (moduleData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Module Not Found')),
        body: const Center(child: Text('This learning module is not available.')),
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
              _buildAppBar(moduleData, size, color, questions.length),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_showVideo) ...[
                        _buildVideoSection(moduleData, size, color),
                      ] else ...[
                        _buildQuizSection(questions, size, color),
                      ],
                    ],
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

  Widget _buildAppBar(Map<String, dynamic> moduleData, Size size, Color color, int totalQuestions) {
    return SliverAppBar(
      expandedHeight: size.height * 0.25,
      floating: false,
      pinned: true,
      backgroundColor: color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          moduleData['title'],
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.042,
            fontWeight: FontWeight.w700,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_showVideo)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Streak: $_streak',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.stars, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Score: $_score',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(_showVideo ? Icons.quiz : Icons.play_circle_outline),
            onPressed: () {
              setState(() {
                _showVideo = !_showVideo;
                if (!_showVideo) {
                  _cardController.forward(from: 0);
                }
              });
            },
            tooltip: _showVideo ? 'Take Quiz' : 'Watch Video',
          ),
        ),
      ],
      bottom: !_showVideo
          ? PreferredSize(
        preferredSize: const Size.fromHeight(6),
        child: Container(
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildVideoSection(Map<String, dynamic> moduleData, Size size, Color color) {
    final tips = List<String>.from(moduleData['tips']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      moduleData['icon'],
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About This Module',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Essential knowledge for safety',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                moduleData['description'],
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.7,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Video Player Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: color,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                      : Container(
                    color: Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.video_library_rounded,
                            size: 60,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Video Learning Module',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Interactive content coming soon',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_controller?.value.isInitialized == true)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildVideoControl(
                        Icons.replay_10,
                            () {
                          final position = _controller!.value.position;
                          _controller!.seekTo(Duration(
                            seconds: (position.inSeconds - 10).clamp(0, _controller!.value.duration.inSeconds),
                          ));
                        },
                        color,
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.8)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
                            });
                          },
                          icon: Icon(
                            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      _buildVideoControl(
                        Icons.forward_10,
                            () {
                          final position = _controller!.value.position;
                          _controller!.seekTo(Duration(
                            seconds: (position.inSeconds + 10).clamp(0, _controller!.value.duration.inSeconds),
                          ));
                        },
                        color,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Key Learning Points
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.05), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.lightbulb, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Key Safety Tips',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...tips.asMap().entries.map((entry) {
                return TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300 + (entry.key * 100)),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.translate(
                      offset: Offset(20 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entry.key + 1}',
                            style: GoogleFonts.poppins(
                              color: color,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey[800],
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // CTA Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _showVideo = false),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.quiz, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Start Quiz Challenge',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoControl(IconData icon, VoidCallback onPressed, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 28,
      ),
    );
  }

  Widget _buildQuizSection(List<Map<String, dynamic>> questions, Size size, Color color) {
    if (_questionIndex >= questions.length) return const SizedBox();

    final question = questions[_questionIndex];
    final options = List<String>.from(question['options']);
    final correctAnswer = question['correctAnswer'] as int;
    final difficulty = question['difficulty'] as String;

    return ScaleTransition(
      scale: _cardAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Progress
          Row(
            children: [
              Expanded(
                child: Text(
                  'Question ${_questionIndex + 1} of ${questions.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      difficulty == 'easy'
                          ? Colors.green
                          : difficulty == 'medium'
                          ? Colors.orange
                          : Colors.red,
                      difficulty == 'easy'
                          ? Colors.green.shade300
                          : difficulty == 'medium'
                          ? Colors.orange.shade300
                          : Colors.red.shade300,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      difficulty == 'easy'
                          ? Icons.sentiment_satisfied
                          : difficulty == 'medium'
                          ? Icons.sentiment_neutral
                          : Icons.sentiment_very_dissatisfied,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      difficulty.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  question['question'],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Answer Options
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = _selectedAnswerIndex == index;
            final isCorrect = index == correctAnswer;
            final showResult = _isAnswered;

            Color cardColor = Colors.white;
            Color borderColor = Colors.grey[300]!;
            Color textColor = Colors.grey[800]!;
            IconData? resultIcon;

            if (showResult) {
              if (isSelected) {
                if (isCorrect) {
                  cardColor = Colors.green.shade50;
                  borderColor = Colors.green;
                  textColor = Colors.green.shade900;
                  resultIcon = Icons.check_circle;
                } else {
                  cardColor = Colors.red.shade50;
                  borderColor = Colors.red;
                  textColor = Colors.red.shade900;
                  resultIcon = Icons.cancel;
                }
              } else if (isCorrect) {
                cardColor = Colors.green.shade50;
                borderColor = Colors.green;
                textColor = Colors.green.shade900;
                resultIcon = Icons.check_circle;
              }
            } else if (isSelected) {
              borderColor = color;
              cardColor = color.withOpacity(0.05);
            }

            return TweenAnimationBuilder(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(30 * (1 - value), 0),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showResult ? null : () => _checkAnswer(index),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: borderColor.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: showResult && (isSelected || isCorrect)
                                  ? borderColor.withOpacity(0.2)
                                  : color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: showResult && (isSelected || isCorrect) ? borderColor : color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              option,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (resultIcon != null) ...[
                            const SizedBox(width: 12),
                            Icon(resultIcon, color: borderColor, size: 28),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),

          if (_showExplanation) ...[
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (_selectedAnswerIndex == correctAnswer ? Colors.green : Colors.orange).withOpacity(0.1),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (_selectedAnswerIndex == correctAnswer ? Colors.green : Colors.orange).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (_selectedAnswerIndex == correctAnswer ? Colors.green : Colors.orange)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _selectedAnswerIndex == correctAnswer ? Icons.psychology : Icons.info_outline,
                          color: _selectedAnswerIndex == correctAnswer ? Colors.green : Colors.orange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedAnswerIndex == correctAnswer ? 'Great Job!' : 'Learn More',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question['explanation'],
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: color.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _questionIndex < questions.length - 1 ? 'Next Question' : 'Complete Quiz',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ],
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
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    for (int i = 0; i < 50; i++) {
      final random = math.Random(i);
      final x = size.width * random.nextDouble();
      final y = size.height * progress * (0.5 + random.nextDouble());
      final rotation = progress * math.pi * 4 * random.nextDouble();
      final color = colors[random.nextInt(colors.length)];

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      final paint = Paint()
        ..color = color.withOpacity((1 - progress).clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-5, -5, 10, 10),
          const Radius.circular(2),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}