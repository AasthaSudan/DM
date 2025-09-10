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
    _loadProgress();
  }

  _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _score = prefs.getInt('score') ?? 0;
    });
  }

  _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('score', _score);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disaster Preparedness - Learning'),
        backgroundColor: Colors.deepOrange, // Vibrant app bar color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              'Learn About Earthquakes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            SizedBox(height: 20),

            // Video Description Section
            Text(
              'An earthquake is a sudden and violent shaking of the ground...',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 20),

            // Video Player Section
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.5),
              ),
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 20),

            // Quiz Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(15),
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
                  Text(
                    _quizQuestions[_questionIndex]['question'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ..._quizQuestions[_questionIndex]['options']
                      .map<Widget>((option) {
                    return GestureDetector(
                      onTap: () {
                        if (!_isAnswered) {
                          setState(() {
                            if (_quizQuestions[_questionIndex]['options']
                                .indexOf(option) ==
                                _quizQuestions[_questionIndex]
                                ['correctAnswer']) {
                              _score++;
                            }
                            _isAnswered = true;
                          });
                          _saveProgress();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isAnswered &&
                              _quizQuestions[_questionIndex]['options']
                                  .indexOf(option) ==
                                  _quizQuestions[_questionIndex]
                                  ['correctAnswer']
                              ? Colors.green
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isAnswered &&
                                  _quizQuestions[_questionIndex]['options']
                                      .indexOf(option) ==
                                      _quizQuestions[_questionIndex]
                                      ['correctAnswer']
                                  ? Icons.check_circle
                                  : Icons.radio_button_checked,
                              color: Colors.deepOrange,
                            ),
                            SizedBox(width: 10),
                            Text(
                              option,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Score Display Section
            Text(
              'Score: $_score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 20),

            // Next Question or Finish Quiz Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_questionIndex < _quizQuestions.length - 1) {
                    _questionIndex++;
                    _isAnswered = false;
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Quiz Finished'),
                        content: Text('Your final score is: $_score'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, "/home");
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Set the background color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _questionIndex == _quizQuestions.length - 1
                    ? 'Finish Quiz'
                    : 'Next Question',
                style: TextStyle(fontSize: 16),
              ),
            ),

          ],
        ),
      ),
      backgroundColor: Colors.teal.shade50, // Background color
    );
  }
}
