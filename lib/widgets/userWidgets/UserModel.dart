class UserModel {
  final String id;
  String name;
  String email;
  String phone;
  String location;
  bool isActive;
  bool isBlocked;
  final DateTime joinDate;
  DateTime lastActive;
  int totalOrders;
  int activeOrders;
  final String avatar;
  double rating;
  double walletBalance; // New field for wallet balance

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.isActive,
    required this.isBlocked,
    required this.joinDate,
    required this.lastActive,
    required this.totalOrders,
    required this.activeOrders,
    required this.avatar,
    required this.rating,
    this.walletBalance = 0.0, // Default wallet balance
  });
}
