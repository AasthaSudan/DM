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
            colors: [Color(0xFF93D888), Color(0xFF659ECD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(  // Remove SingleChildScrollView
            children: [
              // Skip Button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/auth");
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              // PageView with Expanded to take available space
              Expanded(  // Use Expanded instead of fixed height
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Flexible Lottie animation
                          Flexible(
                            flex: 3,
                            child: AnimatedOpacity(
                              opacity: _currentIndex == index ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Lottie.asset(
                                data["animation"]!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Title
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

                          // Description
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
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Page Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: onboardingData.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                  ),
                ),
              ),

              // Bottom Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    TextButton(
                      onPressed: () {
                        if (_currentIndex > 0) {
                          _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: _currentIndex > 0 ? Colors.white : Colors.transparent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Get Started/Next Button
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      constraints: BoxConstraints(
                        minWidth: _currentIndex == onboardingData.length - 1 ? 130 : 60,
                        maxWidth: _currentIndex == onboardingData.length - 1 ? 160 : 60,
                      ),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: _currentIndex == onboardingData.length - 1
                            ? BorderRadius.circular(30)
                            : BorderRadius.circular(30),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            if (_currentIndex == onboardingData.length - 1) {
                              Navigator.pushReplacementNamed(context, "/auth");
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
                              size: 24,
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