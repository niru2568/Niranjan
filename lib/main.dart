import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/vendors/vendor_search_screen.dart';
import 'screens/vendors/vendor_detail_screen.dart';
import 'screens/booking/select_services_screen.dart';
import 'screens/booking/select_location_screen.dart';
import 'screens/booking/select_vendors_screen.dart';
import 'screens/booking/booking_summary_screen.dart';
import 'screens/booking/booking_confirm_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/customer_dashboard/customer_dashboard_screen.dart';
import 'screens/customer_dashboard/my_bookings_screen.dart';
import 'screens/customer_dashboard/wishlist_screen.dart';
import 'screens/customer_dashboard/wallet_screen.dart';
import 'screens/customer_dashboard/profile_screen.dart';
import 'screens/vendor_dashboard/vendor_dashboard_screen.dart';
import 'screens/vendor_dashboard/vendor_bookings_screen.dart';
import 'screens/vendor_dashboard/vendor_services_screen.dart';
import 'screens/vendor_dashboard/vendor_portfolio_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Status bar style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Lock to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PreWedApp());
}

class PreWedApp extends StatelessWidget {
  const PreWedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PreWed Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

class AppRoutes {
  // Auth
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';

  // Main
  static const home = '/home';
  static const services = '/services';
  static const vendorSearch = '/vendor-search';
  static const vendorDetail = '/vendor-detail';

  // Booking Flow
  static const selectServices = '/book/services';
  static const selectLocation = '/book/location';
  static const selectVendors = '/book/vendors';
  static const bookingSummary = '/book/summary';
  static const bookingConfirm = '/book/confirm';

  // Payment
  static const payment = '/payment';
  static const paymentSuccess = '/payment-success';

  // Customer Dashboard
  static const customerDashboard = '/dashboard';
  static const myBookings = '/my-bookings';
  static const wishlist = '/wishlist';
  static const wallet = '/wallet';
  static const profile = '/profile';

  // Vendor Dashboard
  static const vendorDashboard = '/vendor/dashboard';
  static const vendorBookings = '/vendor/bookings';
  static const vendorServices = '/vendor/services';
  static const vendorPortfolio = '/vendor/portfolio';

  static List<GetPage> get pages => [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(name: otp, page: () => const OtpScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: services, page: () => const ServicesScreen()),
    GetPage(name: vendorSearch, page: () => const VendorSearchScreen()),
    GetPage(name: vendorDetail, page: () => const VendorDetailScreen()),
    GetPage(name: selectServices, page: () => const SelectServicesScreen()),
    GetPage(name: selectLocation, page: () => const SelectLocationScreen()),
    GetPage(name: selectVendors, page: () => const SelectVendorsScreen()),
    GetPage(name: bookingSummary, page: () => const BookingSummaryScreen()),
    GetPage(name: bookingConfirm, page: () => const BookingConfirmScreen()),
    GetPage(name: payment, page: () => const PaymentScreen()),
    GetPage(name: paymentSuccess, page: () => const PaymentSuccessScreen()),
    GetPage(name: customerDashboard, page: () => const CustomerDashboardScreen()),
    GetPage(name: myBookings, page: () => const MyBookingsScreen()),
    GetPage(name: wishlist, page: () => const WishlistScreen()),
    GetPage(name: wallet, page: () => const WalletScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    GetPage(name: vendorDashboard, page: () => const VendorDashboardScreen()),
    GetPage(name: vendorBookings, page: () => const VendorBookingsScreen()),
    GetPage(name: vendorServices, page: () => const VendorServicesScreen()),
    GetPage(name: vendorPortfolio, page: () => const VendorPortfolioScreen()),
  ];
}
