import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

// ═══════════════════════════════════════════════════════
// PAYMENT SCREEN
// ═══════════════════════════════════════════════════════
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'razorpay';
  bool _loading = false;

  double get _amount =>
      (Get.arguments?['amount'] as double?) ?? 9900.0;

  Future<void> _pay() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2)); // simulate
    setState(() => _loading = false);
    Get.offAllNamed(AppRoutes.paymentSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Payment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.rose, Color(0xFFE8636D)]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(
                    color: AppColors.rose.withOpacity(.3),
                    blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(children: [
                const Text('Advance Payment',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text('₹${_amount.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white,
                      fontSize: 36, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('(30% of total booking amount)',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 24),

            const Text('Choose Payment Method',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),

            // Payment methods
            ...[
              {'id':'razorpay','name':'Razorpay','sub':'UPI, Cards, NetBanking, Wallets',
               'icon':Icons.payment_rounded,'color':0xFF0F6FDB},
              {'id':'phonepe','name':'PhonePe','sub':'UPI Payment via PhonePe',
               'icon':Icons.phone_android_rounded,'color':0xFF6739B7},
              {'id':'wallet','name':'PreWed Wallet','sub':'Balance: ₹2,000',
               'icon':Icons.account_balance_wallet_rounded,'color':AppColors.rose.value},
              {'id':'cod','name':'Pay on Event Day','sub':'Pay remaining balance on day',
               'icon':Icons.money_rounded,'color':0xFF4CAF50},
            ].map((m) {
              final active = _method == m['id'];
              return GestureDetector(
                onTap: () => setState(() => _method = m['id'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: active ? AppColors.rose : AppColors.border,
                        width: active ? 2 : 1),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: Color(m['color'] as int).withOpacity(.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(m['icon'] as IconData,
                          color: Color(m['color'] as int), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['name'] as String,
                            style: const TextStyle(fontSize: 14,
                                fontWeight: FontWeight.w700)),
                          Text(m['sub'] as String,
                            style: const TextStyle(fontSize: 12,
                                color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: m['id'] as String,
                      groupValue: _method,
                      activeColor: AppColors.rose,
                      onChanged: (v) => setState(() => _method = v!),
                    ),
                  ]),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Security note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(.3)),
              ),
              child: const Row(children: [
                Icon(Icons.security_rounded, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('100% secure payment. Your data is encrypted.',
                    style: TextStyle(fontSize: 12, color: Colors.green)),
                ),
              ]),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _pay,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
                child: _loading
                    ? const Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('Processing...'),
                        ])
                    : Text('Pay ₹${_amount.toStringAsFixed(0)} Now'),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('By paying you agree to our Terms & Conditions',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// PAYMENT SUCCESS SCREEN
// ═══════════════════════════════════════════════════════
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.withOpacity(.3), width: 3),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.green, size: 60),
              ),
              const SizedBox(height: 32),
              const Text('Booking Confirmed! 🎉',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Playfair Display',
                    fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              const Text('Your pre-wedding shoot is booked successfully',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 32),

              // Booking ID
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.roseBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  const Text('Booking ID',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  const Text('VIV-2025-000123',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                        color: AppColors.rose, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _confirmRow('Event Date', '15 June 2025'),
                  _confirmRow('Location', 'Amer Fort, Jaipur'),
                  _confirmRow('Amount Paid', '₹9,900 (Advance)'),
                  _confirmRow('Balance Due', '₹23,100 (On Event Day)'),
                ]),
              ),
              const SizedBox(height: 24),

              // WhatsApp note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(children: [
                  Icon(Icons.chat_rounded, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Invoice & details sent to your WhatsApp',
                      style: TextStyle(fontSize: 12, color: Colors.green,
                          fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.myBookings),
                  child: const Text('View My Bookings'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _confirmRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(l, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        Text(v, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
