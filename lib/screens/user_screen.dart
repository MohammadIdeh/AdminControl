import 'package:admin_totp_panel/widgets/userWidgets/UserModel.dart';
import 'package:admin_totp_panel/widgets/userWidgets/user_cards.dart';
import 'package:admin_totp_panel/widgets/userWidgets/user_list.dart';
import 'package:flutter/material.dart';
import '../widgets/generalWidgets/font.dart';
import '../widgets/generalWidgets/nav_bar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;
  int _currentIndex = 1; // Since this is the Users tab

  // Mock user data with wallet balances
  final List<UserModel> _allUsers = [
    UserModel(
      id: 'USR001',
      name: 'John Smith',
      email: 'john.smith@email.com',
      phone: '+1-555-0123',
      location: 'New York, NY',
      isActive: true,
      isBlocked: false,
      joinDate: DateTime(2023, 1, 15),
      lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
      totalOrders: 24,
      activeOrders: 2,
      avatar: 'JS',
      rating: 4.8,
      walletBalance: 125.50,
    ),
    UserModel(
      id: 'USR002',
      name: 'Sarah Wilson',
      email: 'sarah.wilson@email.com',
      phone: '+1-555-0124',
      location: 'Los Angeles, CA',
      isActive: false,
      isBlocked: false,
      joinDate: DateTime(2023, 3, 22),
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      totalOrders: 18,
      activeOrders: 0,
      avatar: 'SW',
      rating: 4.6,
      walletBalance: 89.25,
    ),
    UserModel(
      id: 'USR003',
      name: 'Robert Davis',
      email: 'robert.davis@email.com',
      phone: '+1-555-0125',
      location: 'Chicago, IL',
      isActive: true,
      isBlocked: false,
      joinDate: DateTime(2023, 2, 8),
      lastActive: DateTime.now().subtract(const Duration(minutes: 1)),
      totalOrders: 31,
      activeOrders: 1,
      avatar: 'RD',
      rating: 4.9,
      walletBalance: 234.75,
    ),
    UserModel(
      id: 'USR004',
      name: 'Lisa Anderson',
      email: 'lisa.anderson@email.com',
      phone: '+1-555-0126',
      location: 'Miami, FL',
      isActive: false,
      isBlocked: true,
      joinDate: DateTime(2023, 4, 12),
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
      totalOrders: 7,
      activeOrders: 0,
      avatar: 'LA',
      rating: 3.2,
      walletBalance: 0.00,
    ),
    UserModel(
      id: 'USR005',
      name: 'Mark Thompson',
      email: 'mark.thompson@email.com',
      phone: '+1-555-0127',
      location: 'Seattle, WA',
      isActive: true,
      isBlocked: false,
      joinDate: DateTime(2023, 5, 3),
      lastActive: DateTime.now().subtract(const Duration(minutes: 12)),
      totalOrders: 15,
      activeOrders: 3,
      avatar: 'MT',
      rating: 4.7,
      walletBalance: 67.80,
    ),
  ];

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        break; // Current screen
      case 2:
        Navigator.pushNamed(context, '/m3lms');
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
    }
  }

  Future<void> _refreshUsers() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Users refreshed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 41, 57),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: myNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTap,
          profilePictureUrl: null,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshUsers,
        color: const Color(0xFF3B82F6),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),
                const SizedBox(height: 32),

                // Statistics Cards Widget
                UserStatsCardsWidget(allUsers: _allUsers),
                const SizedBox(height: 32),

                // User List Widget
                UserListWidget(allUsers: _allUsers, onRefresh: _refreshUsers),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: AppFonts.heading1.copyWith(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage platform users and their activities',
              style: AppFonts.bodyLarge.copyWith(color: Colors.grey[400]),
            ),
          ],
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _isLoading ? null : _refreshUsers,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: Colors.white),
            label: Text(
              _isLoading ? 'Refreshing...' : 'Refresh Data',
              style: AppFonts.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
