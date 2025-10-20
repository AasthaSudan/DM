import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "animation": "assets/lottie/Animation - 1757337668353.json",
      "title": "Be Prepared",
      "desc": "Learn how to prepare before earthquakes, floods, and fires."
    },
    {
      "animation": "assets/lottie/health insurance.json",
      "title": "Safety First",
      "desc": "Get tips for first aid and safe evacuation during emergencies."
    },
    {
      "animation": "assets/lottie/Connect with us.json",
      "title": "Stay Connected",
      "desc": "Connect with community and rescue teams in real-time."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF21C573), Color(0xFF1791B6)], // Matching your app theme
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/auth");
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView with Expanded to take available space
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Flexible Lottie animation with better error handling
                          Flexible(
                            flex: 3,
                            child: AnimatedOpacity(
                              opacity: _currentIndex == index ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 300,
                                  maxWidth: 300,
                                ),
                                child: Lottie.asset(
                                  data["animation"]!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 80,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Title with better typography
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              data["title"]!,
                              key: ValueKey(data["title"]),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Description with better spacing
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              key: ValueKey(data["desc"]),
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Text(
                                data["desc"]!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator with theme colors
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingData.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 8,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                  ),
                ),
              ),

              // Bottom Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _currentIndex > 0 ? 1.0 : 0.0,
                      child: TextButton(
                        onPressed: _currentIndex > 0 ? () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } : null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Get Started/Next Button with green theme
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: 56,
                      width: _currentIndex == onboardingData.length - 1 ? 140 : 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            if (_currentIndex == onboardingData.length - 1) {
                              Navigator.pushReplacementNamed(context, "/auth");
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _currentIndex == onboardingData.length - 1
                                  ? const Text(
                                "Get Started",
                                key: ValueKey("get_started"),
                                style: TextStyle(
                                  color: Color(0xFF21C573),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : const Icon(
                                Icons.arrow_forward,
                                key: ValueKey("arrow"),
                                color: Color(0xFF21C573),
                                size: 24,
                              ),
                            ),
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
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}