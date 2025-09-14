import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Learning Modules',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Learn about disaster preparedness and safety',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Learning Modules List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildLearningCard(
                    context,
                    'Earthquake Safety',
                    'Learn how to prepare for and respond to earthquakes',
                    Icons.blur_on,
                    Colors.orange,
                        () => _navigateToModule(context, 'earthquake'),
                  ),
                  _buildLearningCard(
                    context,
                    'Flood Preparedness',
                    'Essential knowledge about flood safety and evacuation',
                    Icons.water,
                    Colors.blue,
                        () => _navigateToModule(context, 'flood'),
                  ),
                  _buildLearningCard(
                    context,
                    'Fire Safety',
                    'Fire prevention and emergency response techniques',
                    Icons.local_fire_department,
                    Colors.red,
                        () => _navigateToModule(context, 'fire'),
                  ),
                  _buildLearningCard(
                    context,
                    'Cyclone Awareness',
                    'Understanding cyclones and protective measures',
                    Icons.tornado,
                    Colors.purple,
                        () => _navigateToModule(context, 'cyclone'),
                  ),
                  _buildLearningCard(
                    context,
                    'First Aid Basics',
                    'Essential first aid skills for emergency situations',
                    Icons.medical_services,
                    Colors.green,
                        () => _navigateToModule(context, 'firstaid'),
                  ),
                ],
              ),
            ),
          ],
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
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(20),
            height: 120,
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 20,
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
          // Handle video initialization error
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
        appBar: AppBar(title: Text('Module Not Found')),
        body: Center(child: Text('This learning module is not available.')),
      );
    }

    final questions = List<Map<String, dynamic>>.from(moduleData['questions']);

    return Scaffold(
      appBar: AppBar(
        title: Text(moduleData['title']),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showVideo ? Icons.quiz : Icons.play_circle),
            onPressed: () {
              setState(() {
                _showVideo = !_showVideo;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                moduleData['title'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              SizedBox(height: 16),

              if (_showVideo) ...[
                // Video Description Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    moduleData['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Video Player Section
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: _controller?.value.isInitialized == true
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VideoPlayer(_controller!),
                  )
                      : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_library,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Video content will be available soon',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                if (_controller?.value.isInitialized == true)
                  Center(
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
                      icon: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_controller!.value.isPlaying ? 'Pause' : 'Play'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                // Quiz Section
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
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
                          Text(
                            'Quiz ${_questionIndex + 1}/${questions.length}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Score: $_score',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        questions[_questionIndex]['question'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(height: 24),
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
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _isAnswered
                                  ? (isCorrect ? Colors.green.shade50 : Colors.grey.shade50)
                                  : Colors.grey.shade50,
                              border: Border.all(
                                color: _isAnswered
                                    ? (isCorrect ? Colors.green : Colors.grey.shade300)
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
                                      ? Icon(Icons.check, color: Colors.white, size: 16)
                                      : null,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade800,
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
                SizedBox(height: 24),

                // Next Question or Finish Quiz Button
                if (_isAnswered)
                  SizedBox(
                    width: double.infinity,
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
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _questionIndex == questions.length - 1
                            ? 'Finish Quiz'
                            : 'Next Question',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              percentage >= 70 ? Icons.celebration : Icons.info_outline,
              color: percentage >= 70 ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 8),
            Text('Quiz Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Score: $_score/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: percentage >= 70 ? Colors.green : Colors.orange,
              ),
            ),
            SizedBox(height: 12),
            Text(
              percentage >= 70
                  ? 'Great job! You have a good understanding of ${widget.moduleType} safety.'
                  : 'Consider reviewing the material and trying again to improve your understanding.',
              textAlign: TextAlign.center,
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
            child: Text('Retake Quiz'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to learning page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: Text('Continue Learning'),
          ),
        ],
      ),
    );
  }
}