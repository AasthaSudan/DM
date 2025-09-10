import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LearningPage extends StatefulWidget {
  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late VideoPlayerController _controller;
  int _score = 0;
  int _questionIndex = 0;
  bool _isAnswered = false;

  List<Map<String, dynamic>> _quizQuestions = [
    {
      'question': 'What should you do during an earthquake?',
      'options': ['Drop, Cover, and Hold On', 'Run Outside', 'Stay Standing'],
      'correctAnswer': 0,
    },
    {
      'question': 'What to do during a flood?',
      'options': ['Stay in place', 'Move to higher ground', 'Open windows'],
      'correctAnswer': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/disaster_video.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _loadProgress(); // Load the progress when the page is initialized
  }

  // Load user progress (score from SharedPreferences)
  _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getInt('score') ?? 0;
    });
  }

  // Save user progress
  _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('score', _score); // Save score
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disaster Preparedness - Learning')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Learn About Earthquakes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Text Description
            Text(
              'An earthquake is a sudden and violent shaking of the ground...',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            // Video Player
            Container(
              height: 200,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 20),

            // Quiz Section
            Text(
              _quizQuestions[_questionIndex]['question'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ..._quizQuestions[_questionIndex]['options']
                .map<Widget>((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<int>(
                  value: _quizQuestions[_questionIndex]['options'].indexOf(option),
                  groupValue: _isAnswered ? _quizQuestions[_questionIndex]['correctAnswer'] : -1,
                  onChanged: (int? value) {
                    setState(() {
                      if (!_isAnswered) {
                        if (value == _quizQuestions[_questionIndex]['correctAnswer']) {
                          _score++;
                        }
                        _isAnswered = true; // Disable further changes
                      }
                    });
                    _saveProgress(); // Save score after each question
                  },
                ),
              );
            }).toList(),

            SizedBox(height: 20),

            // Show current score
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Next Question Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_questionIndex < _quizQuestions.length - 1) {
                    _questionIndex++;
                    _isAnswered = false; // Reset for next question
                  } else {
                    // End of quiz logic
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Quiz Finished'),
                        content: Text('Your final score is: $_score'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              child: Text(
                _questionIndex == _quizQuestions.length - 1 ? 'Finish Quiz' : 'Next Question',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
