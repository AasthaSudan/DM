// lib/screens/drills_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class DrillsPage extends StatefulWidget {
  const DrillsPage({super.key});

  @override
  State<DrillsPage> createState() => _DrillsPageState();
}

class _DrillsPageState extends State<DrillsPage> {
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
                    const Icon(Icons.sports_martial_arts, color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Safety Drills',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Practice makes perfect - Stay prepared',
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
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildDrillCard(
                        context,
                        'Earthquake Drop Drill',
                        'Practice the Drop, Cover, and Hold On technique',
                        Icons.blur_on,
                        const Color(0xFFFF9800),
                        'earthquake',
                        45,
                      ),
                      _buildDrillCard(
                        context,
                        'Fire Evacuation Drill',
                        'Practice quick and safe evacuation procedures',
                        Icons.local_fire_department,
                        const Color(0xFFF44336),
                        'fire',
                        120,
                      ),
                      _buildDrillCard(
                        context,
                        'Flood Response Drill',
                        'Practice moving to higher ground quickly',
                        Icons.water,
                        const Color(0xFF2196F3),
                        'flood',
                        60,
                      ),
                      _buildDrillCard(
                        context,
                        'Cyclone Shelter Drill',
                        'Practice moving to interior safe room',
                        Icons.tornado,
                        const Color(0xFF9C27B0),
                        'cyclone',
                        90,
                      ),
                      _buildDrillCard(
                        context,
                        'First Aid Practice',
                        'Practice basic first aid techniques',
                        Icons.medical_services,
                        const Color(0xFF21C573),
                        'firstaid',
                        180,
                      ),
                      _buildDrillCard(
                        context,
                        'Emergency Communication',
                        'Practice contacting emergency services',
                        Icons.phone_in_talk,
                        const Color(0xFF00BCD4),
                        'communication',
                        30,
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

  Widget _buildDrillCard(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      Color color,
      String drillType,
      int durationSeconds,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrillDetailPage(
                title: title,
                description: description,
                icon: icon,
                color: color,
                drillType: drillType,
                durationSeconds: durationSeconds,
              ),
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
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${(durationSeconds / 60).ceil()} min drill',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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
                    Icons.play_arrow,
                    color: Color(0xFF21C573),
                    size: 24,
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

class DrillDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String drillType;
  final int durationSeconds;

  const DrillDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.drillType,
    required this.durationSeconds,
  });

  @override
  State<DrillDetailPage> createState() => _DrillDetailPageState();
}

class _DrillDetailPageState extends State<DrillDetailPage> {
  bool _isRunning = false;
  bool _isCompleted = false;
  int _currentStep = 0;
  int _remainingSeconds = 0;
  Timer? _timer;

  final Map<String, List<Map<String, String>>> _drillSteps = {
    'earthquake': [
      {'title': 'DROP', 'instruction': 'Drop down onto your hands and knees'},
      {'title': 'COVER', 'instruction': 'Cover your head and neck with your arms'},
      {'title': 'HOLD ON', 'instruction': 'Hold on to something sturdy and stay put'},
      {'title': 'STAY DOWN', 'instruction': 'Stay in position until shaking stops'},
      {'title': 'ASSESS', 'instruction': 'Check yourself and others for injuries'},
    ],
    'fire': [
      {'title': 'ALERT', 'instruction': 'Shout "Fire!" to alert others'},
      {'title': 'STAY LOW', 'instruction': 'Get down low to avoid smoke'},
      {'title': 'FEEL DOORS', 'instruction': 'Check if doors are hot before opening'},
      {'title': 'EXIT QUICKLY', 'instruction': 'Use nearest safe exit route'},
      {'title': 'MEET OUTSIDE', 'instruction': 'Go to designated meeting point'},
      {'title': 'CALL 911', 'instruction': 'Call emergency services from safe location'},
    ],
    'flood': [
      {'title': 'ASSESS', 'instruction': 'Evaluate water level and rising speed'},
      {'title': 'GATHER', 'instruction': 'Grab emergency kit and important items'},
      {'title': 'MOVE UP', 'instruction': 'Move to higher ground immediately'},
      {'title': 'AVOID WATER', 'instruction': 'Never walk through moving water'},
      {'title': 'SIGNAL', 'instruction': 'Signal for help if trapped'},
    ],
    'cyclone': [
      {'title': 'SECURE', 'instruction': 'Close all windows and doors'},
      {'title': 'INTERIOR', 'instruction': 'Move to interior room on lowest floor'},
      {'title': 'COVER', 'instruction': 'Get under sturdy furniture'},
      {'title': 'PROTECT', 'instruction': 'Use blankets to protect from debris'},
      {'title': 'STAY PUT', 'instruction': 'Stay sheltered until all clear'},
    ],
    'firstaid': [
      {'title': 'ASSESS', 'instruction': 'Check scene safety and victim condition'},
      {'title': 'CALL HELP', 'instruction': 'Call 911 or emergency services'},
      {'title': 'AIRWAY', 'instruction': 'Ensure airway is clear'},
      {'title': 'BREATHING', 'instruction': 'Check if person is breathing'},
      {'title': 'CIRCULATION', 'instruction': 'Check pulse and stop bleeding'},
      {'title': 'COMFORT', 'instruction': 'Keep person comfortable and calm'},
    ],
    'communication': [
      {'title': 'STAY CALM', 'instruction': 'Take a deep breath and stay calm'},
      {'title': 'DIAL 911', 'instruction': 'Dial emergency number clearly'},
      {'title': 'STATE EMERGENCY', 'instruction': 'Clearly state type of emergency'},
      {'title': 'GIVE LOCATION', 'instruction': 'Provide exact location'},
      {'title': 'ANSWER QUESTIONS', 'instruction': 'Answer dispatcher questions'},
      {'title': 'STAY ON LINE', 'instruction': 'Don\'t hang up until told'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startDrill() {
    setState(() {
      _isRunning = true;
      _currentStep = 0;
      _remainingSeconds = widget.durationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _completeDrill();
        }
      });
    });
  }

  void _completeDrill() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });

    _showCompletionDialog();
  }

  void _nextStep() {
    final steps = _drillSteps[widget.drillType] ?? [];
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeDrill();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _resetDrill() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = false;
      _currentStep = 0;
      _remainingSeconds = widget.durationSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final steps = _drillSteps[widget.drillType] ?? [];

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
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_isRunning)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
                  child: Column(
                    children: [
                      if (!_isRunning && !_isCompleted) ...[
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          widget.color.withOpacity(0.2),
                                          widget.color.withOpacity(0.1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(widget.icon, size: 80, color: widget.color),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  widget.description,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF2C3E50),
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  'Drill Steps',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ...steps.asMap().entries.map((entry) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: widget.color.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: widget.color.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: widget.color,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${entry.key + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                entry.value['title']!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                entry.value['instruction']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                            width: double.infinity,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [widget.color, widget.color.withOpacity(0.8)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _startDrill,
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Start Drill'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else if (_isRunning) ...[
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.color.withOpacity(0.1),
                                      widget.color.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Step ${_currentStep + 1} of ${steps.length}',
                                      style: TextStyle(
                                        color: widget.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    LinearProgressIndicator(
                                      value: (_currentStep + 1) / steps.length,
                                      backgroundColor: Colors.grey.shade200,
                                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          color: widget.color,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${_currentStep + 1}',
                                          style: const TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                      Text(
                                        steps[_currentStep]['title']!,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: widget.color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        steps[_currentStep]['instruction']!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF2C3E50),
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    if (_currentStep > 0)
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: _previousStep,
                                          icon: const Icon(Icons.arrow_back),
                                          label: const Text('Previous'),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            side: BorderSide(color: widget.color),
                                            foregroundColor: widget.color,
                                          ),
                                        ),
                                      ),
                                    if (_currentStep > 0) const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [widget.color, widget.color.withOpacity(0.8)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ElevatedButton.icon(
                                          onPressed: _nextStep,
                                          icon: Icon(
                                            _currentStep == steps.length - 1
                                                ? Icons.check
                                                : Icons.arrow_forward,
                                          ),
                                          label: Text(
                                            _currentStep == steps.length - 1
                                                ? 'Complete'
                                                : 'Next Step',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            shadowColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _showCompletionDialog() {
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
                color: widget.color,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Drill Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 64, color: widget.color),
            const SizedBox(height: 16),
            const Text(
              'Great job! You\'ve completed this safety drill.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Practice regularly to stay prepared for emergencies.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetDrill();
            },
            child: const Text('Practice Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}