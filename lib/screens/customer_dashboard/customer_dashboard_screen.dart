import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.dark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1A2E), Color(0xFF3D2020)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
                child: Row(children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.rose,
                    child: const Text('A',
                      style: TextStyle(color: Colors.white,
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Anjali Sharma',
                          style: TextStyle(color: Colors.white,
                              fontSize: 18, fontWeight: FontWeight.w700)),
                        const Text('anjali@email.com',
                          style: TextStyle(color: Colors.white60, fontSize: 13)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.rose.withOpacity(.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Premium Member',
                            style: TextStyle(color: Colors.white,
                                fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded,
                        color: Colors.white70, size: 20),
                    onPressed: () => Get.toNamed(AppRoutes.profile),
                  ),
                ]),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Wallet card
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.wallet),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.rose, Color(0xFFE8636D)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                            color: AppColors.rose.withOpacity(.3),
                            blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('PreWed Wallet',
                                style: TextStyle(color: Colors.white70,
                                    fontSize: 13)),
                              SizedBox(height: 4),
                              Text('₹2,000',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 28, fontWeight: FontWeight.w700)),
                              SizedBox(height: 2),
                              Text('Available Balance',
                                style: TextStyle(color: Colors.white60,
                                    fontSize: 11)),
                            ],
                          ),
                        ),
                        Column(children: [
                          const Icon(Icons.account_balance_wallet_rounded,
                              color: Colors.white38, size: 40),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Add Money',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick actions
                  Row(children: [
                    _quickAction(Icons.book_rounded, 'My\nBookings',
                        AppColors.rose, () => Get.toNamed(AppRoutes.myBookings)),
                    const SizedBox(width: 10),
                    _quickAction(Icons.favorite_rounded, 'Wish-\nlist',
                        const Color(0xFFE91E63),
                        () => Get.toNamed(AppRoutes.wishlist)),
                    const SizedBox(width: 10),
                    _quickAction(Icons.account_balance_wallet_rounded, 'My\nWallet',
                        const Color(0xFF4CAF50),
                        () => Get.toNamed(AppRoutes.wallet)),
                    const SizedBox(width: 10),
                    _quickAction(Icons.person_rounded, 'My\nProfile',
                        AppColors.gold,
                        () => Get.toNamed(AppRoutes.profile)),
                  ]),
                  const SizedBox(height: 20),

                  // Recent bookings
                  _sectionHeader('Recent Bookings', () => Get.toNamed(AppRoutes.myBookings)),
                  ...[
                    {
                      'id': 'VIV-2025-000123',
                      'title': 'Pre-Wedding Shoot',
                      'date': '15 Jun 2025',
                      'status': 'Confirmed',
                      'amount': '₹33,000',
                      'vendors': 3,
                      'statusColor': AppColors.success,
                    },
                    {
                      'id': 'VIV-2025-000089',
                      'title': 'Engagement Shoot',
                      'date': '02 Apr 2025',
                      'status': 'Completed',
                      'amount': '₹18,000',
                      'vendors': 2,
                      'statusColor': AppColors.textMuted,
                    },
                  ].map((b) => _bookingCard(b)),

                  const SizedBox(height: 20),

                  // Loyalty points
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.stars_rounded,
                            color: Color(0xFFF5A623), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Loyalty Points',
                              style: TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                            Text('Earn points on every booking',
                              style: TextStyle(fontSize: 12,
                                  color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('320', style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF5A623))),
                          Text('Points', style: TextStyle(fontSize: 11,
                              color: AppColors.textMuted)),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Support
                  _sectionHeader('Support', () {}),
                  Row(children: [
                    Expanded(
                      child: _supportCard(Icons.headset_mic_rounded,
                          'Contact Support', 'We\'re here 24/7'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _supportCard(Icons.chat_rounded,
                          'Live Chat', 'Chat with us now'),
                    ),
                  ]),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          ]),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16,
              fontWeight: FontWeight.w700, fontFamily: 'Playfair Display')),
          GestureDetector(
            onTap: onTap,
            child: const Text('View All',
              style: TextStyle(color: AppColors.rose,
                  fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _bookingCard(Map b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.roseBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.camera_alt_rounded,
                color: AppColors.rose, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(b['title'] as String,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text(b['id'] as String,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (b['statusColor'] as Color).withOpacity(.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(b['status'] as String,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: b['statusColor'] as Color)),
          ),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.calendar_today_rounded,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(b['date'] as String,
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(width: 12),
              const Icon(Icons.people_rounded,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text('${b['vendors']} vendors',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ]),
            Text(b['amount'] as String,
              style: const TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w700, color: AppColors.rose)),
          ],
        ),
      ]),
    );
  }

  Widget _supportCard(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.rose, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w700)),
            Text(sub, style: const TextStyle(fontSize: 11,
                color: AppColors.textMuted)),
          ]),
        ),
      ]),
    );
  }
}
