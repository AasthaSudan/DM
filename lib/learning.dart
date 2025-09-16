import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              // Custom Header
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

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildLearningCard(
                        context,
                        'Earthquake Safety',
                        'Learn how to prepare for and respond to earthquakes',
                        Icons.blur_on,
                        const Color(0xFFFF9800),
                            () => _navigateToModule(context, 'earthquake'),
                      ),
                      _buildLearningCard(
                        context,
                        'Flood Preparedness',
                        'Essential knowledge about flood safety and evacuation',
                        Icons.water,
                        const Color(0xFF2196F3),
                            () => _navigateToModule(context, 'flood'),
                      ),
                      _buildLearningCard(
                        context,
                        'Fire Safety',
                        'Fire prevention and emergency response techniques',
                        Icons.local_fire_department,
                        const Color(0xFFF44336),
                            () => _navigateToModule(context, 'fire'),
                      ),
                      _buildLearningCard(
                        context,
                        'Cyclone Awareness',
                        'Understanding cyclones and protective measures',
                        Icons.tornado,
                        const Color(0xFF9C27B0),
                            () => _navigateToModule(context, 'cyclone'),
                      ),
                      _buildLearningCard(
                        context,
                        'First Aid Basics',
                        'Essential first aid skills for emergency situations',
                        Icons.medical_services,
                        const Color(0xFF21C573),
                            () => _navigateToModule(context, 'firstaid'),
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

  Widget _buildLearningCard(
      BuildContext context,
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 120,
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
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
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
                    ],
                  ),
                ),
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

  void _navigateToModule(BuildContext context, String moduleType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningModulePage(moduleType: moduleType),
      ),
    );
  }
}

class LearningModulePage extends StatefulWidget {
  final String moduleType;

  const LearningModulePage({super.key, required this.moduleType});

  @override
  _LearningModulePageState createState() => _LearningModulePageState();
}

class _LearningModulePageState extends State<LearningModulePage> {
  VideoPlayerController? _controller;
  int _score = 0;
  int _questionIndex = 0;
  bool _isAnswered = false;
  bool _showVideo = true;

  Map<String, Map<String, dynamic>> _moduleData = {
    'earthquake': {
      'title': 'Earthquake Safety',
      'description': 'An earthquake is a sudden and violent shaking of the ground, sometimes causing great destruction, as a result of movements within the earth\'s crust or volcanic action. Learning how to respond can save lives.',
      'videoAsset': 'assets/video/earthquake_video.mp4',
      'questions': [
        {
          'question': 'What should you do during an earthquake?',
          'options': ['Drop, Cover, and Hold On', 'Run Outside', 'Stay Standing'],
          'correctAnswer': 0,
        },
        {
          'question': 'Where is the safest place to be during an earthquake?',
          'options': ['Under a doorway', 'Under a sturdy table', 'In an elevator'],
          'correctAnswer': 1,
        },
      ],
    },
    'flood': {
      'title': 'Flood Preparedness',
      'description': 'Floods are among the most frequent and costly natural disasters. Understanding flood risks and knowing how to respond can protect you and your family.',
      'videoAsset': 'assets/video/flood_video.mp4',
      'questions': [
        {
          'question': 'What should you do during a flood?',
          'options': ['Stay in place', 'Move to higher ground', 'Open windows'],
          'correctAnswer': 1,
        },
        {
          'question': 'How much water can knock you down?',
          'options': ['1 foot', '6 inches', '2 feet'],
          'correctAnswer': 1,
        },
      ],
    },
    'fire': {
      'title': 'Fire Safety',
      'description': 'Fire safety involves measures to prevent fires and reduce their harmful effects. Quick response and proper knowledge can save lives and property.',
      'videoAsset': 'assets/video/fire_video.mp4',
      'questions': [
        {
          'question': 'What should you do if your clothes catch fire?',
          'options': ['Run for help', 'Stop, Drop, and Roll', 'Pour water on yourself'],
          'correctAnswer': 1,
        },
        {
          'question': 'How often should you test smoke detectors?',
          'options': ['Monthly', 'Yearly', 'Every 6 months'],
          'correctAnswer': 0,
        },
      ],
    },
    'cyclone': {
      'title': 'Cyclone Awareness',
      'description': 'Cyclones are powerful storms that can cause widespread destruction. Understanding cyclone behavior and safety measures is crucial for coastal communities.',
      'videoAsset': 'assets/video/cyclone_video.mp4',
      'questions': [
        {
          'question': 'What is the safest place during a cyclone?',
          'options': ['Near windows', 'Interior room on lowest floor', 'Outside'],
          'correctAnswer': 1,
        },
        {
          'question': 'When should you evacuate during a cyclone warning?',
          'options': ['When authorities advise', 'Never', 'Only if flooding occurs'],
          'correctAnswer': 0,
        },
      ],
    },
    'firstaid': {
      'title': 'First Aid Basics',
      'description': 'First aid is the immediate assistance given to someone who is injured or suddenly taken ill. Basic first aid knowledge can be life-saving in emergency situations.',
      'videoAsset': 'assets/video/firstaid_video.mp4',
      'questions': [
        {
          'question': 'What is the first step in treating a wound?',
          'options': ['Apply bandage', 'Clean your hands', 'Apply pressure'],
          'correctAnswer': 1,
        },
        {
          'question': 'How should you treat a burn?',
          'options': ['Apply ice', 'Run cool water over it', 'Apply butter'],
          'correctAnswer': 1,
        },
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _loadProgress();
  }

  _initializeVideoPlayer() {
    final videoAsset = _moduleData[widget.moduleType]?['videoAsset'];
    if (videoAsset != null) {
      _controller = VideoPlayerController.asset(videoAsset)
        ..initialize().then((_) {
          setState(() {});
        }).catchError((error) {
          // Handle video initialization error gracefully
          print('Video initialization error: $error');
        });
    }
  }

  _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getInt('${widget.moduleType}_score') ?? 0;
    });
  }

  _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.moduleType}_score', _score);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moduleData = _moduleData[widget.moduleType];
    if (moduleData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Module Not Found'),
          backgroundColor: const Color(0xFF21C573),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('This learning module is not available.')),
      );
    }

    final questions = List<Map<String, dynamic>>.from(moduleData['questions']);

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
              // Custom Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        moduleData['title'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _showVideo ? Icons.quiz : Icons.play_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _showVideo = !_showVideo;
                            if (!_showVideo) {
                              _questionIndex = 0;
                              _isAnswered = false;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showVideo) ...[
                          // Video Learning Section
                          Container(
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
                            child: Text(
                              moduleData['description'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF2C3E50),
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Video Player Section
                          Container(
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _controller?.value.isInitialized == true
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: VideoPlayer(_controller!),
                            )
                                : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF21C573).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.video_library,
                                      size: 48,
                                      color: Color(0xFF21C573),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Video content will be available soon',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (_controller?.value.isInitialized == true)
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (_controller!.value.isPlaying) {
                                        _controller!.pause();
                                      } else {
                                        _controller!.play();
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  ),
                                  label: Text(
                                    _controller!.value.isPlaying ? 'Pause' : 'Play',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ] else ...[
                          // Quiz Section
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Question ${_questionIndex + 1}/${questions.length}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF21C573).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Score: $_score',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF21C573),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  questions[_questionIndex]['question'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ...questions[_questionIndex]['options']
                                    .asMap()
                                    .entries
                                    .map<Widget>((entry) {
                                  int index = entry.key;
                                  String option = entry.value;
                                  bool isCorrect = index == questions[_questionIndex]['correctAnswer'];

                                  return GestureDetector(
                                    onTap: () {
                                      if (!_isAnswered) {
                                        setState(() {
                                          if (isCorrect) {
                                            _score++;
                                          }
                                          _isAnswered = true;
                                        });
                                        _saveProgress();
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: _isAnswered && isCorrect
                                            ? LinearGradient(
                                          colors: [
                                            Colors.green.withOpacity(0.1),
                                            Colors.green.withOpacity(0.05),
                                          ],
                                        )
                                            : null,
                                        color: _isAnswered && isCorrect
                                            ? null
                                            : Colors.grey.shade50,
                                        border: Border.all(
                                          color: _isAnswered && isCorrect
                                              ? Colors.green
                                              : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _isAnswered && isCorrect
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: _isAnswered && isCorrect
                                                    ? Colors.green
                                                    : Colors.grey.shade400,
                                                width: 2,
                                              ),
                                            ),
                                            child: _isAnswered && isCorrect
                                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                                : null,
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xFF2C3E50),
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

                          // Next Question or Finish Quiz Button
                          if (_isAnswered)
                            SizedBox(
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF21C573), Color(0xFF1791B6)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_questionIndex < questions.length - 1) {
                                        _questionIndex++;
                                        _isAnswered = false;
                                      } else {
                                        _showCompletionDialog();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    _questionIndex == questions.length - 1
                                        ? 'Finish Quiz'
                                        : 'Next Question',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                        ],
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

  void _showCompletionDialog() {
    final questions = _moduleData[widget.moduleType]!['questions'] as List;
    final percentage = (_score / questions.length * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: percentage >= 70 ? Colors.green : Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Icon(
                percentage >= 70 ? Icons.celebration : Icons.info_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Quiz Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              'Your Score: $_score/${questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: percentage >= 70
                      ? [Colors.green.withOpacity(0.2), Colors.green.withOpacity(0.1)]
                      : [Colors.orange.withOpacity(0.2), Colors.orange.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 70 ? Colors.green : Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 70
                  ? 'Great job! You have a good understanding of ${widget.moduleType} safety.'
                  : 'Consider reviewing the material and trying again to improve your understanding.',
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _questionIndex = 0;
                _isAnswered = false;
                _score = 0;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Retake Quiz'),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF21C573), Color(0xFF1791B6)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue Learning'),
            ),
          ),
        ],
      ),
    );
  }
}