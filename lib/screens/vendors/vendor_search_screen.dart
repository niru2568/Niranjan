import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class VendorSearchScreen extends StatefulWidget {
  const VendorSearchScreen({super.key});
  @override
  State<VendorSearchScreen> createState() => _VendorSearchScreenState();
}

class _VendorSearchScreenState extends State<VendorSearchScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'rating';
  double _minRating = 0;
  final _categories = ['All','Photographer','Videographer','Makeup Artist',
    'Hair Stylist','Bridal Dress','Groom Dress','Jewellery','Vanity Van',
    'Drone Shoot','Luxury Car','Flowers','Mehendi'];

  final _vendors = [
    {'name':'Wedding Tales Photography','cat':'Photographer','city':'Jaipur','rating':4.8,'reviews':70,'price':15000,'emoji':'📸'},
    {'name':'Glow Beauty Studio','cat':'Makeup Artist','city':'Jaipur','rating':4.8,'reviews':90,'price':8000,'emoji':'💄'},
    {'name':'Luxury Vanity Van','cat':'Vanity Van','city':'Jaipur','rating':4.7,'reviews':78,'price':5000,'emoji':'🚐'},
    {'name':'The Royal Clicks','cat':'Videographer','city':'Jaipur','rating':4.8,'reviews':108,'price':12000,'emoji':'🎥'},
    {'name':'Rajwada Jewellery','cat':'Jewellery','city':'Jaipur','rating':4.9,'reviews':121,'price':2000,'emoji':'💍'},
    {'name':'Mehak Bridal House','cat':'Bridal Dress','city':'Jaipur','rating':4.7,'reviews':65,'price':18000,'emoji':'👗'},
    {'name':'Royal Rides Jaipur','cat':'Luxury Car','city':'Jaipur','rating':4.6,'reviews':54,'price':12000,'emoji':'🚗'},
    {'name':'Drone Vision Pro','cat':'Drone Shoot','city':'Jaipur','rating':4.7,'reviews':38,'price':8000,'emoji':'🚁'},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _vendors.where((v) =>
      (_selectedCategory == 'All' || v['cat'] == _selectedCategory) &&
      (v['name'] as String).toLowerCase().contains(_searchCtrl.text.toLowerCase()) &&
      (v['rating'] as double) >= _minRating
    ).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Find Vendors'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search vendors...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.rose),
                suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () { _searchCtrl.clear(); setState(() {}); })
                  : null,
              ),
            ),
          ),

          // Category chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final active = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.rose : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: active ? AppColors.rose : AppColors.border),
                    ),
                    child: Text(cat,
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500,
                        color: active ? Colors.white : AppColors.textSecondary,
                      )),
                  ),
                );
              },
            ),
          ),

          // Count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${filtered.length} vendors found',
                  style: const TextStyle(fontSize: 13,
                      color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                GestureDetector(
                  onTap: _showSortSheet,
                  child: Row(children: [
                    const Icon(Icons.sort_rounded, size: 16, color: AppColors.rose),
                    const SizedBox(width: 4),
                    Text('Sort', style: const TextStyle(
                        color: AppColors.rose, fontSize: 13, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: filtered.isEmpty
              ? const Center(child: Text('No vendors found',
                  style: TextStyle(color: AppColors.textMuted)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _vendorTile(filtered[i]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _vendorTile(Map v) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vendorDetail, arguments: {'vendor': v}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.roseBg,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            ),
            child: Center(child: Text(v['emoji'], style: const TextStyle(fontSize: 44))),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v['name'], maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.roseBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(v['cat'],
                        style: const TextStyle(fontSize: 11, color: AppColors.rose,
                            fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.location_on_rounded,
                        size: 12, color: AppColors.textMuted),
                    Text(v['city'],
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.star_rounded, color: Color(0xFFF5A623), size: 15),
                    const SizedBox(width: 2),
                    Text('${v['rating']}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(' (${v['reviews']} reviews)',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(text: TextSpan(children: [
                        const TextSpan(text: 'From ',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        TextSpan(text: '₹${v['price']}',
                          style: const TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700, color: AppColors.rose)),
                      ])),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.rose,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Book Now',
                          style: TextStyle(color: Colors.white,
                              fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filters', style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            const Text('Minimum Rating',
              style: TextStyle(fontWeight: FontWeight.w600)),
            Slider(
              value: _minRating,
              min: 0, max: 5, divisions: 10,
              activeColor: AppColors.rose,
              label: _minRating.toString(),
              onChanged: (v) => setState(() => _minRating = v),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { Navigator.pop(context); setState(() {}); },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            ...[
              ['rating', 'Top Rated'],
              ['price_asc', 'Price: Low to High'],
              ['price_desc', 'Price: High to Low'],
              ['distance', 'Nearest First'],
            ].map((s) => ListTile(
              title: Text(s[1]),
              leading: Radio<String>(
                value: s[0], groupValue: _sortBy,
                activeColor: AppColors.rose,
                onChanged: (v) {
                  setState(() => _sortBy = v!);
                  Navigator.pop(context);
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
