import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';
import '../../services/api_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otp = TextEditingController();
  bool _loading = false;
  int _seconds = 30;
  Timer? _timer;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _phone = Get.arguments?['phone'] ?? '';
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) { t.cancel(); return; }
      setState(() => _seconds--);
    });
  }

  Future<void> _verify() async {
    if (_otp.text.length != 6) {
      Get.snackbar('Error', 'Enter 6-digit OTP');
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ApiService().verifyOtp(_phone, _otp.text);
      // Save token from res
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP',
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() { _timer?.cancel(); _otp.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 52, height: 56,
      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.5),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text('Verify OTP',
              style: TextStyle(fontFamily: 'Playfair Display',
                  fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                children: [
                  const TextSpan(text: 'OTP sent to '),
                  TextSpan(text: '+91 $_phone',
                    style: const TextStyle(fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // OTP input
            Center(
              child: Pinput(
                controller: _otp,
                length: 6,
                defaultPinTheme: pinTheme,
                focusedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    border: Border.all(color: AppColors.rose, width: 2),
                  ),
                ),
                submittedPinTheme: pinTheme.copyWith(
                  decoration: pinTheme.decoration!.copyWith(
                    color: AppColors.roseBg,
                    border: Border.all(color: AppColors.rose),
                  ),
                ),
                onCompleted: (_) => _verify(),
              ),
            ),
            const SizedBox(height: 32),

            // Resend
            Center(
              child: _seconds > 0
                ? Text('Resend OTP in 00:${_seconds.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13))
                : GestureDetector(
                    onTap: () async {
                      await ApiService().sendOtp(_phone);
                      _startTimer();
                    },
                    child: const Text('Resend OTP',
                      style: TextStyle(color: AppColors.rose,
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _verify,
                child: _loading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Verify & Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
