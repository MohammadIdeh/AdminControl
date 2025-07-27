import 'package:admin_totp_panel/widgets/generalWidgets/font.dart';
import 'package:admin_totp_panel/widgets/userWidgets/UserModel.dart';
import 'package:admin_totp_panel/widgets/userWidgets/edit_user_dialog.dart';
import 'package:admin_totp_panel/widgets/userWidgets/user_details.dart';
import 'package:flutter/material.dart';

class UserListWidget extends StatefulWidget {
  final List<UserModel> allUsers;
  final VoidCallback onRefresh;

  const UserListWidget({
    super.key,
    required this.allUsers,
    required this.onRefresh,
  });

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  String _selectedFilter = 'All Users';
  final List<String> _filters = ['All Users', 'Active Users', 'Inactive Users'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<UserModel> get _filteredUsers {
    var users = widget.allUsers.where((user) {
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

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserDetailsDialog(user: user, onUserUpdated: widget.onRefresh);
      },
    );
  }

  void _showEditUserDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) =>
          EditUserDialog(user: user, onUserUpdated: widget.onRefresh),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        _buildSearchAndFilter(),
        const SizedBox(height: 24),

        // Users Table
        _buildUsersTable(),
      ],
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
}
