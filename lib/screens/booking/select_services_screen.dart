// ═══════════════════════════════════════════════════════
// SELECT SERVICES SCREEN
// ═══════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

class SelectServicesScreen extends StatefulWidget {
  const SelectServicesScreen({super.key});
  @override
  State<SelectServicesScreen> createState() => _SelectServicesScreenState();
}

class _SelectServicesScreenState extends State<SelectServicesScreen> {
  final Set<int> _selected = {};

  final _services = [
    {'id':1,'name':'Photographer',  'icon':Icons.camera_alt_rounded,     'color':0xFFFDF2F3,'desc':'Capture every moment'},
    {'id':2,'name':'Videographer',  'icon':Icons.videocam_rounded,        'color':0xFFF0F8FF,'desc':'Cinematic films'},
    {'id':3,'name':'Makeup Artist', 'icon':Icons.face_retouching_natural, 'color':0xFFFFF0F5,'desc':'Bridal makeup'},
    {'id':4,'name':'Hair Stylist',  'icon':Icons.face_rounded,            'color':0xFFF5F0FF,'desc':'Perfect hairstyles'},
    {'id':5,'name':'Bridal Dress',  'icon':Icons.checkroom_rounded,       'color':0xFFFFF8F0,'desc':'Designer lehenga'},
    {'id':6,'name':'Groom Dress',   'icon':Icons.dry_cleaning_rounded,    'color':0xFFF0FFF8,'desc':'Sherwani & suit'},
    {'id':7,'name':'Jewellery',     'icon':Icons.diamond_rounded,         'color':0xFFFDF2F3,'desc':'Bridal jewellery'},
    {'id':8,'name':'Vanity Van',    'icon':Icons.airport_shuttle_rounded, 'color':0xFFF0F8FF,'desc':'Mobile studio'},
    {'id':9,'name':'Props & Decor', 'icon':Icons.auto_awesome_rounded,    'color':0xFFFFF5F0,'desc':'Theme decoration'},
    {'id':10,'name':'Drone Shoot',  'icon':Icons.flight_rounded,          'color':0xFFF5FFF0,'desc':'Aerial shots'},
    {'id':11,'name':'Luxury Car',   'icon':Icons.directions_car_rounded,  'color':0xFFFFF0F8,'desc':'Premium rides'},
    {'id':12,'name':'Flowers',      'icon':Icons.local_florist_rounded,   'color':0xFFF0FFF5,'desc':'Floral decoration'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Select Services'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: 0.25, color: AppColors.rose,
              backgroundColor: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('What do you need for your shoot?',
                style: TextStyle(fontFamily: 'Playfair Display',
                    fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              const Text('Select one or more services',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ]),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.9,
                crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: _services.length,
              itemBuilder: (_, i) {
                final s = _services[i];
                final id = s['id'] as int;
                final sel = _selected.contains(id);
                return GestureDetector(
                  onTap: () => setState(() =>
                      sel ? _selected.remove(id) : _selected.add(id)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: sel ? AppColors.rose : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: sel ? AppColors.rose : AppColors.border,
                          width: sel ? 2 : 1),
                      boxShadow: sel ? [BoxShadow(
                          color: AppColors.rose.withOpacity(.2),
                          blurRadius: 12, offset: const Offset(0,4))] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: sel ? Colors.white.withOpacity(.2)
                                : Color(s['color'] as int),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(s['icon'] as IconData,
                              size: 26,
                              color: sel ? Colors.white : AppColors.rose),
                        ),
                        const SizedBox(height: 8),
                        Text(s['name'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : AppColors.textPrimary)),
                        if (sel)
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selected.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.selectLocation,
                    arguments: {'services': _selected.toList()}),
                child: Text('Continue with ${_selected.length} service${_selected.length > 1 ? "s" : ""} →'),
              ),
            )
          : null,
    );
  }
}
