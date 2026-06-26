import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  final _slides = [
    _Slide(
      icon: Icons.camera_alt_rounded,
      color: const Color(0xFFFDF2F3),
      iconColor: AppColors.rose,
      title: 'All Your Pre-Wedding\nNeeds, One Place',
      subtitle: 'Choose from 16+ services — photographer, makeup artist, décor and more.',
    ),
    _Slide(
      icon: Icons.location_on_rounded,
      color: const Color(0xFFF0F8FF),
      iconColor: const Color(0xFF4A7FA5),
      title: 'Find Best Vendors\nNear You',
      subtitle: 'Set your shoot location and we instantly show you the top verified vendors nearby.',
    ),
    _Slide(
      icon: Icons.payment_rounded,
      color: const Color(0xFFF0FFF4),
      iconColor: const Color(0xFF4CAF50),
      title: 'Easy Booking &\nSecure Payments',
      subtitle: 'Book in minutes. Pay via Razorpay, PhonePe or Wallet. Full invoice on WhatsApp.',
    ),
  ];

  Future<void> _done() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _done,
                child: Text('Skip', style: TextStyle(color: AppColors.textMuted)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _ctrl,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
              ),
            ),

            // Indicator
            SmoothPageIndicator(
              controller: _ctrl,
              count: _slides.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.rose,
                dotColor: AppColors.border,
                dotHeight: 8, dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 32),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page < _slides.length - 1) {
                      _ctrl.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    } else {
                      _done();
                    }
                  },
                  child: Text(_page == _slides.length - 1 ? 'Get Started' : 'Next'),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account? ',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.login),
                  child: Text('Login',
                      style: TextStyle(color: AppColors.rose,
                          fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  final IconData icon;
  final Color color, iconColor;
  final String title, subtitle;
  const _Slide({required this.icon, required this.color, required this.iconColor,
      required this.title, required this.subtitle});
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180, height: 180,
            decoration: BoxDecoration(
              color: slide.color,
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 80, color: slide.iconColor),
          ),
          const SizedBox(height: 40),
          Text(slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 26, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary, height: 1.3,
            )),
          const SizedBox(height: 16),
          Text(slide.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14, color: AppColors.textSecondary, height: 1.6,
            )),
        ],
      ),
    );
  }
}
