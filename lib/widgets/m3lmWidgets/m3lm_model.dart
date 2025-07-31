import 'dart:ui';

class M3lmModel {
  final String id;
  String name;
  String email;
  String phone;
  String location;
  bool isActive;
  bool isBlocked;
  bool isVerified;
  bool isAvailable;
  final DateTime joinDate;
  DateTime lastActive;
  int totalJobs;
  int activeJobs;
  int completedJobs;
  final String avatar;
  double rating;
  double walletBalance;
  double monthlyEarnings;
  double totalEarnings;
  List<String> services;
  String experienceLevel; // 'Beginner', 'Intermediate', 'Expert'
  String verificationStatus; // 'Pending', 'Verified', 'Rejected'
  List<String> serviceAreas;
  double completionRate;
  int reviewsCount;
  List<String> certifications;
  String bankAccount;
  String taxId;
  DateTime? lastPayment;

  M3lmModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.isActive,
    required this.isBlocked,
    required this.isVerified,
    required this.isAvailable,
    required this.joinDate,
    required this.lastActive,
    required this.totalJobs,
    required this.activeJobs,
    required this.completedJobs,
    required this.avatar,
    required this.rating,
    required this.services,
    required this.experienceLevel,
    required this.verificationStatus,
    required this.serviceAreas,
    this.walletBalance = 0.0,
    this.monthlyEarnings = 0.0,
    this.totalEarnings = 0.0,
    this.completionRate = 0.0,
    this.reviewsCount = 0,
    this.certifications = const [],
    this.bankAccount = '',
    this.taxId = '',
    this.lastPayment,
  });

  String get statusText {
    if (isBlocked) return 'Blocked';
    if (!isVerified) return 'Pending Verification';
    if (!isActive) return 'Inactive';
    if (isAvailable) return 'Available';
    return 'Busy';
  }

  Color get statusColor {
    if (isBlocked) return const Color(0xFFEF4444);
    if (!isVerified) return const Color(0xFFF59E0B);
    if (!isActive) return const Color(0xFF6B7280);
    if (isAvailable) return const Color(0xFF10B981);
    return const Color(0xFF3B82F6);
  }

  String get primaryService {
    return services.isNotEmpty ? services.first : 'General';
  }

  double get averageJobValue {
    return totalJobs > 0 ? totalEarnings / totalJobs : 0.0;
  }
}
