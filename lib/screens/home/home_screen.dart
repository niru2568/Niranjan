import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  final _searchCtrl = TextEditingController();

  final _categories = [
    {'name': 'Photographer',  'icon': Icons.camera_alt_rounded,      'color': 0xFFFDF2F3},
    {'name': 'Videographer',  'icon': Icons.videocam_rounded,         'color': 0xFFF0F8FF},
    {'name': 'Makeup Artist', 'icon': Icons.face_retouching_natural,  'color': 0xFFFFF0F5},
    {'name': 'Hair Stylist',  'icon': Icons.face_rounded,             'color': 0xFFF5F0FF},
    {'name': 'Bridal Dress',  'icon': Icons.checkroom_rounded,        'color': 0xFFFFF8F0},
    {'name': 'Groom Dress',   'icon': Icons.dry_cleaning_rounded,     'color': 0xFFF0FFF8},
    {'name': 'Jewellery',     'icon': Icons.diamond_rounded,          'color': 0xFFFDF2F3},
    {'name': 'Vanity Van',    'icon': Icons.airport_shuttle_rounded,  'color': 0xFFF0F8FF},
    {'name': 'Props & Decor', 'icon': Icons.auto_awesome_rounded,     'color': 0xFFFFF5F0},
    {'name': 'Drone Shoot',   'icon': Icons.flight_rounded,           'color': 0xFFF5FFF0},
    {'name': 'Luxury Car',    'icon': Icons.directions_car_rounded,   'color': 0xFFFFF0F8},
    {'name': 'Flowers',       'icon': Icons.local_florist_rounded,    'color': 0xFFF0FFF5},
    {'name': 'Mehendi',       'icon': Icons.back_hand_rounded,        'color': 0xFFFDF8F0},
    {'name': 'Lighting',      'icon': Icons.lightbulb_rounded,        'color': 0xFFFFFBF0},
    {'name': 'Hair & Makeup', 'icon': Icons.spa_rounded,              'color': 0xFFF0F5FF},
    {'name': 'Catering',      'icon': Icons.restaurant_rounded,       'color': 0xFFF5FDF0},
  ];

  final _vendors = [
    {'name': 'Wedding Tales Photography', 'cat': 'Photographer', 'city': 'Jaipur',
     'rating': 4.8, 'reviews': 70, 'price': 15000, 'emoji': '📸'},
    {'name': 'Glow Beauty Studio',        'cat': 'Makeup Artist',  'city': 'Jaipur',
     'rating': 4.8, 'reviews': 90, 'price': 8000,  'emoji': '💄'},
    {'name': 'Luxury Vanity Van',         'cat': 'Vanity Van',     'city': 'Jaipur',
     'rating': 4.7, 'reviews': 78, 'price': 5000,  'emoji': '🚐'},
    {'name': 'The Royal Clicks',          'cat': 'Videographer',   'city': 'Jaipur',
     'rating': 4.8, 'reviews': 108,'price': 12000, 'emoji': '🎥'},
    {'name': 'Rajwada Jewellery',         'cat': 'Jewellery',      'city': 'Jaipur',
     'rating': 4.9, 'reviews': 121,'price': 2000,  'emoji': '💍'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: _buildBottomNav(),
      body: _navIndex == 0
          ? _buildHome()
          : _navIndex == 1
              ? _buildSearch()
              : _navIndex == 2
                  ? _buildBookingsTab()
                  : _buildProfileTab(),
    );
  }

  Widget _buildHome() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.dark,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1A2E), Color(0xFF3D2020)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.location_on_rounded,
                              color: AppColors.rose, size: 16),
                          const SizedBox(width: 4),
                          const Text('Jaipur, Rajasthan',
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white70, size: 16),
                        ]),
                        const SizedBox(height: 4),
                        const Text('All Your Pre-Wedding\nNeeds, One Place',
                          style: TextStyle(fontFamily: 'Playfair Display',
                              fontSize: 20, fontWeight: FontWeight.w700,
                              color: Colors.white, height: 1.3)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_rounded, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
              onPressed: () => Get.toNamed(AppRoutes.wishlist),
            ),
          ],
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.vendorSearch),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 10)],
                    ),
                    child: Row(children: [
                      const Icon(Icons.search_rounded, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Text('Search vendors, services...',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.roseBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Filter',
                            style: TextStyle(color: AppColors.rose,
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                ),
              ),

              // Stats
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  children: [
                    _statBadge('500+', 'Vendors'),
                    const SizedBox(width: 10),
                    _statBadge('10K+', 'Couples'),
                    const SizedBox(width: 10),
                    _statBadge('50+', 'Cities'),
                  ],
                ),
              ),

              // Start Booking CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.selectServices),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.rose, Color(0xFFE8636D)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(
                          color: AppColors.rose.withOpacity(.3),
                          blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Plan Your Dream Shoot',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w700, fontSize: 15)),
                            SizedBox(height: 4),
                            Text('Select services → Pick location → Book vendors',
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Start',
                          style: TextStyle(color: AppColors.rose,
                              fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ]),
                  ),
                ),
              ),

              // Categories
              _sectionHeader('Our Services', 'View All',
                  () => Get.toNamed(AppRoutes.services)),
              SizedBox(
                height: 108,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final c = _categories[i];
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.vendorSearch,
                          arguments: {'category': c['name']}),
                      child: Container(
                        width: 80, margin: const EdgeInsets.only(right: 10),
                        child: Column(children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              color: Color(c['color'] as int),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Icon(c['icon'] as IconData,
                                color: AppColors.rose, size: 28),
                          ),
                          const SizedBox(height: 6),
                          Text(c['name'] as String,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),

              // Popular Vendors
              _sectionHeader('Popular Vendors', 'View All',
                  () => Get.toNamed(AppRoutes.vendorSearch)),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _vendors.length,
                  itemBuilder: (_, i) {
                    final v = _vendors[i];
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.vendorDetail,
                          arguments: {'vendor': v}),
                      child: Container(
                        width: 165,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(.04),
                              blurRadius: 8)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.roseBg,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(14)),
                              ),
                              child: Center(
                                child: Text(v['emoji'] as String,
                                    style: const TextStyle(fontSize: 48)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v['name'] as String,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text('${v['cat']} · ${v['city']}',
                                    style: const TextStyle(fontSize: 11,
                                        color: AppColors.textMuted)),
                                  const SizedBox(height: 6),
                                  Row(children: [
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xFFF5A623), size: 14),
                                    const SizedBox(width: 2),
                                    Text('${v['rating']}',
                                      style: const TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                    Text(' (${v['reviews']})',
                                      style: const TextStyle(fontSize: 11,
                                          color: AppColors.textMuted)),
                                    const Spacer(),
                                    Text('₹${(v['price'] as int) ~/ 1000}K+',
                                      style: const TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.rose)),
                                  ]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // How It Works
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('How It Works'),
                    const SizedBox(height: 16),
                    ...[
                      ['1', 'Choose Services', 'Select the services you need', Icons.grid_view_rounded],
                      ['2', 'Select Location', 'Drop a pin on your shoot location', Icons.location_on_rounded],
                      ['3', 'Find Vendors',   'We find best vendors near you', Icons.people_alt_rounded],
                      ['4', 'Book & Enjoy',   'Book & pay securely', Icons.celebration_rounded],
                    ].map((s) => _howStep(s[0] as String, s[1] as String,
                        s[2] as String, s[3] as IconData)),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() => const VendorSearchPlaceholder();
  Widget _buildBookingsTab() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Get.toNamed(AppRoutes.myBookings));
    return const SizedBox();
  }
  Widget _buildProfileTab() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Get.toNamed(AppRoutes.profile));
    return const SizedBox();
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: (i) => setState(() => _navIndex = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark_rounded), label: 'Bookings'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }

  Widget _sectionHeader(String title, String action, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _sectionTitle(title),
          GestureDetector(
            onTap: onTap,
            child: Text(action,
              style: const TextStyle(color: AppColors.rose,
                  fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t,
    style: const TextStyle(fontFamily: 'Playfair Display',
        fontSize: 18, fontWeight: FontWeight.w700));

  Widget _statBadge(String num, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(children: [
          Text(num, style: const TextStyle(fontSize: 16,
              fontWeight: FontWeight.w700, color: AppColors.rose)),
          Text(label, style: const TextStyle(fontSize: 11,
              color: AppColors.textMuted)),
        ]),
      ),
    );
  }

  Widget _howStep(String num, String title, String desc, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.roseBg, shape: BoxShape.circle,
            border: Border.all(color: AppColors.rose.withOpacity(.3)),
          ),
          child: Center(
            child: Text(num,
              style: const TextStyle(color: AppColors.rose,
                  fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14,
                fontWeight: FontWeight.w700)),
            Text(desc, style: const TextStyle(fontSize: 12,
                color: AppColors.textSecondary)),
          ]),
        ),
        Icon(icon, color: AppColors.rose.withOpacity(.4), size: 22),
      ]),
    );
  }
}

class VendorSearchPlaceholder extends StatelessWidget {
  const VendorSearchPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Get.toNamed(AppRoutes.vendorSearch));
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
