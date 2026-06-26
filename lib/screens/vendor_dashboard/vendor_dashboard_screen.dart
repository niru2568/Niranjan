import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

// ═══════════════════════════════════════════════════════
// VENDOR DASHBOARD
// ═══════════════════════════════════════════════════════
class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});
  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _navIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIdx,
        onTap: (i) {
          if (i == 1) Get.toNamed(AppRoutes.vendorBookings);
          else if (i == 2) Get.toNamed(AppRoutes.vendorServices);
          else if (i == 3) Get.toNamed(AppRoutes.vendorPortfolio);
          else setState(() => _navIdx = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.design_services_rounded), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library_rounded), label: 'Portfolio'),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            pinned: true,
            backgroundColor: AppColors.dark,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_rounded, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF3D2020)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
                child: Row(children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.rose,
                    child: const Text('W', style: TextStyle(color: Colors.white,
                        fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Wedding Tales Photography',
                          style: TextStyle(color: Colors.white,
                              fontSize: 15, fontWeight: FontWeight.w700),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                        const Text('Photographer · Jaipur',
                          style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFF5A623), size: 14),
                          const Text(' 4.8',
                            style: TextStyle(color: Colors.white,
                                fontSize: 12, fontWeight: FontWeight.w600)),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('Verified ✓',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Stats grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.6,
                  children: [
                    _statCard('Total Earnings', '₹1,25,000', Icons.currency_rupee_rounded,
                        AppColors.success, '+12% this month'),
                    _statCard('This Month', '₹32,000', Icons.calendar_month_rounded,
                        AppColors.rose, '4 bookings'),
                    _statCard('Total Bookings', '18', Icons.book_rounded,
                        AppColors.gold, '3 upcoming'),
                    _statCard('Pending Bookings', '3', Icons.pending_rounded,
                        AppColors.warning, 'Action needed'),
                  ],
                ),
                const SizedBox(height: 16),

                // Wallet card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.rose, Color(0xFFE8636D)]),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(
                        color: AppColors.rose.withOpacity(.25),
                        blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Vendor Wallet',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                          SizedBox(height: 4),
                          Text('₹18,500',
                            style: TextStyle(color: Colors.white,
                                fontSize: 28, fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('Available for withdrawal',
                            style: TextStyle(color: Colors.white60, fontSize: 11)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _requestPayout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.rose,
                      ),
                      child: const Text('Withdraw'),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // Quick actions
                const Align(alignment: Alignment.centerLeft,
                  child: Text('Quick Actions', style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.w700, fontFamily: 'Playfair Display'))),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _action(Icons.book_rounded, 'Bookings',
                        () => Get.toNamed(AppRoutes.vendorBookings)),
                    _action(Icons.design_services_rounded, 'Services',
                        () => Get.toNamed(AppRoutes.vendorServices)),
                    _action(Icons.photo_library_rounded, 'Portfolio',
                        () => Get.toNamed(AppRoutes.vendorPortfolio)),
                    _action(Icons.calendar_month_rounded, 'Calendar', () {}),
                    _action(Icons.bar_chart_rounded, 'Analytics', () {}),
                    _action(Icons.star_rounded, 'Reviews', () {}),
                    _action(Icons.local_offer_rounded, 'Offers', () {}),
                    _action(Icons.account_balance_rounded, 'Payouts', () {}),
                  ],
                ),
                const SizedBox(height: 16),

                // Recent bookings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Bookings', style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.w700, fontFamily: 'Playfair Display')),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.vendorBookings),
                      child: const Text('View All',
                        style: TextStyle(color: AppColors.rose,
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...[
                  {'customer':'Anjali & Rohit','date':'15 Jun 2025',
                   'amount':15000,'status':'confirmed','loc':'Amer Fort'},
                  {'customer':'Priya & Rahul','date':'22 Jun 2025',
                   'amount':25000,'status':'pending','loc':'Nahargarh'},
                  {'customer':'Sneha & Amit','date':'28 May 2025',
                   'amount':15000,'status':'completed','loc':'Jal Mahal'},
                ].map((b) => _bookingItem(b)),

                const SizedBox(height: 16),

                // Performance
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Profile Performance',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _perfRow('Profile Views', 0.72, '1,240'),
                    const SizedBox(height: 10),
                    _perfRow('Response Rate', 0.95, '95%'),
                    const SizedBox(height: 10),
                    _perfRow('Booking Rate', 0.60, '60%'),
                    const SizedBox(height: 10),
                    _perfRow('Rating Score', 0.96, '4.8/5'),
                  ]),
                ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String val, IconData icon,
      Color color, String sub) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Spacer(),
          Text(sub, style: const TextStyle(fontSize: 10,
              color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 8),
        Text(val, style: TextStyle(fontSize: 20,
            fontWeight: FontWeight.w700, color: color)),
        Text(label, style: const TextStyle(fontSize: 11,
            color: AppColors.textMuted)),
      ]),
    );
  }

  Widget _action(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.roseBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.rose, size: 22),
        ),
        const SizedBox(height: 5),
        Text(label, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
              color: AppColors.textPrimary)),
      ]),
    );
  }

  Widget _bookingItem(Map b) {
    final statusColor = b['status'] == 'confirmed'
        ? AppColors.success
        : b['status'] == 'pending'
            ? AppColors.warning
            : AppColors.textMuted;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppColors.roseBg, radius: 20,
          child: Text((b['customer'] as String)[0],
            style: const TextStyle(color: AppColors.rose, fontWeight: FontWeight.w700))),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(b['customer'] as String,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          Text('${b['date']} · ${b['loc']}',
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('₹${b['amount']}',
            style: const TextStyle(fontSize: 13,
                fontWeight: FontWeight.w700, color: AppColors.rose)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text((b['status'] as String).capitalizeFirst!,
              style: TextStyle(fontSize: 10,
                  fontWeight: FontWeight.w600, color: statusColor)),
          ),
        ]),
      ]),
    );
  }

  Widget _perfRow(String label, double val, String display) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(display, style: const TextStyle(fontSize: 13,
            fontWeight: FontWeight.w600, color: AppColors.rose)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: val,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation(AppColors.rose),
          minHeight: 6,
        ),
      ),
    ]);
  }

  void _requestPayout() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Request Payout', style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Available: ₹18,500',
            style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter amount', prefixText: '₹ '),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          const Text('Payout processed in 2-3 business days',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar('✅ Payout Requested',
                    'Will be credited in 2-3 business days',
                    backgroundColor: AppColors.success,
                    colorText: Colors.white);
              },
              child: const Text('Request Payout'),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// VENDOR BOOKINGS
// ═══════════════════════════════════════════════════════
class VendorBookingsScreen extends StatelessWidget {
  const VendorBookingsScreen({super.key});

  final _bookings = const [
    {'id':'VIV-2025-000123','customer':'Anjali & Rohit','date':'15 Jun 2025',
     'location':'Amer Fort, Jaipur','amount':15000,'status':'confirmed','phone':'9876543210'},
    {'id':'VIV-2025-000131','customer':'Priya & Rahul','date':'22 Jun 2025',
     'location':'Nahargarh Fort','amount':25000,'status':'pending','phone':'9123456780'},
    {'id':'VIV-2025-000145','customer':'Meera & Vikram','date':'30 Jun 2025',
     'location':'Hawa Mahal','amount':15000,'status':'pending','phone':'9988776655'},
    {'id':'VIV-2025-000089','customer':'Sneha & Amit','date':'28 May 2025',
     'location':'Jal Mahal','amount':15000,'status':'completed','phone':'9012345678'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        itemBuilder: (_, i) {
          final b = _bookings[i];
          final isPending = b['status'] == 'pending';
          final statusColor = isPending ? AppColors.warning
              : b['status'] == 'confirmed'
                  ? AppColors.success : AppColors.textMuted;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(b['id'] as String,
                          style: const TextStyle(fontSize: 12,
                              color: AppColors.textMuted)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text((b['status'] as String).capitalizeFirst!,
                            style: TextStyle(fontSize: 11,
                                fontWeight: FontWeight.w600, color: statusColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(b['customer'] as String,
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Playfair Display')),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 13, color: AppColors.rose),
                      const SizedBox(width: 5),
                      Text(b['date'] as String,
                        style: const TextStyle(fontSize: 13)),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: AppColors.rose),
                      const SizedBox(width: 5),
                      Text(b['location'] as String,
                        style: const TextStyle(fontSize: 13,
                            color: AppColors.textSecondary)),
                    ]),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₹${b['amount']}',
                          style: const TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700, color: AppColors.rose)),
                        Row(children: [
                          IconButton(
                            icon: const Icon(Icons.phone_rounded,
                                color: AppColors.success, size: 22),
                            onPressed: () {},
                          ),
                          if (isPending) ...[
                            OutlinedButton(
                              onPressed: () => Get.snackbar(
                                  'Declined', 'Booking declined',
                                  backgroundColor: AppColors.error,
                                  colorText: Colors.white),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                              ),
                              child: const Text('Decline',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => Get.snackbar(
                                  '✅ Confirmed!', 'Booking confirmed',
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6)),
                              child: const Text('Confirm',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// VENDOR SERVICES
// ═══════════════════════════════════════════════════════
class VendorServicesScreen extends StatefulWidget {
  const VendorServicesScreen({super.key});
  @override
  State<VendorServicesScreen> createState() => _VendorServicesScreenState();
}

class _VendorServicesScreenState extends State<VendorServicesScreen> {
  final _services = [
    {'name':'Basic Package','desc':'4 hrs, 100 edited photos','price':15000,'active':true},
    {'name':'Standard Package','desc':'8 hrs, 250 photos + short video','price':25000,'active':true},
    {'name':'Premium Package','desc':'Full day, 500 photos + cinematic video','price':45000,'active':false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My Services')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addService,
        backgroundColor: AppColors.rose,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Service'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _services.length,
        itemBuilder: (_, i) {
          final s = _services[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['name'] as String,
                      style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(s['desc'] as String,
                      style: const TextStyle(fontSize: 12,
                          color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                    Text('₹${s['price']}',
                      style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.w700, color: AppColors.rose)),
                  ],
                ),
              ),
              Column(children: [
                Switch(
                  value: s['active'] as bool,
                  activeColor: AppColors.rose,
                  onChanged: (v) => setState(() => _services[i]['active'] = v),
                ),
                Text((s['active'] as bool) ? 'Active' : 'Inactive',
                  style: TextStyle(fontSize: 10,
                    color: (s['active'] as bool)
                        ? AppColors.success : AppColors.textMuted)),
                IconButton(
                  icon: const Icon(Icons.edit_rounded,
                      color: AppColors.rose, size: 20),
                  onPressed: () {},
                ),
              ]),
            ]),
          );
        },
      ),
    );
  }

  void _addService() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24,
            MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Add New Service', style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Service Name')),
          const SizedBox(height: 12),
          TextField(controller: descCtrl,
            decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 12),
          TextField(controller: priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                labelText: 'Price', prefixText: '₹ ')),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _services.add({
                  'name': nameCtrl.text,
                  'desc': descCtrl.text,
                  'price': int.tryParse(priceCtrl.text) ?? 0,
                  'active': true,
                }));
                Get.back();
                Get.snackbar('✅ Service Added', 'New service added successfully',
                    backgroundColor: AppColors.success, colorText: Colors.white);
              },
              child: const Text('Add Service'),
            ),
          ),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// VENDOR PORTFOLIO
// ═══════════════════════════════════════════════════════
class VendorPortfolioScreen extends StatefulWidget {
  const VendorPortfolioScreen({super.key});
  @override
  State<VendorPortfolioScreen> createState() => _VendorPortfolioScreenState();
}

class _VendorPortfolioScreenState extends State<VendorPortfolioScreen> {
  final _items = ['📸','🌸','💑','🎭','✨','🏰','🌅','💐','🎊','🎈','🌟','🎆'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          TextButton.icon(
            onPressed: () => Get.snackbar('Upload', 'Select photos to upload'),
            icon: const Icon(Icons.add_photo_alternate_rounded,
                color: AppColors.rose),
            label: const Text('Upload',
              style: TextStyle(color: AppColors.rose, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: Column(children: [
        // Stats
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat('12', 'Photos'),
              _divider(),
              _stat('3', 'Videos'),
              _divider(),
              _stat('2', 'Reels'),
              _divider(),
              _stat('1.2K', 'Views'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
            itemCount: _items.length,
            itemBuilder: (_, i) => Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.roseBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(_items[i],
                      style: const TextStyle(fontSize: 36))),
                ),
                Positioned(
                  top: 4, right: 4,
                  child: GestureDetector(
                    onTap: () => setState(() => _items.removeAt(i)),
                    child: Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _stat(String val, String label) => Column(children: [
    Text(val, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
        color: AppColors.rose)),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
  ]);

  Widget _divider() => Container(width: 1, height: 30, color: AppColors.border);
}
