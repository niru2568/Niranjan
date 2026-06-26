import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

// ═══════════════════════════════════════════════════════
// MY BOOKINGS SCREEN
// ═══════════════════════════════════════════════════════
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  final _bookings = [
    {'id':'VIV-2025-000123','title':'Pre-Wedding Shoot','date':'15 Jun 2025',
     'location':'Amer Fort, Jaipur','status':'confirmed','amount':33000,
     'advance':9900,'vendors':['📸 Wedding Tales Photography','💄 Glow Studio','🚐 Vanity Van']},
    {'id':'VIV-2025-000089','title':'Engagement Shoot','date':'02 Apr 2025',
     'location':'Nahargarh Fort','status':'completed','amount':18000,
     'advance':18000,'vendors':['📸 Royal Frames Studio','💄 Glamour Zone']},
    {'id':'VIV-2025-000056','title':'Ring Ceremony Shoot','date':'14 Jan 2025',
     'location':'Jal Mahal, Jaipur','status':'cancelled','amount':12000,
     'advance':3600,'vendors':['📸 Candid Clicks']},
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabs,
          labelColor: AppColors.rose,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.rose,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _bookingList(_bookings),
          _bookingList(_bookings.where((b) => b['status'] == 'confirmed').toList()),
          _bookingList(_bookings.where((b) => b['status'] == 'completed').toList()),
          _bookingList(_bookings.where((b) => b['status'] == 'cancelled').toList()),
        ],
      ),
    );
  }

  Widget _bookingList(List<Map> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.calendar_today_rounded,
              size: 60, color: AppColors.border),
          const SizedBox(height: 16),
          const Text('No bookings here',
            style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.selectServices),
            child: const Text('Book Now'),
          ),
        ]),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _bookingCard(list[i]),
    );
  }

  Widget _bookingCard(Map b) {
    final statusColors = {
      'confirmed': AppColors.success,
      'completed': AppColors.textMuted,
      'cancelled': AppColors.error,
      'pending':   AppColors.warning,
    };
    final status = b['status'] as String;
    final color = statusColors[status] ?? AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: color.withOpacity(.07),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          child: Row(children: [
            Text(b['id'] as String,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status.capitalizeFirst!,
                style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w600, color: color)),
            ),
          ]),
        ),

        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b['title'] as String,
              style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.w700, fontFamily: 'Playfair Display')),
            const SizedBox(height: 10),
            _row(Icons.calendar_today_rounded, b['date'] as String),
            const SizedBox(height: 6),
            _row(Icons.location_on_rounded, b['location'] as String),
            const SizedBox(height: 12),

            // Vendors
            const Text('Vendors',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: AppColors.textMuted)),
            const SizedBox(height: 6),
            ...(b['vendors'] as List).map((v) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                const Icon(Icons.circle, size: 5, color: AppColors.rose),
                const SizedBox(width: 8),
                Text(v as String,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ]),
            )),
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Total Amount',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  Text('₹${b['amount']}',
                    style: const TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ]),
                Row(children: [
                  if (status == 'confirmed') ...[
                    OutlinedButton(
                      onPressed: () => _cancelDialog(b),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: const Text('Cancel', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
                    child: Text(
                      status == 'completed' ? 'Review' : 'View Details',
                      style: const TextStyle(fontSize: 12)),
                  ),
                ]),
              ],
            ),
          ]),
        ),
      ]),
    );
  }

  void _cancelDialog(Map b) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Are you sure you want to cancel this booking?',
            style: TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          TextField(
            controller: reasonCtrl,
            decoration: const InputDecoration(hintText: 'Reason for cancellation'),
            maxLines: 2,
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Get.back();
              Get.snackbar('Booking Cancelled',
                  'Refund will be processed in 5-7 days',
                  backgroundColor: AppColors.error, colorText: Colors.white);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) => Row(children: [
    Icon(icon, size: 14, color: AppColors.rose),
    const SizedBox(width: 6),
    Expanded(child: Text(text,
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
  ]);
}

// ═══════════════════════════════════════════════════════
// WISHLIST SCREEN
// ═══════════════════════════════════════════════════════
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final _wish = [
    {'name':'Wedding Tales Photography','cat':'Photographer','city':'Jaipur',
     'rating':4.8,'price':15000,'emoji':'📸'},
    {'name':'Glow Beauty Studio','cat':'Makeup Artist','city':'Jaipur',
     'rating':4.8,'price':8000,'emoji':'💄'},
    {'name':'Royal Decors Jaipur','cat':'Decoration','city':'Jaipur',
     'rating':4.9,'price':25000,'emoji':'🌸'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Wishlist')),
      body: _wish.isEmpty
          ? const Center(child: Text('No saved vendors yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wish.length,
              itemBuilder: (_, i) {
                final v = _wish[i];
                return Dismissible(
                  key: Key(v['name'] as String),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.error,
                    child: const Icon(Icons.delete_rounded,
                        color: Colors.white),
                  ),
                  onDismissed: (_) => setState(() => _wish.removeAt(i)),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(children: [
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(
                          color: AppColors.roseBg,
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(14)),
                        ),
                        child: Center(child: Text(v['emoji'] as String,
                            style: const TextStyle(fontSize: 38))),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v['name'] as String,
                                style: const TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                              Text('${v['cat']} · ${v['city']}',
                                style: const TextStyle(fontSize: 12,
                                    color: AppColors.textMuted)),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xFFF5A623), size: 14),
                                    Text(' ${v['rating']}',
                                      style: const TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                  ]),
                                  Text('₹${v['price']}',
                                    style: const TextStyle(fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.rose)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Get.toNamed(AppRoutes.vendorDetail,
                                      arguments: {'vendor': v}),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 8)),
                                  child: const Text('Book Now',
                                      style: TextStyle(fontSize: 12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// WALLET SCREEN
// ═══════════════════════════════════════════════════════
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  final _txns = const [
    {'type':'credit','desc':'Cashback - Booking VIV-123','amount':500,'date':'15 Jun','icon':Icons.add_circle_rounded,'color':AppColors.success},
    {'type':'debit','desc':'Booking VIV-089 payment','amount':-2000,'date':'02 Apr','icon':Icons.remove_circle_rounded,'color':AppColors.error},
    {'type':'credit','desc':'Referral bonus','amount':200,'date':'20 Mar','icon':Icons.card_giftcard_rounded,'color':AppColors.success},
    {'type':'credit','desc':'Cancellation refund','amount':3600,'date':'10 Jan','icon':Icons.replay_rounded,'color':AppColors.success},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Wallet')),
      body: Column(
        children: [
          // Balance card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.dark, Color(0xFF3D2020)]),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.2),
                  blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: Column(children: [
              const Icon(Icons.account_balance_wallet_rounded,
                  color: Colors.white38, size: 36),
              const SizedBox(height: 8),
              const Text('Available Balance',
                style: TextStyle(color: Colors.white60, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('₹2,000',
                style: TextStyle(color: Colors.white,
                    fontSize: 36, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addMoney(context),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Money'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rose),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.history_rounded, size: 18,
                        color: Colors.white),
                    label: const Text('History',
                        style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white38)),
                  ),
                ),
              ]),
            ]),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _walletStat('Total Earned', '₹4,300', AppColors.success),
              const SizedBox(width: 10),
              _walletStat('Total Spent', '₹2,000', AppColors.error),
              const SizedBox(width: 10),
              _walletStat('Cashback', '₹700', AppColors.gold),
            ]),
          ),
          const SizedBox(height: 16),

          // Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Transactions', style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, fontFamily: 'Playfair Display')),
                Text('See All', style: TextStyle(color: AppColors.rose,
                    fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _txns.length,
              itemBuilder: (_, i) {
                final t = _txns[i];
                final amt = t['amount'] as int;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: (t['color'] as Color).withOpacity(.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(t['icon'] as IconData,
                          color: t['color'] as Color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t['desc'] as String, style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(t['date'] as String, style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted)),
                        ]),
                    ),
                    Text(amt > 0 ? '+₹$amt' : '-₹${amt.abs()}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                          color: amt > 0 ? AppColors.success : AppColors.error)),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _walletStat(String label, String val, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: [
          Text(val, style: TextStyle(fontSize: 15,
              fontWeight: FontWeight.w700, color: color)),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ]),
      ),
    );
  }

  void _addMoney(BuildContext context) {
    final amtCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24,
            MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Add Money to Wallet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Wrap(spacing: 8, children: [500, 1000, 2000, 5000].map((amt) =>
            GestureDetector(
              onTap: () => amtCtrl.text = amt.toString(),
              child: Chip(label: Text('₹$amt')),
            )).toList()),
          const SizedBox(height: 12),
          TextField(controller: amtCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter amount', prefixText: '₹ ')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.snackbar('✅ Money Added',
                    '₹${amtCtrl.text} added to wallet',
                    backgroundColor: AppColors.success, colorText: Colors.white);
              },
              child: const Text('Proceed to Pay'),
            )),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// PROFILE SCREEN
// ═══════════════════════════════════════════════════════
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Profile'),
        actions: [
          TextButton(onPressed: () {}, child: const Text('Edit',
            style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.w600))),
        ]),
      body: SingleChildScrollView(
        child: Column(children: [
          // Profile header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(children: [
              Stack(
                children: [
                  CircleAvatar(radius: 44, backgroundColor: AppColors.rose,
                    child: const Text('A', style: TextStyle(color: Colors.white,
                        fontSize: 32, fontWeight: FontWeight.w700))),
                  Positioned(bottom: 0, right: 0,
                    child: Container(
                      width: 28, height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.rose, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded,
                          color: Colors.white, size: 16),
                    )),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Anjali Sharma', style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w700, fontFamily: 'Playfair Display')),
              const Text('anjali@email.com',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              const Text('+91 98765 43210',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.roseBg, borderRadius: BorderRadius.circular(20)),
                child: const Text('Premium Member ⭐',
                  style: TextStyle(color: AppColors.rose,
                      fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // Stats
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat('2', 'Bookings'),
                _vd(),
                _stat('₹2,000', 'Wallet'),
                _vd(),
                _stat('3', 'Wishlist'),
                _vd(),
                _stat('320', 'Points'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Menu items
          Container(
            color: Colors.white,
            child: Column(children: [
              _menuItem(Icons.book_rounded, 'My Bookings',
                  () => Get.toNamed(AppRoutes.myBookings)),
              _menuItem(Icons.favorite_rounded, 'Wishlist',
                  () => Get.toNamed(AppRoutes.wishlist)),
              _menuItem(Icons.account_balance_wallet_rounded, 'Wallet',
                  () => Get.toNamed(AppRoutes.wallet)),
              _menuItem(Icons.star_rounded, 'My Reviews', () {}),
              _menuItem(Icons.headset_mic_rounded, 'Support Tickets', () {}),
              _menuItem(Icons.notifications_rounded, 'Notifications', () {}),
            ]),
          ),
          const SizedBox(height: 12),

          Container(
            color: Colors.white,
            child: Column(children: [
              _menuItem(Icons.language_rounded, 'Language (English)', () {}),
              _menuItem(Icons.dark_mode_rounded, 'Dark Mode', () {}),
              _menuItem(Icons.privacy_tip_rounded, 'Privacy Policy', () {}),
              _menuItem(Icons.description_rounded, 'Terms & Conditions', () {}),
              _menuItem(Icons.help_rounded, 'Help & FAQs', () {}),
            ]),
          ),
          const SizedBox(height: 12),

          Container(
            color: Colors.white,
            child: _menuItem(Icons.logout_rounded, 'Logout', () {
              showDialog(context: context, builder: (_) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: () => Get.offAllNamed(AppRoutes.login),
                    child: const Text('Logout'),
                  ),
                ],
              ));
            }, color: AppColors.error),
          ),
          const SizedBox(height: 32),

          const Text('PreWed Studio v1.0.0',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  Widget _stat(String val, String label) => Column(children: [
    Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
  ]);

  Widget _vd() => Container(width: 1, height: 32, color: AppColors.border);

  Widget _menuItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.rose, size: 22),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
          color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textMuted, size: 20),
      onTap: onTap,
    );
  }
}
