import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_theme.dart';
import '../../main.dart';

// ═══════════════════════════════════════════════════════
// SELECT LOCATION
// ═══════════════════════════════════════════════════════
class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});
  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final _locCtrl  = TextEditingController();
  final _dateCtrl = TextEditingController();
  DateTime? _date;

  final _popular = [
    'Amer Fort, Jaipur','Nahargarh Fort, Jaipur',
    'Hawa Mahal, Jaipur','Jal Mahal, Jaipur',
    'Ranthambore, Sawai Madhopur','Lake Pichola, Udaipur',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Select Location & Date'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: 0.50, color: AppColors.rose,
              backgroundColor: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Where is your shoot?',
              style: TextStyle(fontFamily: 'Playfair Display',
                  fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Enter address or pick from map',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            TextField(
              controller: _locCtrl,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search location...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.rose),
                suffixIcon: Icon(Icons.my_location_rounded, color: AppColors.rose),
              ),
            ),
            const SizedBox(height: 16),

            // Map placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.map_rounded, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 8),
                      const Text('Tap to open Google Maps',
                          style: TextStyle(color: AppColors.textMuted)),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on_rounded, size: 16),
                        label: const Text('Pick on Map'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8)),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Popular
            const Text('Popular Locations',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _popular.map((loc) => GestureDetector(
                onTap: () => setState(() => _locCtrl.text = loc),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: _locCtrl.text == loc ? AppColors.rose : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _locCtrl.text == loc ? AppColors.rose : AppColors.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.location_on_rounded, size: 12,
                        color: _locCtrl.text == loc ? Colors.white : AppColors.rose),
                    const SizedBox(width: 4),
                    Text(loc, style: TextStyle(fontSize: 12,
                        color: _locCtrl.text == loc ? Colors.white : AppColors.textPrimary)),
                  ]),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // Date
            const Text('Select Shoot Date',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  builder: (ctx, child) => Theme(
                    data: Theme.of(ctx).copyWith(
                      colorScheme: const ColorScheme.light(primary: AppColors.rose)),
                    child: child!,
                  ),
                );
                if (d != null) setState(() {
                  _date = d;
                  _dateCtrl.text = '${d.day}/${d.month}/${d.year}';
                });
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Choose your shoot date',
                    prefixIcon: Icon(Icons.calendar_month_rounded, color: AppColors.rose),
                    suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _locCtrl.text.isNotEmpty && _date != null
                    ? () => Get.toNamed(AppRoutes.selectVendors, arguments: {
                        'location': _locCtrl.text,
                        'date': _dateCtrl.text,
                        'services': Get.arguments?['services'],
                      })
                    : null,
                child: const Text('Find Vendors Near Me →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// SELECT VENDORS
// ═══════════════════════════════════════════════════════
class SelectVendorsScreen extends StatefulWidget {
  const SelectVendorsScreen({super.key});
  @override
  State<SelectVendorsScreen> createState() => _SelectVendorsScreenState();
}

class _SelectVendorsScreenState extends State<SelectVendorsScreen> {
  final Map<String, Map> _selectedVendors = {};

  final _vendorsByService = {
    'Photographer': [
      {'id':1,'name':'Wedding Tales Photography','rating':4.8,'price':15000,'emoji':'📸','dist':'2.3 km'},
      {'id':2,'name':'Royal Frames Studio','rating':4.7,'price':12000,'emoji':'📷','dist':'4.1 km'},
      {'id':3,'name':'Candid Clicks Jaipur','rating':4.6,'price':10000,'emoji':'🎞️','dist':'5.5 km'},
    ],
    'Makeup Artist': [
      {'id':4,'name':'Glow Beauty Studio','rating':4.8,'price':8000,'emoji':'💄','dist':'1.8 km'},
      {'id':5,'name':'Glamour Zone Jaipur','rating':4.6,'price':6000,'emoji':'💅','dist':'3.2 km'},
    ],
    'Vanity Van': [
      {'id':6,'name':'Luxury Vanity Van','rating':4.7,'price':5000,'emoji':'🚐','dist':'2.5 km'},
      {'id':7,'name':'StarVan Services','rating':4.5,'price':4000,'emoji':'🚌','dist':'4.0 km'},
    ],
  };

  double get _total => _selectedVendors.values
      .fold(0.0, (s, v) => s + (v['price'] as int).toDouble());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Choose Your Vendors'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: 0.75, color: AppColors.rose,
              backgroundColor: AppColors.border),
        ),
      ),
      body: Column(
        children: [
          // Location info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              const Icon(Icons.location_on_rounded, color: AppColors.rose, size: 16),
              const SizedBox(width: 6),
              Text(Get.arguments?['location'] ?? 'Jaipur',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today_rounded, color: AppColors.rose, size: 14),
              const SizedBox(width: 6),
              Text(Get.arguments?['date'] ?? '',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ]),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: _vendorsByService.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 4),
                      child: Text(entry.key,
                        style: const TextStyle(fontFamily: 'Playfair Display',
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    ...entry.value.map((v) {
                      final sel = _selectedVendors[entry.key]?['id'] == v['id'];
                      return GestureDetector(
                        onTap: () => setState(() =>
                            _selectedVendors[entry.key] = v),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: sel ? AppColors.rose : AppColors.border,
                                width: sel ? 2 : 1),
                          ),
                          child: Row(children: [
                            Container(
                              width: 52, height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.roseBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: Text(v['emoji'] as String,
                                  style: const TextStyle(fontSize: 26))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(v['name'] as String,
                                    style: const TextStyle(fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 3),
                                  Row(children: [
                                    const Icon(Icons.star_rounded,
                                        color: Color(0xFFF5A623), size: 13),
                                    Text(' ${v['rating']}',
                                      style: const TextStyle(fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.location_on_rounded,
                                        size: 12, color: AppColors.textMuted),
                                    Text(v['dist'] as String,
                                      style: const TextStyle(fontSize: 12,
                                          color: AppColors.textMuted)),
                                  ]),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('₹${v['price']}',
                                  style: const TextStyle(fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.rose)),
                                if (sel)
                                  const Icon(Icons.check_circle_rounded,
                                      color: AppColors.rose, size: 20),
                              ],
                            ),
                          ]),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _selectedVendors.isNotEmpty
          ? Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${_selectedVendors.length} vendors selected'),
                      Text('Total: ₹${_total.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w700, color: AppColors.rose)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.bookingSummary,
                          arguments: {
                            'vendors': _selectedVendors,
                            'total': _total,
                            'location': Get.arguments?['location'],
                            'date': Get.arguments?['date'],
                          }),
                      child: const Text('Review Booking Summary →'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

// ═══════════════════════════════════════════════════════
// BOOKING SUMMARY
// ═══════════════════════════════════════════════════════
class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});
  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _couponCtrl = TextEditingController();
  double _discount = 0;
  bool _couponApplied = false;

  double get _subtotal => (Get.arguments?['total'] as double?) ?? 33000;
  double get _tax => _subtotal * 0.18;
  double get _total => _subtotal + _tax - _discount;
  double get _advance => _total * 0.30;
  double get _balance => _total - _advance;

  @override
  Widget build(BuildContext context) {
    final vendors = Get.arguments?['vendors'] as Map? ?? {};

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Booking Summary'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(value: 0.90, color: AppColors.rose,
              backgroundColor: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event info
            _card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Event Details',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _infoRow(Icons.location_on_rounded,
                    Get.arguments?['location'] ?? 'Amer Fort, Jaipur'),
                const SizedBox(height: 8),
                _infoRow(Icons.calendar_today_rounded,
                    Get.arguments?['date'] ?? '15/06/2025'),
              ],
            )),
            const SizedBox(height: 14),

            // Selected vendors
            _card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selected Vendors',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ...vendors.entries.map((e) {
                  final v = e.value as Map;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      Text(v['emoji'] ?? '📸',
                          style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v['name'] ?? '', style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                            Text(e.key, style: const TextStyle(
                                fontSize: 11, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      Text('₹${v['price'] ?? 0}',
                        style: const TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    ]),
                  );
                }),
                if (vendors.isEmpty) ...[
                  _summaryRow('Wedding Tales Photography (Photographer)', '₹15,000'),
                  _summaryRow('Glow Beauty Studio (Makeup)', '₹8,000'),
                  _summaryRow('Luxury Vanity Van', '₹5,000'),
                ],
              ],
            )),
            const SizedBox(height: 14),

            // Coupon
            _card(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Apply Coupon',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _couponCtrl,
                      enabled: !_couponApplied,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: 'Enter coupon code',
                        prefixIcon: Icon(Icons.local_offer_rounded,
                            color: AppColors.rose),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _couponApplied
                        ? () => setState(() {
                            _couponApplied = false;
                            _discount = 0;
                            _couponCtrl.clear();
                          })
                        : () {
                            if (_couponCtrl.text == 'PREWED20') {
                              setState(() {
                                _discount = _subtotal * 0.20;
                                _couponApplied = true;
                              });
                              Get.snackbar('🎉 Coupon Applied!',
                                  '20% discount applied',
                                  backgroundColor: AppColors.success,
                                  colorText: Colors.white);
                            } else {
                              Get.snackbar('Invalid', 'Coupon not valid',
                                  backgroundColor: AppColors.error,
                                  colorText: Colors.white);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _couponApplied ? Colors.grey : AppColors.rose),
                    child: Text(_couponApplied ? 'Remove' : 'Apply'),
                  ),
                ]),
                if (_couponApplied)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('✅ PREWED20 applied — 20% off!',
                      style: TextStyle(fontSize: 12, color: AppColors.success,
                          fontWeight: FontWeight.w600)),
                  ),
              ],
            )),
            const SizedBox(height: 14),

            // Price breakdown
            _card(Column(
              children: [
                const Align(alignment: Alignment.centerLeft,
                  child: Text('Price Breakdown',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
                const SizedBox(height: 12),
                _priceRow('Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
                _priceRow('GST (18%)', '₹${_tax.toStringAsFixed(0)}'),
                if (_discount > 0)
                  _priceRow('Coupon Discount', '-₹${_discount.toStringAsFixed(0)}',
                      color: AppColors.success),
                const Divider(height: 20),
                _priceRow('Total Amount', '₹${_total.toStringAsFixed(0)}',
                    bold: true, fontSize: 16),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.roseBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(children: [
                    _priceRow('Advance to Pay (30%)',
                        '₹${_advance.toStringAsFixed(0)}',
                        color: AppColors.rose, bold: true),
                    const SizedBox(height: 6),
                    _priceRow('Balance on Event Day',
                        '₹${_balance.toStringAsFixed(0)}',
                        color: AppColors.textSecondary),
                  ]),
                ),
              ],
            )),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.payment, arguments: {
                  'amount': _advance,
                  'total': _total,
                }),
                child: Text('Pay Advance ₹${_advance.toStringAsFixed(0)} →'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: child,
  );

  Widget _infoRow(IconData icon, String text) => Row(children: [
    Icon(icon, size: 16, color: AppColors.rose),
    const SizedBox(width: 8),
    Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
  ]);

  Widget _summaryRow(String label, String val) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13,
          color: AppColors.textSecondary))),
      Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _priceRow(String label, String val,
      {Color? color, bool bold = false, double fontSize = 14}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: fontSize,
            color: color ?? AppColors.textSecondary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400)),
        Text(val, style: TextStyle(fontSize: fontSize,
            color: color ?? AppColors.textPrimary,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600)),
      ]),
    );
}

// ═══════════════════════════════════════════════════════
// BOOKING CONFIRM SCREEN
// ═══════════════════════════════════════════════════════
class BookingConfirmScreen extends StatelessWidget {
  const BookingConfirmScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.success, size: 80),
          const SizedBox(height: 20),
          const Text('Booking Confirmed!',
            style: TextStyle(fontFamily: 'Playfair Display',
                fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('VIV-2025-000123',
            style: TextStyle(fontSize: 16, color: AppColors.textMuted)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(AppRoutes.home),
            child: const Text('Back to Home'),
          ),
        ]),
      ),
    );
  }
}
