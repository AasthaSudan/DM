import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_service.dart';

class LearningModulePage extends StatefulWidget {
  final String moduleType;

  const LearningModulePage({Key? key, required this.moduleType}) : super(key: key);

  @override
  State<LearningModulePage> createState() => _LearningModulePageState();
}

class _LearningModulePageState extends State<LearningModulePage> {
  int _questionIndex = 0;
  bool _isAnswered = false;
  bool _showVideo = true;
  double _progress = 0.0;
  String? _earnedBadge;
  int _correctAnswers = 0;

  final List<Map<String, Object>> questions = [
    {
      'question': 'What should you do first during an earthquake?',
      'answers': [
        {'text': 'Run outside immediately', 'isCorrect': false},
        {'text': 'Take cover under sturdy furniture', 'isCorrect': true},
        {'text': 'Stand near windows', 'isCorrect': false},
        {'text': 'Use elevators', 'isCorrect': false},
      ],
    },
    {
      'question': 'If trapped under debris, what is the safest thing to do?',
      'answers': [
        {'text': 'Shout loudly', 'isCorrect': false},
        {'text': 'Tap on a pipe or wall', 'isCorrect': true},
        {'text': 'Light a match', 'isCorrect': false},
        {'text': 'Move around to find an exit', 'isCorrect': false},
      ],
    },
  ];

  void _answerQuestion(bool isCorrect) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      if (isCorrect) _correctAnswers++;
    });
  }

  Future<void> _showCompletionDialog() async {
    final percentage = (_correctAnswers / questions.length) * 100;

    if (percentage >= 80) {
      _earnedBadge = 'Expert';
    } else if (percentage >= 50) {
      _earnedBadge = 'Learner';
    } else {
      _earnedBadge = 'Beginner';
    }

    // Save earned badge
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('badge_${widget.moduleType}', _earnedBadge!);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Quiz Completed!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF21C573),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You scored ${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Text(
              percentage >= 70
                  ? 'Great job! You have a good understanding of ${widget.moduleType} safety.'
                  : 'Try again to improve your understanding of ${widget.moduleType} safety.',
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4),
            ),
            const SizedBox(height: 12),
            if (_earnedBadge != null)
              Column(
                children: [
                  Text(
                    'You earned the $_earnedBadge Badge!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1791B6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    _earnedBadge == 'Expert'
                        ? Icons.emoji_events
                        : _earnedBadge == 'Learner'
                        ? Icons.school
                        : Icons.book,
                    color: _earnedBadge == 'Expert'
                        ? Colors.amber
                        : _earnedBadge == 'Learner'
                        ? Colors.blueAccent
                        : Colors.grey,
                    size: 40,
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to module list or previous screen
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showBadgesDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final modules = ['earthquake', 'flood', 'fire', 'cyclone', 'firstaid'];

    final badges = <String, String?>{};
    for (var module in modules) {
      badges[module] = prefs.getString('badge_$module');
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        final hasBadges = badges.values.any((b) => b != null);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFF21C573)),
              SizedBox(width: 8),
              Text('My Badges'),
            ],
          ),
          content: hasBadges
              ? SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: badges.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final module = badges.keys.elementAt(index);
                final badge = badges[module];
                if (badge == null) return const SizedBox.shrink();

                final color = badge == 'Expert'
                    ? Colors.amber
                    : badge == 'Learner'
                    ? Colors.blueAccent
                    : Colors.grey;

                final icon = badge == 'Expert'
                    ? Icons.emoji_events
                    : badge == 'Learner'
                    ? Icons.school
                    : Icons.book;

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        badge,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        module[0].toUpperCase() + module.substring(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
              : const Text(
            'No badges earned yet.\nComplete quizzes to unlock achievements!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final moduleTitle =
        '${widget.moduleType[0].toUpperCase()}${widget.moduleType.substring(1)} Module';

    return Scaffold(
      appBar: AppBar(
        title: Text(moduleTitle),
        backgroundColor: const Color(0xFF21C573),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF21C573),
        child: const Icon(Icons.emoji_events, color: Colors.white),
        onPressed: _showBadgesDialog,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _showVideo
              ? Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF21C573),
              ),
              onPressed: () {
                setState(() {
                  _showVideo = false;
                  _progress = 1 / questions.length;
                });
              },
              child: const Text('Start Quiz'),
            ),
          )
              : _buildQuizSection(),
        ),
      ),
    );
  }

  Widget _buildQuizSection() {
    final question = questions[_questionIndex];
    final answers = question['answers'] as List<Map<String, Object>>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${_questionIndex + 1}/${questions.length}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: _progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation(Color(0xFF21C573)),
        ),
        const SizedBox(height: 24),
        Text(
          question['question'] as String,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        ...answers.map((answer) {
          final isCorrect = answer['isCorrect'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnswered
                    ? (isCorrect
                    ? Colors.green
                    : const Color(0xFF1791B6))
                    : const Color(0xFF1791B6),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                _answerQuestion(isCorrect);
              },
              child: Text(answer['text'] as String),
            ),
          );
        }),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_questionIndex < questions.length - 1) {
                  _questionIndex++;
                  _isAnswered = false;
                } else {
                  _showCompletionDialog();
                }
                _progress = (_questionIndex + 1) / questions.length;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C573),
            ),
            child: Text(
              _questionIndex < questions.length - 1 ? 'Next' : 'Finish',
            ),
          ),
        ),
      ],
    );
  }
}
