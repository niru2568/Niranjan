import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // ⚠️ Change this to your Laravel server URL
  static const String baseUrl = 'https://your-laravel-api.com/api/v1';

  final _storage = const FlutterSecureStorage();
  late Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          _storage.delete(key: 'auth_token');
          // Navigate to login
        }
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Something went wrong',
        );
        return handler.next(e);
      },
    ));
  }

  // ── AUTH ────────────────────────────────────
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final res = await _dio.post('/auth/send-otp', data: {'phone': phone});
    return res.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final res = await _dio.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp});
    return res.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return res.data;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await _dio.post('/auth/register', data: data);
    return res.data;
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
    await _storage.delete(key: 'auth_token');
  }

  // ── PUBLIC ──────────────────────────────────
  Future<Map<String, dynamic>> getHomepage() async {
    final res = await _dio.get('/homepage');
    return res.data;
  }

  Future<List<dynamic>> getCategories() async {
    final res = await _dio.get('/categories');
    return res.data['data'];
  }

  Future<List<dynamic>> getCities() async {
    final res = await _dio.get('/cities');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> searchVendors({
    String? query,
    int? categoryId,
    String? city,
    double? lat,
    double? lng,
    int? radius,
    double? minRating,
    double? maxPrice,
    String? sort,
    int page = 1,
  }) async {
    final res = await _dio.get('/vendors', queryParameters: {
      if (query != null) 'q': query,
      if (categoryId != null) 'category_id': categoryId,
      if (city != null) 'city': city,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (radius != null) 'radius': radius,
      if (minRating != null) 'min_rating': minRating,
      if (maxPrice != null) 'max_price': maxPrice,
      if (sort != null) 'sort': sort,
      'page': page,
    });
    return res.data;
  }

  Future<List<dynamic>> getNearbyVendors({
    required double lat,
    required double lng,
    required List<int> categoryIds,
    int radius = 100,
  }) async {
    final res = await _dio.get('/vendors/nearby', queryParameters: {
      'lat': lat,
      'lng': lng,
      'categories': categoryIds.join(','),
      'radius': radius,
    });
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getVendorDetail(String slug) async {
    final res = await _dio.get('/vendors/$slug');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getVendorAvailability(int serviceId, String date) async {
    final res = await _dio.get('/services/$serviceId/availability', queryParameters: {'date': date});
    return res.data;
  }

  Future<Map<String, dynamic>> validateCoupon(String code, double amount) async {
    final res = await _dio.post('/coupons/validate', data: {'code': code, 'amount': amount});
    return res.data;
  }

  Future<List<dynamic>> getBlogs() async {
    final res = await _dio.get('/blogs');
    return res.data['data'];
  }

  // ── BOOKINGS ─────────────────────────────────
  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final res = await _dio.post('/customer/bookings', data: data);
    return res.data;
  }

  Future<List<dynamic>> getMyBookings() async {
    final res = await _dio.get('/customer/bookings');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getBookingDetail(int id) async {
    final res = await _dio.get('/customer/bookings/$id');
    return res.data['data'];
  }

  Future<void> cancelBooking(int id, String reason) async {
    await _dio.post('/customer/bookings/$id/cancel', data: {'reason': reason});
  }

  // ── PAYMENT ──────────────────────────────────
  Future<Map<String, dynamic>> initiatePayment(int bookingId, String gateway) async {
    final res = await _dio.post('/customer/payments/initiate', data: {
      'booking_id': bookingId,
      'gateway': gateway,
    });
    return res.data;
  }

  Future<Map<String, dynamic>> verifyPayment(Map<String, dynamic> data) async {
    final res = await _dio.post('/customer/payments/verify', data: data);
    return res.data;
  }

  // ── WISHLIST ─────────────────────────────────
  Future<List<dynamic>> getWishlist() async {
    final res = await _dio.get('/customer/wishlist');
    return res.data['data'];
  }

  Future<void> toggleWishlist(int vendorId) async {
    await _dio.post('/customer/wishlist/$vendorId');
  }

  // ── WALLET ───────────────────────────────────
  Future<Map<String, dynamic>> getWalletBalance() async {
    final res = await _dio.get('/customer/wallet');
    return res.data;
  }

  Future<List<dynamic>> getWalletTransactions() async {
    final res = await _dio.get('/customer/wallet/transactions');
    return res.data['data'];
  }

  // ── PROFILE ──────────────────────────────────
  Future<Map<String, dynamic>> getProfile() async {
    final res = await _dio.get('/customer/profile');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final res = await _dio.put('/customer/profile', data: data);
    return res.data;
  }

  // ── NOTIFICATIONS ────────────────────────────
  Future<List<dynamic>> getNotifications() async {
    final res = await _dio.get('/customer/notifications');
    return res.data['data'];
  }

  // ── VENDOR DASHBOARD ─────────────────────────
  Future<Map<String, dynamic>> getVendorDashboard() async {
    final res = await _dio.get('/vendor/dashboard');
    return res.data['data'];
  }

  Future<List<dynamic>> getVendorBookings() async {
    final res = await _dio.get('/vendor/bookings');
    return res.data['data'];
  }

  Future<void> confirmVendorBooking(int bookingId) async {
    await _dio.post('/vendor/bookings/$bookingId/confirm');
  }

  Future<List<dynamic>> getVendorServices() async {
    final res = await _dio.get('/vendor/services');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> addVendorService(Map<String, dynamic> data) async {
    final res = await _dio.post('/vendor/services', data: data);
    return res.data;
  }
}
