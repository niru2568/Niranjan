import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key});
  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  bool _wishlisted = false;

  final _reviews = [
    {'name':'Priya & Rahul','rating':5.0,'text':'Absolutely brilliant! Photos were stunning.','date':'May 2024'},
    {'name':'Anjali & Amit','rating':4.5,'text':'Very professional. Delivered on time.','date':'Apr 2024'},
    {'name':'Sneha & Rohan','rating':5.0,'text':'Best photographer in Jaipur!','date':'Mar 2024'},
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final v = Get.arguments?['vendor'] as Map? ?? {
      'name':'Wedding Tales Photography','cat':'Photographer',
      'city':'Jaipur','rating':4.8,'reviews':70,'price':15000,'emoji':'📸',
    };

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Hero
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.dark,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary, size: 20)),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    _wishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _wishlisted ? AppColors.rose : AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                onPressed: () => setState(() => _wishlisted = !_wishlisted),
              ),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.share_rounded, color: AppColors.textPrimary, size: 20)),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.roseBg,
                child: Center(
                  child: Text(v['emoji'] as String? ?? '📸',
                      style: const TextStyle(fontSize: 80)),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor info card
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(v['name'] as String,
                                  style: const TextStyle(fontFamily: 'Playfair Display',
                                      fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.roseBg,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(v['cat'] as String,
                                      style: const TextStyle(fontSize: 11,
                                          color: AppColors.rose, fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.location_on_rounded,
                                      size: 14, color: AppColors.textMuted),
                                  Text(v['city'] as String,
                                    style: const TextStyle(fontSize: 12,
                                        color: AppColors.textMuted)),
                                ]),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5A623).withOpacity(.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFF5A623), size: 18),
                              const SizedBox(width: 4),
                              Text('${v['rating']}',
                                style: const TextStyle(fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                            ]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        _infoBadge(Icons.verified_rounded, 'Verified', Colors.green),
                        const SizedBox(width: 8),
                        _infoBadge(Icons.flash_on_rounded, 'Instant Booking', AppColors.gold),
                        const SizedBox(width: 8),
                        _infoBadge(Icons.star_rounded,
                            '${v['reviews']} Reviews', AppColors.rose),
                      ]),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _stat('Experience', '5+ Years'),
                          _vDivider(),
                          _stat('Projects', '120+'),
                          _vDivider(),
                          _stat('Cities', '3'),
                          _vDivider(),
                          _stat('Response', '< 1 hr'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabs,
                    labelColor: AppColors.rose,
                    unselectedLabelColor: AppColors.textMuted,
                    indicatorColor: AppColors.rose,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Portfolio'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _overviewTab(v),
                      _portfolioTab(),
                      _reviewsTab(),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),

      // Bottom Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08),
              blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Starting from',
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text('₹${v['price']}',
                  style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700, color: AppColors.rose)),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.selectServices),
            icon: const Icon(Icons.calendar_month_rounded, size: 18),
            label: const Text('Book Now'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _overviewTab(Map v) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('We are a professional wedding photography studio based in Jaipur with over 5 years of experience capturing beautiful pre-wedding moments. We specialize in candid, traditional, and cinematic styles.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
          const SizedBox(height: 20),
          const Text('Services & Pricing',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...[
            ['Basic Package', '4 hrs, 100 edited photos', '₹15,000'],
            ['Standard Package', '8 hrs, 250 edited photos', '₹25,000'],
            ['Premium Package', 'Full day, 500 photos + video', '₹45,000'],
          ].map((p) => _pricingCard(p[0], p[1], p[2])),
        ],
      ),
    );
  }

  Widget _portfolioTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
      itemCount: 12,
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: AppColors.roseBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(['📸','🌸','💑','🎭','✨','🏰'][i % 6],
            style: const TextStyle(fontSize: 28))),
      ),
    );
  }

  Widget _reviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _reviews.map((r) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: AppColors.roseBg,
                  child: Text((r['name'] as String)[0],
                    style: const TextStyle(color: AppColors.rose, fontWeight: FontWeight.w700))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r['name'] as String,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  Text(r['date'] as String,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                ]),
              ),
              RatingBarIndicator(
                rating: r['rating'] as double,
                itemBuilder: (_, __) => const Icon(Icons.star_rounded, color: Color(0xFFF5A623)),
                itemSize: 14,
              ),
            ]),
            const SizedBox(height: 8),
            Text(r['text'] as String,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _infoBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _stat(String label, String val) => Column(children: [
    Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
  ]);

  Widget _vDivider() => Container(width: 1, height: 30, color: AppColors.border);

  Widget _pricingCard(String name, String desc, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ]),
        ),
        Text(price,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.rose)),
      ]),
    );
  }
}
