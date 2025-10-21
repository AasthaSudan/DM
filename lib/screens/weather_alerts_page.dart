import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class WeatherAlertsPage extends StatefulWidget {
  const WeatherAlertsPage({super.key});

  @override
  State<WeatherAlertsPage> createState() => _WeatherAlertsPageState();
}

class _WeatherAlertsPageState extends State<WeatherAlertsPage> {
  String _selectedLocation = 'Ghaziabad, Uttar Pradesh';
  bool _notificationsEnabled = true;

  final List<WeatherAlert> _activeAlerts = [
    WeatherAlert(
      id: '1',
      type: DisasterType.heatwave,
      severity: AlertSeverity.warning,
      title: 'Heat Wave Warning',
      description: 'Heat wave conditions expected for next 3 days. Max 45°C.',
      location: 'Ghaziabad, UP',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(days: 3)),
      instructions: [
        'Stay hydrated',
        'Avoid going out during afternoon',
        'Wear light-colored clothing',
        'Check on elderly relatives',
      ],
    ),
    WeatherAlert(
      id: '2',
      type: DisasterType.flood,
      severity: AlertSeverity.watch,
      title: 'Flood Watch',
      description: 'Heavy rainfall expected. Monitor low-lying areas.',
      location: 'Delhi NCR',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(days: 2)),
      instructions: [
        'Monitor local weather reports',
        'Prepare emergency supplies',
        'Know evacuation routes',
        'Keep documents in waterproof bags',
      ],
    ),
  ];

  final List<WeatherForecast> _forecast = [
    WeatherForecast(date: DateTime.now(), temperature: 42, condition: 'Sunny', icon: Icons.wb_sunny, humidity: 35, windSpeed: 12),
    WeatherForecast(date: DateTime.now().add(const Duration(days: 1)), temperature: 43, condition: 'Hot', icon: Icons.wb_sunny, humidity: 30, windSpeed: 15),
    WeatherForecast(date: DateTime.now().add(const Duration(days: 2)), temperature: 41, condition: 'Partly Cloudy', icon: Icons.wb_cloudy, humidity: 40, windSpeed: 10),
    WeatherForecast(date: DateTime.now().add(const Duration(days: 3)), temperature: 38, condition: 'Cloudy', icon: Icons.cloud, humidity: 45, windSpeed: 8),
    WeatherForecast(date: DateTime.now().add(const Duration(days: 4)), temperature: 35, condition: 'Rainy', icon: Icons.water_drop, humidity: 70, windSpeed: 20),
  ];

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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Weather Alerts',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Stay informed about weather conditions',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _notificationsEnabled = !_notificationsEnabled;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_notificationsEnabled
                          ? 'Weather alerts enabled'
                          : 'Weather alerts disabled'),
                      backgroundColor: AppConstants.primaryGreen,
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLocationSelector(),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedLocation,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_activeAlerts.isNotEmpty) ...[
              const Text('Active Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._activeAlerts.map(_buildAlertCard),
              const SizedBox(height: 16),
            ],
            const Text('5-Day Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.22, // reduced to prevent overflow
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _forecast.length,
                itemBuilder: (c, i) => _buildForecastCard(_forecast[i]),
              ),
            ),
            const SizedBox(height: 16), // smaller bottom spacing
            const Text('Weather Safety Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSafetyTipsCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(WeatherAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: alert.severity.color.withOpacity(0.5), width: 2),
        ),
        child: InkWell(
          onTap: () => _showAlertDetails(alert),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: alert.type.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(alert.type.icon, color: alert.type.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: alert.severity.color, borderRadius: BorderRadius.circular(12)),
                            child: Text(alert.severity.displayName.toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          Text(alert.type.displayName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(alert.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Text(alert.description, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text('Valid until ${DateFormat('MMM dd, hh:mm a').format(alert.endTime)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCard(WeatherForecast forecast) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(DateFormat('EEE').format(forecast.date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Icon(forecast.icon, size: 40, color: AppConstants.primaryGreen),
            const SizedBox(height: 8),
            Text('${forecast.temperature}°C', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(forecast.condition, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _buildSafetyTipsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppConstants.lightGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppConstants.primaryGreen, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.lightbulb, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('General Weather Safety', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 16),
          ...AppConstants.safetyTips['general']!.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.check_circle, size: 20, color: AppConstants.primaryGreen),
              const SizedBox(width: 8),
              Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
            ]),
          )),
        ],
      ),
    );
  }

  void _showAlertDetails(WeatherAlert alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 16),
            Text(alert.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              Icon(alert.type.icon, color: alert.type.color, size: 28),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: alert.severity.color, borderRadius: BorderRadius.circular(12)),
                child: Text(alert.severity.displayName.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(alert.description, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 16),
            const Text('Valid Period', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${DateFormat('MMM dd, hh:mm a').format(alert.startTime)} - ${DateFormat('MMM dd, hh:mm a').format(alert.endTime)}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            const Text('Safety Instructions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...alert.instructions.map((instruction) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.arrow_right, size: 20, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(child: Text(instruction, style: const TextStyle(fontSize: 14))),
              ]),
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alert shared successfully'), backgroundColor: AppConstants.primaryGreen),
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Alert'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class WeatherAlert {
  final String id;
  final DisasterType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> instructions;

  WeatherAlert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.instructions,
  });
}

enum AlertSeverity { advisory, watch, warning, emergency }

extension AlertSeverityExtension on AlertSeverity {
  String get displayName {
    switch (this) {
      case AlertSeverity.advisory:
        return 'Advisory';
      case AlertSeverity.watch:
        return 'Watch';
      case AlertSeverity.warning:
        return 'Warning';
      case AlertSeverity.emergency:
        return 'Emergency';
    }
  }

  Color get color {
    switch (this) {
      case AlertSeverity.advisory:
        return Colors.blue;
      case AlertSeverity.watch:
        return Colors.orange;
      case AlertSeverity.warning:
        return Colors.red;
      case AlertSeverity.emergency:
        return Colors.purple;
    }
  }
}

enum DisasterType { heatwave, flood, storm, cyclone }

extension DisasterTypeExtension on DisasterType {
  String get displayName {
    switch (this) {
      case DisasterType.heatwave:
        return 'Heatwave';
      case DisasterType.flood:
        return 'Flood';
      case DisasterType.storm:
        return 'Storm';
      case DisasterType.cyclone:
        return 'Cyclone';
    }
  }

  IconData get icon {
    switch (this) {
      case DisasterType.heatwave:
        return Icons.wb_sunny;
      case DisasterType.flood:
        return Icons.water_drop;
      case DisasterType.storm:
        return Icons.thunderstorm;
      case DisasterType.cyclone:
        return Icons.air;
    }
  }

  Color get color {
    switch (this) {
      case DisasterType.heatwave:
        return Colors.orange;
      case DisasterType.flood:
        return Colors.blue;
      case DisasterType.storm:
        return Colors.indigo;
      case DisasterType.cyclone:
        return Colors.purple;
    }
  }
}

class WeatherForecast {
  final DateTime date;
  final int temperature;
  final String condition;
  final IconData icon;
  final int humidity;
  final int windSpeed;

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });
}
