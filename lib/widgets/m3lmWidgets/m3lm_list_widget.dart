import 'package:admin_totp_panel/widgets/m3lmWidgets/m3lm_details_dialog.dart';
import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';
import 'edit_m3lm_dialog.dart';

class M3lmListWidget extends StatefulWidget {
  final List<M3lmModel> allM3lms;
  final VoidCallback onRefresh;

  const M3lmListWidget({
    super.key,
    required this.allM3lms,
    required this.onRefresh,
  });

  @override
  State<M3lmListWidget> createState() => _M3lmListWidgetState();
}

class _M3lmListWidgetState extends State<M3lmListWidget> {
  String _selectedFilter = 'All M3LMs';
  final List<String> _filters = [
    'All M3LMs',
    'Available',
    'Busy',
    'Pending Verification',
    'Verified',
    'Blocked',
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _sortAscending = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<M3lmModel> get _filteredM3lms {
    var m3lms = widget.allM3lms.where((m3lm) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        return m3lm.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m3lm.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m3lm.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            m3lm.services.any(
              (service) =>
                  service.toLowerCase().contains(_searchQuery.toLowerCase()),
            );
      }
      return true;
    }).toList();

    // Apply status filter
    switch (_selectedFilter) {
      case 'Available':
        m3lms = m3lms
            .where(
              (m) =>
                  m.isAvailable && m.isActive && !m.isBlocked && m.isVerified,
            )
            .toList();
        break;
      case 'Busy':
        m3lms = m3lms
            .where(
              (m) =>
                  !m.isAvailable && m.isActive && !m.isBlocked && m.isVerified,
            )
            .toList();
        break;
      case 'Pending Verification':
        m3lms = m3lms.where((m) => m.verificationStatus == 'Pending').toList();
        break;
      case 'Verified':
        m3lms = m3lms.where((m) => m.isVerified).toList();
        break;
      case 'Blocked':
        m3lms = m3lms.where((m) => m.isBlocked).toList();
        break;
      default:
        break;
    }

    // Apply sorting
    m3lms.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'rating':
          comparison = a.rating.compareTo(b.rating);
          break;
        case 'totalJobs':
          comparison = a.totalJobs.compareTo(b.totalJobs);
          break;
        case 'earnings':
          comparison = a.totalEarnings.compareTo(b.totalEarnings);
          break;
        case 'joinDate':
          comparison = a.joinDate.compareTo(b.joinDate);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return m3lms;
  }

  void _showM3lmDetails(M3lmModel m3lm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return M3lmDetailsDialog(m3lm: m3lm, onM3lmUpdated: widget.onRefresh);
      },
    );
  }

  void _showEditM3lmDialog(M3lmModel m3lm) {
    showDialog(
      context: context,
      builder: (context) =>
          EditM3lmDialog(m3lm: m3lm, onM3lmUpdated: widget.onRefresh),
    );
  }

  void _toggleM3lmBlock(M3lmModel m3lm) {
    setState(() {
      m3lm.isBlocked = !m3lm.isBlocked;
      if (m3lm.isBlocked) {
        m3lm.isActive = false;
        m3lm.isAvailable = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          m3lm.isBlocked
              ? '${m3lm.name} has been blocked'
              : '${m3lm.name} has been unblocked',
        ),
        backgroundColor: m3lm.isBlocked ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _toggleM3lmVerification(M3lmModel m3lm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 36, 50, 69),
        title: Text(
          'Update Verification Status',
          style: AppFonts.heading3.copyWith(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select verification status for ${m3lm.name}:',
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ...['Pending', 'Verified', 'Rejected'].map((status) {
              return ListTile(
                title: Text(
                  status,
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: status,
                  groupValue: m3lm.verificationStatus,
                  activeColor: const Color(0xFF3B82F6),
                  onChanged: (value) {
                    setState(() {
                      m3lm.verificationStatus = value!;
                      m3lm.isVerified = value == 'Verified';
                    });
                    Navigator.of(context).pop();
                    widget.onRefresh();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${m3lm.name} verification status updated to $value',
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppFonts.button.copyWith(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // Removed any flex properties - let the content determine its size
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search and Filter Section
        _buildSearchAndFilter(),
        const SizedBox(height: 24),

        // M3LMs Table
        _buildM3lmsTable(),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      // Fixed height to prevent layout issues
      height: 120,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Search & Filter M3LMs',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Controls Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                // Stack vertically on smaller screens
                return Column(
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildFilterDropdown()),
                        const SizedBox(width: 16),
                        _buildSortControls(),
                      ],
                    ),
                  ],
                );
              } else {
                // Single row on larger screens
                return Row(
                  children: [
                    Expanded(flex: 3, child: _buildSearchField()),
                    const SizedBox(width: 16),
                    _buildFilterDropdown(),
                    const SizedBox(width: 16),
                    _buildSortControls(),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchController,
        style: AppFonts.bodyMedium.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by name, ID, email, or service...',
          hintStyle: AppFonts.bodyMedium.copyWith(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          filled: true,
          fillColor: const Color.fromARGB(255, 29, 41, 57),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  fontSize: 14,
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
    );
  }

  Widget _buildSortControls() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                items:
                    [
                      {'value': 'name', 'label': 'Name'},
                      {'value': 'rating', 'label': 'Rating'},
                      {'value': 'totalJobs', 'label': 'Jobs'},
                      {'value': 'earnings', 'label': 'Earnings'},
                      {'value': 'joinDate', 'label': 'Join Date'},
                    ].map((sort) {
                      return DropdownMenuItem(
                        value: sort['value'],
                        child: Text(
                          sort['label']!,
                          style: AppFonts.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
                dropdownColor: const Color.fromARGB(255, 29, 41, 57),
                iconEnabledColor: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildM3lmsTable() {
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
        mainAxisSize: MainAxisSize.min, // Important: Don't expand
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(
                  Icons.engineering,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'M3LMs List',
                  style: AppFonts.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${_filteredM3lms.length} M3LMs',
                    style: AppFonts.bodyMedium.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Content - Using ListView without Expanded
          ListView.builder(
            shrinkWrap: true, // Important: Don't take all available space
            physics:
                const NeverScrollableScrollPhysics(), // Parent handles scrolling
            itemCount: _filteredM3lms.length,
            itemBuilder: (context, index) {
              final m3lm = _filteredM3lms[index];
              return _buildM3lmRow(m3lm, index);
            },
          ),

          // Bottom padding
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildM3lmRow(M3lmModel m3lm, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => _showM3lmDetails(m3lm),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Avatar with status indicators
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: m3lm.statusColor,
                  child: Text(
                    m3lm.avatar,
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Verification badge
                if (m3lm.isVerified)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 29, 41, 57),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        color: Color(0xFF3B82F6),
                        size: 12,
                      ),
                    ),
                  ),
                // Online indicator
                if (m3lm.isAvailable && m3lm.isActive && !m3lm.isBlocked)
                  Positioned(
                    right: -2,
                    bottom: -2,
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

            // Basic Info - Using Flexible instead of Expanded
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        m3lm.name,
                        style: AppFonts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getExperienceLevelColor(
                            m3lm.experienceLevel,
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getExperienceLevelColor(
                              m3lm.experienceLevel,
                            ).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          m3lm.experienceLevel,
                          style: AppFonts.bodySmall.copyWith(
                            color: _getExperienceLevelColor(
                              m3lm.experienceLevel,
                            ),
                            fontWeight: FontWeight.w600,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m3lm.id,
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color(0xFF3B82F6),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    m3lm.email,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Services & Location
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m3lm.primaryService,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (m3lm.services.length > 1)
                    Text(
                      '+${m3lm.services.length - 1} more',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    m3lm.location,
                    style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Performance & Rating
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${m3lm.rating}',
                        style: AppFonts.bodySmall.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${m3lm.reviewsCount})',
                        style: AppFonts.bodySmall.copyWith(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${m3lm.totalJobs} jobs • ${m3lm.completionRate.toStringAsFixed(0)}%',
                    style: AppFonts.bodySmall.copyWith(color: Colors.white),
                  ),
                  Text(
                    '\$${m3lm.totalEarnings.toStringAsFixed(0)} total',
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Status
            _buildStatusChip(m3lm),
            const SizedBox(width: 16),

            // Last Active
            SizedBox(
              width: 80,
              child: Text(
                _formatLastActive(m3lm.lastActive),
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
                    'Edit Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'verification',
                  child: Text(
                    'Update Verification',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: m3lm.isBlocked ? 'unblock' : 'block',
                  child: Text(
                    m3lm.isBlocked ? 'Unblock M3LM' : 'Block M3LM',
                    style: TextStyle(
                      color: m3lm.isBlocked
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _showM3lmDetails(m3lm);
                    break;
                  case 'edit':
                    _showEditM3lmDialog(m3lm);
                    break;
                  case 'verification':
                    _toggleM3lmVerification(m3lm);
                    break;
                  case 'block':
                  case 'unblock':
                    _toggleM3lmBlock(m3lm);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(M3lmModel m3lm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: m3lm.statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: m3lm.statusColor.withOpacity(0.3)),
      ),
      child: Text(
        m3lm.statusText,
        style: AppFonts.bodySmall.copyWith(
          color: m3lm.statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getExperienceLevelColor(String level) {
    switch (level) {
      case 'Expert':
        return const Color(0xFF10B981);
      case 'Intermediate':
        return const Color(0xFF3B82F6);
      case 'Beginner':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
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
