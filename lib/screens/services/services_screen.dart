// services_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  final _cats = const [
    {'name':'Photographer','icon':Icons.camera_alt_rounded,'color':0xFFFDF2F3,'count':'124 vendors'},
    {'name':'Videographer','icon':Icons.videocam_rounded,'color':0xFFF0F8FF,'count':'86 vendors'},
    {'name':'Makeup Artist','icon':Icons.face_retouching_natural,'color':0xFFFFF0F5,'count':'203 vendors'},
    {'name':'Hair Stylist','icon':Icons.face_rounded,'color':0xFFF5F0FF,'count':'97 vendors'},
    {'name':'Bridal Dress','icon':Icons.checkroom_rounded,'color':0xFFFFF8F0,'count':'68 vendors'},
    {'name':'Groom Dress','icon':Icons.dry_cleaning_rounded,'color':0xFFF0FFF8,'count':'54 vendors'},
    {'name':'Jewellery','icon':Icons.diamond_rounded,'color':0xFFFDF2F3,'count':'112 vendors'},
    {'name':'Vanity Van','icon':Icons.airport_shuttle_rounded,'color':0xFFF0F8FF,'count':'45 vendors'},
    {'name':'Props & Decor','icon':Icons.auto_awesome_rounded,'color':0xFFFFF5F0,'count':'78 vendors'},
    {'name':'Drone Shoot','icon':Icons.flight_rounded,'color':0xFFF5FFF0,'count':'32 vendors'},
    {'name':'Luxury Car','icon':Icons.directions_car_rounded,'color':0xFFFFF0F8,'count':'28 vendors'},
    {'name':'Flowers','icon':Icons.local_florist_rounded,'color':0xFFF0FFF5,'count':'56 vendors'},
    {'name':'Mehendi','icon':Icons.back_hand_rounded,'color':0xFFFDF8F0,'count':'89 vendors'},
    {'name':'Lighting','icon':Icons.lightbulb_rounded,'color':0xFFFFFBF0,'count':'37 vendors'},
    {'name':'Hair & Makeup','icon':Icons.spa_rounded,'color':0xFFF0F5FF,'count':'143 vendors'},
    {'name':'Catering','icon':Icons.restaurant_rounded,'color':0xFFF5FDF0,'count':'62 vendors'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('All Services')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.4,
          crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: _cats.length,
        itemBuilder: (_, i) {
          final c = _cats[i];
          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.vendorSearch,
                arguments: {'category': c['name']}),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 54, height: 54,
                  decoration: BoxDecoration(
                    color: Color(c['color'] as int),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(c['icon'] as IconData,
                      color: AppColors.rose, size: 26),
                ),
                const SizedBox(height: 8),
                Text(c['name'] as String, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700)),
                Text(c['count'] as String,
                  style: const TextStyle(fontSize: 11,
                      color: AppColors.textMuted)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
