import 'package:flutter/material.dart';
import '../widgets/generalWidgets/font.dart';
import '../widgets/generalWidgets/nav_bar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String _selectedFilter = 'All Users';
  final List<String> _filters = ['All Users', 'Active Users', 'Inactive Users'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;
  int _currentIndex = 1; // Since this is the Users tab

  // Mock user data
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
    ),
  ];

  List<UserModel> get _filteredUsers {
    var users = _allUsers.where((user) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      return true;
    }).toList();

    // Apply status filter
    switch (_selectedFilter) {
      case 'Active Users':
        return users.where((user) => user.isActive && !user.isBlocked).toList();
      case 'Inactive Users':
        return users.where((user) => !user.isActive || user.isBlocked).toList();
      default:
        return users;
    }
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        break;
      case 2:
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

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailsDialog(user: user, onUserUpdated: _refreshUsers);
      },
    );
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

                // Statistics Cards
                _buildStatsCards(),
                const SizedBox(height: 32),

                // Search and Filter Section
                _buildSearchAndFilter(),
                const SizedBox(height: 24),

                // Users Table
                _buildUsersTable(),
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

  Widget _buildStatsCards() {
    final totalUsers = _allUsers.length;
    final activeUsers = _allUsers
        .where((u) => u.isActive && !u.isBlocked)
        .length;
    final blockedUsers = _allUsers.where((u) => u.isBlocked).length;
    final totalOrders = _allUsers.fold(
      0,
      (sum, user) => sum + user.totalOrders,
    );

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Users',
            totalUsers.toString(),
            '+12%',
            true,
            Icons.people_outline,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            'Active Users',
            activeUsers.toString(),
            '+8%',
            true,
            Icons.person_outline,
            const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            'Blocked Users',
            blockedUsers.toString(),
            '-2%',
            false,
            Icons.block_outlined,
            const Color(0xFFEF4444),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            totalOrders.toString(),
            '+23%',
            true,
            Icons.shopping_cart_outlined,
            const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String percentage,
    bool isPositive,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 36, 50, 69),
            Color.fromARGB(255, 42, 56, 75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF10B981).withOpacity(0.2)
                      : const Color(0xFFEF4444).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      percentage,
                      style: AppFonts.bodySmall.copyWith(
                        color: isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppFonts.heading1.copyWith(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppFonts.bodyMedium.copyWith(
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 36, 50, 69),
            Color.fromARGB(255, 42, 56, 75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search & Filter',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Search Bar
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by name, ID, or email...',
                    hintStyle: AppFonts.bodyMedium.copyWith(
                      color: Colors.grey[400],
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 29, 41, 57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Filter Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 29, 41, 57),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    items: _filters.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(
                          filter,
                          style: AppFonts.bodyMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                    dropdownColor: const Color.fromARGB(255, 29, 41, 57),
                    iconEnabledColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 36, 50, 69),
            Color.fromARGB(255, 42, 56, 75),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Text(
                  'Users List',
                  style: AppFonts.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_filteredUsers.length} users',
                  style: AppFonts.bodyMedium.copyWith(color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          // Table Content
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredUsers.length,
            itemBuilder: (context, index) {
              final user = _filteredUsers[index];
              return _buildUserRow(user, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserModel user, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => _showUserDetails(user),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: user.isBlocked
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
                  child: Text(
                    user.avatar,
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (user.isActive && !user.isBlocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 29, 41, 57),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.id,
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color(0xFF3B82F6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    user.email,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Contact & Location
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.phone,
                    style: AppFonts.bodySmall.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.location,
                    style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),

            // Orders & Rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.totalOrders} orders',
                    style: AppFonts.bodySmall.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${user.rating}',
                        style: AppFonts.bodySmall.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status
            _buildStatusChip(user),
            const SizedBox(width: 16),

            // Last Active
            Expanded(
              child: Text(
                _formatLastActive(user.lastActive),
                style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 16),
              color: const Color.fromARGB(255, 36, 50, 69),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Text(
                    'Edit User',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: user.isBlocked ? 'unblock' : 'block',
                  child: Text(
                    user.isBlocked ? 'Unblock User' : 'Block User',
                    style: TextStyle(
                      color: user.isBlocked
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _showUserDetails(user);
                    break;
                  case 'edit':
                    _showEditUserDialog(user);
                    break;
                  case 'block':
                  case 'unblock':
                    _toggleUserBlock(user);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(UserModel user) {
    Color color;
    String text;

    if (user.isBlocked) {
      color = const Color(0xFFEF4444);
      text = 'Blocked';
    } else if (user.isActive) {
      color = const Color(0xFF10B981);
      text = 'Active';
    } else {
      color = const Color(0xFF6B7280);
      text = 'Inactive';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppFonts.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatLastActive(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showEditUserDialog(UserModel user) {
    // Implementation for edit user dialog
    showDialog(
      context: context,
      builder: (context) =>
          EditUserDialog(user: user, onUserUpdated: _refreshUsers),
    );
  }

  void _toggleUserBlock(UserModel user) {
    setState(() {
      user.isBlocked = !user.isBlocked;
      if (user.isBlocked) {
        user.isActive = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user.isBlocked
              ? '${user.name} has been blocked'
              : '${user.name} has been unblocked',
        ),
        backgroundColor: user.isBlocked ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// User Model
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
  });
}

// User Details Dialog
class UserDetailsDialog extends StatelessWidget {
  final UserModel user;
  final VoidCallback onUserUpdated;

  const UserDetailsDialog({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 36, 50, 69),
              Color.fromARGB(255, 42, 56, 75),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: user.isBlocked
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
                  child: Text(
                    user.avatar,
                    style: AppFonts.heading3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'User ID: ${user.id}',
                        style: AppFonts.bodyMedium.copyWith(
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User Details and Orders
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Details
                  Expanded(child: _buildUserDetailsSection()),
                  const SizedBox(width: 24),
                  // Orders History
                  Expanded(child: _buildOrdersSection()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Details',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Email', user.email),
          _buildDetailRow('Phone', user.phone),
          _buildDetailRow('Location', user.location),
          _buildDetailRow('Total Orders', '${user.totalOrders}'),
          _buildDetailRow('Active Orders', '${user.activeOrders}'),
          _buildDetailRow('Rating', '${user.rating}/5.0'),
          _buildDetailRow('Join Date', _formatDate(user.joinDate)),
          _buildDetailRow('Last Active', _formatDate(user.lastActive)),
          _buildDetailRow(
            'Status',
            user.isBlocked
                ? 'Blocked'
                : (user.isActive ? 'Active' : 'Inactive'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    // Mock orders data
    final orders = [
      {
        'id': 'ORD001',
        'service': 'Plumbing',
        'status': 'Completed',
        'amount': '\$150',
        'date': '2024-01-15',
      },
      {
        'id': 'ORD002',
        'service': 'Electrical',
        'status': 'In Progress',
        'amount': '\$275',
        'date': '2024-01-20',
      },
      {
        'id': 'ORD003',
        'service': 'Cleaning',
        'status': 'Completed',
        'amount': '\$85',
        'date': '2024-01-22',
      },
      {
        'id': 'ORD004',
        'service': 'HVAC',
        'status': 'Pending',
        'amount': '\$420',
        'date': '2024-01-25',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Orders',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 41, 57),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            order['id']!,
                            style: AppFonts.bodyMedium.copyWith(
                              color: const Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            order['amount']!,
                            style: AppFonts.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['service']!,
                        style: AppFonts.bodySmall.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildOrderStatusChip(order['status']!),
                          Text(
                            order['date']!,
                            style: AppFonts.bodySmall.copyWith(
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = const Color(0xFF10B981);
        break;
      case 'In Progress':
        color = const Color(0xFF3B82F6);
        break;
      case 'Pending':
        color = const Color(0xFFF59E0B);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: AppFonts.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Edit User Dialog
class EditUserDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onUserUpdated;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
    _locationController = TextEditingController(text: widget.user.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 36, 50, 69),
              Color.fromARGB(255, 42, 56, 75),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Edit User',
                  style: AppFonts.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form Fields
            _buildTextField('Name', _nameController, Icons.person),
            const SizedBox(height: 16),
            _buildTextField('Email', _emailController, Icons.email),
            const SizedBox(height: 16),
            _buildTextField('Phone', _phoneController, Icons.phone),
            const SizedBox(height: 16),
            _buildTextField('Location', _locationController, Icons.location_on),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Cancel', style: AppFonts.button),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save Changes', style: AppFonts.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: AppFonts.bodyMedium.copyWith(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.bodyMedium.copyWith(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color.fromARGB(255, 29, 41, 57),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
      ),
    );
  }

  void _saveChanges() {
    // Update user data
    widget.user.name = _nameController.text;
    widget.user.email = _emailController.text;
    widget.user.phone = _phoneController.text;
    widget.user.location = _locationController.text;

    // Call the callback to refresh the parent widget
    widget.onUserUpdated();

    // Close dialog
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.user.name} updated successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
