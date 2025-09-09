// lib/onboarding_screen.dart

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
            colors: [Color(0xFF93D888), Color(0xFF659ECD)], // Blue gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              // PageView with Animation
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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Lottie animation with fade-in effect on swipe
                          AnimatedOpacity(
                            opacity: _currentIndex == index ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: SizedBox(
                              height: 300, // Set height for Lottie animation
                              child: Lottie.asset(data["animation"]!),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title with slide-in animation
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              data["title"]!,
                              key: ValueKey(data["title"]),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Description with fade-in animation
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              data["desc"]!,
                              key: ValueKey(data["desc"]),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // SmoothPageIndicator
              SmoothPageIndicator(
                controller: _controller,
                count: onboardingData.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                ),
              ),
              const SizedBox(height: 30),

              // Row to align "Back" and "Get Started" buttons at the same level
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button with flexible width
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          if (_currentIndex > 0) {
                            _controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          } else {
                            Navigator.pop(context); // Close the onboarding screen
                          }
                        },
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Get Started Button with fixed width
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: _currentIndex == onboardingData.length - 1 ? 175 : 120, // Fixed width when not on the last page
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: _currentIndex == onboardingData.length - 1
                            ? BorderRadius.circular(30) // Rounded rectangle on last page
                            : null, // No borderRadius for circle
                        shape: _currentIndex == onboardingData.length - 1
                            ? BoxShape.rectangle // Rectangle on last page
                            : BoxShape.circle, // Circle on others
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (_currentIndex == onboardingData.length - 1) {
                              Navigator.pushReplacementNamed(context, "/home");
                            } else {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            }
                          },
                          child: Center(
                            child: _currentIndex == onboardingData.length - 1
                                ? const Text(
                              "Get Started",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                : const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
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
}
