import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _isPhone = true;
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      if (_isPhone) {
        await ApiService().sendOtp(_phoneCtrl.text.trim());
        Get.toNamed(AppRoutes.otp, arguments: {'phone': _phoneCtrl.text.trim()});
      } else {
        final res = await ApiService().login(
            _emailCtrl.text.trim(), _passCtrl.text);
        // Save token
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: AppColors.error, colorText: Colors.white);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Column(children: [
                    Container(
                      width: 64, height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.rose, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_rounded,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 10),
                    const Text('PreWed',
                      style: TextStyle(fontFamily: 'Playfair Display',
                          fontSize: 24, fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                    const Text('STUDIO',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                          color: AppColors.textMuted, letterSpacing: 4)),
                  ]),
                ),
                const SizedBox(height: 36),

                const Text('Welcome Back 👋',
                  style: TextStyle(fontFamily: 'Playfair Display',
                      fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                const Text('Sign in to continue',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                const SizedBox(height: 28),

                // Toggle
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    _tab('Phone / OTP', _isPhone, () => setState(() => _isPhone = true)),
                    _tab('Email & Password', !_isPhone, () => setState(() => _isPhone = false)),
                  ]),
                ),
                const SizedBox(height: 24),

                if (_isPhone) ...[
                  const Text('Phone Number',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: 'Enter 10 digit mobile number',
                      prefixText: '+91  ',
                      counterText: '',
                      prefixIcon: Icon(Icons.phone_rounded, color: AppColors.rose),
                    ),
                    validator: (v) {
                      if (v == null || v.length != 10) return 'Enter valid 10-digit number';
                      return null;
                    },
                  ),
                ] else ...[
                  const Text('Email',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_rounded, color: AppColors.rose),
                    ),
                    validator: (v) {
                      if (v == null || !v.contains('@')) return 'Enter valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Password',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.rose),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            color: AppColors.textMuted),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: AppColors.rose)),
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(_isPhone ? 'Send OTP' : 'Login'),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: TextStyle(color: AppColors.textMuted,
                        fontSize: 12)),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: 20),

                // Google btn
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
                    label: const Text('Continue with Google'),
                  ),
                ),
                const SizedBox(height: 32),

                // Register
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.register),
                        child: const Text('Register',
                            style: TextStyle(color: AppColors.rose,
                                fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Vendor login
                Center(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.vendorDashboard),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.roseBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Login as Vendor →',
                          style: TextStyle(color: AppColors.rose,
                              fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.rose : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600,
              color: active ? Colors.white : AppColors.textMuted,
            )),
        ),
      ),
    );
  }
}
