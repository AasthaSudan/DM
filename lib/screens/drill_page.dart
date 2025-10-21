// lib/screens/drills_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class DrillsPage extends StatefulWidget {
  const DrillsPage({super.key});

  @override
  State<DrillsPage> createState() => _DrillsPageState();
}

class _DrillsPageState extends State<DrillsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
              _buildHeader(context),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
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
                          0,
                        ),
                        _buildDrillCard(
                          context,
                          'Fire Evacuation Drill',
                          'Practice quick and safe evacuation procedures',
                          Icons.local_fire_department,
                          const Color(0xFFF44336),
                          'fire',
                          120,
                          1,
                        ),
                        _buildDrillCard(
                          context,
                          'Flood Response Drill',
                          'Practice moving to higher ground quickly',
                          Icons.water,
                          const Color(0xFF2196F3),
                          'flood',
                          60,
                          2,
                        ),
                        _buildDrillCard(
                          context,
                          'Cyclone Shelter Drill',
                          'Practice moving to interior safe room',
                          Icons.tornado,
                          const Color(0xFF9C27B0),
                          'cyclone',
                          90,
                          3,
                        ),
                        _buildDrillCard(
                          context,
                          'First Aid Practice',
                          'Practice basic first aid techniques',
                          Icons.medical_services,
                          const Color(0xFF21C573),
                          'firstaid',
                          180,
                          4,
                        ),
                        _buildDrillCard(
                          context,
                          'Emergency Communication',
                          'Practice contacting emergency services',
                          Icons.phone_in_talk,
                          const Color(0xFF00BCD4),
                          'communication',
                          30,
                          5,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_martial_arts, color: Colors.white, size: 28),
          ),
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
      int index,
      ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Card(
          elevation: 4,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => DrillDetailPage(
                    title: title,
                    description: description,
                    icon: icon,
                    color: color,
                    drillType: drillType,
                    durationSeconds: durationSeconds,
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Hero(
                    tag: 'drill_icon_$drillType',
                    child: Container(
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
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: color,
                      size: 24,
                    ),
                  ),
                ],
              ),
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

class _DrillDetailPageState extends State<DrillDetailPage>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  bool _isCompleted = false;
  bool _isPaused = false;
  int _currentStep = 0;
  int _remainingSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const Map<String, List<DrillStep>> _drillSteps = {
    'earthquake': [
      DrillStep(title: 'DROP', instruction: 'Drop down onto your hands and knees', icon: Icons.arrow_downward),
      DrillStep(title: 'COVER', instruction: 'Cover your head and neck with your arms', icon: Icons.shield),
      DrillStep(title: 'HOLD ON', instruction: 'Hold on to something sturdy and stay put', icon: Icons.pan_tool),
      DrillStep(title: 'STAY DOWN', instruction: 'Stay in position until shaking stops', icon: Icons.accessibility),
      DrillStep(title: 'ASSESS', instruction: 'Check yourself and others for injuries', icon: Icons.health_and_safety),
    ],
    'fire': [
      DrillStep(title: 'ALERT', instruction: 'Shout "Fire!" to alert others', icon: Icons.campaign),
      DrillStep(title: 'STAY LOW', instruction: 'Get down low to avoid smoke', icon: Icons.trending_down),
      DrillStep(title: 'FEEL DOORS', instruction: 'Check if doors are hot before opening', icon: Icons.sensor_door),
      DrillStep(title: 'EXIT QUICKLY', instruction: 'Use nearest safe exit route', icon: Icons.exit_to_app),
      DrillStep(title: 'MEET OUTSIDE', instruction: 'Go to designated meeting point', icon: Icons.place),
      DrillStep(title: 'CALL 911', instruction: 'Call emergency services from safe location', icon: Icons.phone),
    ],
    'flood': [
      DrillStep(title: 'ASSESS', instruction: 'Evaluate water level and rising speed', icon: Icons.visibility),
      DrillStep(title: 'GATHER', instruction: 'Grab emergency kit and important items', icon: Icons.shopping_bag),
      DrillStep(title: 'MOVE UP', instruction: 'Move to higher ground immediately', icon: Icons.arrow_upward),
      DrillStep(title: 'AVOID WATER', instruction: 'Never walk through moving water', icon: Icons.block),
      DrillStep(title: 'SIGNAL', instruction: 'Signal for help if trapped', icon: Icons.waving_hand),
    ],
    'cyclone': [
      DrillStep(title: 'SECURE', instruction: 'Close all windows and doors', icon: Icons.lock),
      DrillStep(title: 'INTERIOR', instruction: 'Move to interior room on lowest floor', icon: Icons.home),
      DrillStep(title: 'COVER', instruction: 'Get under sturdy furniture', icon: Icons.table_restaurant),
      DrillStep(title: 'PROTECT', instruction: 'Use blankets to protect from debris', icon: Icons.shield),
      DrillStep(title: 'STAY PUT', instruction: 'Stay sheltered until all clear', icon: Icons.pause_circle),
    ],
    'firstaid': [
      DrillStep(title: 'ASSESS', instruction: 'Check scene safety and victim condition', icon: Icons.search),
      DrillStep(title: 'CALL HELP', instruction: 'Call 911 or emergency services', icon: Icons.phone),
      DrillStep(title: 'AIRWAY', instruction: 'Ensure airway is clear', icon: Icons.air),
      DrillStep(title: 'BREATHING', instruction: 'Check if person is breathing', icon: Icons.favorite),
      DrillStep(title: 'CIRCULATION', instruction: 'Check pulse and stop bleeding', icon: Icons.bloodtype),
      DrillStep(title: 'COMFORT', instruction: 'Keep person comfortable and calm', icon: Icons.self_improvement),
    ],
    'communication': [
      DrillStep(title: 'STAY CALM', instruction: 'Take a deep breath and stay calm', icon: Icons.spa),
      DrillStep(title: 'DIAL 911', instruction: 'Dial emergency number clearly', icon: Icons.dialpad),
      DrillStep(title: 'STATE EMERGENCY', instruction: 'Clearly state type of emergency', icon: Icons.report),
      DrillStep(title: 'GIVE LOCATION', instruction: 'Provide exact location', icon: Icons.my_location),
      DrillStep(title: 'ANSWER QUESTIONS', instruction: 'Answer dispatcher questions', icon: Icons.question_answer),
      DrillStep(title: 'STAY ON LINE', instruction: 'Don\'t hang up until told', icon: Icons.phone_in_talk),
    ],
  };

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationSeconds;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startDrill() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _currentStep = 0;
      _remainingSeconds = widget.durationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
            if (_remainingSeconds == 10) {
              HapticFeedback.lightImpact();
            }
          } else {
            _completeDrill();
          }
        });
      }
    });
  }

  void _togglePause() {
    HapticFeedback.selectionClick();
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _completeDrill() {
    HapticFeedback.heavyImpact();
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isCompleted = true;
    });
    _showCompletionDialog();
  }

  void _nextStep() {
    HapticFeedback.mediumImpact();
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
    HapticFeedback.selectionClick();
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
      _isPaused = false;
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
              _buildAppBar(context),
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
                      if (!_isRunning && !_isCompleted)
                        _buildPreviewMode(steps)
                      else if (_isRunning)
                        _buildActiveMode(steps),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_isRunning) _buildTimerChip(),
        ],
      ),
    );
  }

  Widget _buildTimerChip() {
    final isLowTime = _remainingSeconds <= 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isLowTime ? Colors.red.withOpacity(0.3) : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewMode(List<DrillStep> steps) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Hero(
                      tag: 'drill_icon_${widget.drillType}',
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
                  Row(
                    children: [
                      Icon(Icons.list_alt, color: widget.color),
                      const SizedBox(width: 8),
                      Text(
                        'Drill Steps (${steps.length})',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...steps.asMap().entries.map((entry) {
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (entry.key * 50)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(20 * (1 - value), 0),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: _buildStepCard(entry.key, entry.value),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          _buildStartButton(),
        ],
      ),
    );
  }

  Widget _buildStepCard(int index, DrillStep step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.color, widget.color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(step.icon, size: 18, color: widget.color),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        step.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  step.instruction,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: _startDrill,
            icon: const Icon(Icons.play_arrow, size: 28),
            label: const Text(
              'Start Drill',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: widget.color.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveMode(List<DrillStep> steps) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProgressIndicator(steps.length),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildCurrentStep(steps[_currentStep]),
            ),
          ),
          _buildNavigationControls(steps.length),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(int totalSteps) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color.withOpacity(0.15),
            widget.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentStep + 1} of $totalSteps',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(((_currentStep + 1) / totalSteps) * 100).toInt()}%',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / totalSteps,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(DrillStep step) {
    return Padding(
      key: ValueKey(_currentStep),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.color, widget.color.withOpacity(0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                '${_currentStep + 1}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Icon(step.icon, size: 48, color: widget.color),
          const SizedBox(height: 16),
          Text(
            step.title,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            step.instruction,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF2C3E50),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(int totalSteps) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (_isRunning)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OutlinedButton.icon(
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(_isPaused ? 'Resume' : 'Pause'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.color,
                    side: BorderSide(color: widget.color, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousStep,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: widget.color, width: 2),
                        foregroundColor: widget.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _nextStep,
                    icon: Icon(
                      _currentStep == totalSteps - 1 ? Icons.check_circle : Icons.arrow_forward,
                    ),
                    label: Text(
                      _currentStep == totalSteps - 1 ? 'Complete Drill' : 'Next Step',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 4,
                      shadowColor: widget.color.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
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

class DrillStep {
  final String title;
  final String instruction;
  final IconData icon;

  const DrillStep({
    required this.title,
    required this.instruction,
    required this.icon,
  });
}