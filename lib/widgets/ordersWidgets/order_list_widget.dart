import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'order_model.dart';

class OrderListWidget extends StatefulWidget {
  final List<OrderModel> allOrders;
  final VoidCallback onRefresh;

  const OrderListWidget({
    super.key,
    required this.allOrders,
    required this.onRefresh,
  });

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  String _selectedFilter = 'All Orders';
  final List<String> _filters = [
    'All Orders',
    'Pending',
    'Assigned',
    'In Progress',
    'Completed',
    'Cancelled',
    'Urgent Only',
    'Unpaid',
  ];
  final TextEditingController _searchController = TextEditingControll
  String _searchQuery = '';
  String _sortBy = 'createdAt';
  bool _sortAscending = false; // Most recent first by default

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<OrderModel> get _filteredOrders {
    var orders = widget.allOrders.where((order) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        return order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            order.customerName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            order.customerEmail.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            (order.m3lmName?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false) ||
            order.serviceDisplayName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            order.serviceDescription.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }
      return true;
    }).toList();

    // Apply status filter
    switch (_selectedFilter) {
      case 'Pending':
        orders = orders.where((o) => o.status == OrderStatus.pending).toList();
        break;
      case 'Assigned':
        orders = orders.where((o) => o.status == OrderStatus.assigned).toList();
        break;
      case 'In Progress':
        orders = orders
            .where((o) => o.status == OrderStatus.inProgress)
            .toList();
        break;
      case 'Completed':
        orders = orders
            .where((o) => o.status == OrderStatus.completed)
            .toList();
        break;
      case 'Cancelled':
        orders = orders
            .where((o) => o.status == OrderStatus.cancelled)
            .toList();
        break;
      case 'Urgent Only':
        orders = orders
            .where((o) => o.isUrgent || o.priority == 'urgent')
            .toList();
        break;
      case 'Unpaid':
        orders = orders.where((o) => !o.isPaid).toList();
        break;
      default:
        break;
    }

    // Apply sorting
    orders.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'createdAt':
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case 'totalAmount':
          comparison = a.totalAmount.compareTo(b.totalAmount);
          break;
        case 'customerName':
          comparison = a.customerName.compareTo(b.customerName);
          break;
        case 'status':
          comparison = a.status.index.compareTo(b.status.index);
          break;
        case 'priority':
          comparison = _getPriorityValue(
            a.priority,
          ).compareTo(_getPriorityValue(b.priority));
          break;
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return orders;
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'urgent':
        return 4;
      case 'high':
        return 3;
      case 'normal':
        return 2;
      case 'low':
        return 1;
      default:
        return 2;
    }
  }

  void _showOrderDetails(OrderModel order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDetailsDialog(
          order: order,
          onOrderUpdated: widget.onRefresh,
        );
      },
    );
  }

  void _updateOrderStatus(OrderModel order, OrderStatus newStatus) {
    setState(() {
      order.status = newStatus;
      if (newStatus == OrderStatus.inProgress && order.startedAt == null) {
        order.startedAt = DateTime.now();
      } else if (newStatus == OrderStatus.completed &&
          order.completedAt == null) {
        order.completedAt = DateTime.now();
      } else if (newStatus == OrderStatus.cancelled &&
          order.cancelledAt == null) {
        order.cancelledAt = DateTime.now();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order ${order.id} status updated to ${order.statusDisplayName}',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _trackOrder(OrderModel order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening tracking for order ${order.id}...'),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search and Filter Section
        _buildSearchAndFilter(),
        const SizedBox(height: 24),

        // Orders Table
        _buildOrdersTable(),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
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
            'Search & Filter Orders',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          // Controls Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
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
          hintText: 'Search by order ID, customer, M3LM, or service...',
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
                      {'value': 'createdAt', 'label': 'Date'},
                      {'value': 'totalAmount', 'label': 'Amount'},
                      {'value': 'customerName', 'label': 'Customer'},
                      {'value': 'status', 'label': 'Status'},
                      {'value': 'priority', 'label': 'Priority'},
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

  Widget _buildOrdersTable() {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Orders List',
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
                    color: const Color(0xFF3B82F6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${_filteredOrders.length} Orders',
                    style: AppFonts.bodyMedium.copyWith(
                      color: const Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Content
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredOrders.length,
            itemBuilder: (context, index) {
              final order = _filteredOrders[index];
              return _buildOrderRow(order, index);
            },
          ),

          // Bottom padding
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOrderRow(OrderModel order, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Service Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getServiceColor(order.serviceType).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                order.serviceIcon,
                color: _getServiceColor(order.serviceType),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),

            // Order Info
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.id,
                        style: AppFonts.bodyMedium.copyWith(
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (order.isUrgent || order.priority == 'urgent')
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'URGENT',
                            style: AppFonts.bodySmall.copyWith(
                              color: const Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.serviceDisplayName,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    order.serviceDescription,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Customer Info
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.customerPhone,
                    style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                  ),
                  Text(
                    order.location,
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.grey[400],
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // M3LM Info
            Flexible(
              flex: 2,
              child: order.m3lmName != null
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color(0xFF10B981),
                          child: Text(
                            order.m3lmAvatar ?? '?',
                            style: AppFonts.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.m3lmName!,
                                style: AppFonts.bodySmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (order.m3lmPhone != null)
                                Text(
                                  order.m3lmPhone!,
                                  style: AppFonts.bodySmall.copyWith(
                                    color: Colors.grey[400],
                                    fontSize: 10,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Unassigned',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
            ),

            // Amount & Payment
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: order.isPaid
                          ? const Color(0xFF10B981).withOpacity(0.2)
                          : const Color(0xFFF59E0B).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: order.isPaid
                            ? const Color(0xFF10B981).withOpacity(0.3)
                            : const Color(0xFFF59E0B).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      order.isPaid ? 'Paid' : 'Unpaid',
                      style: AppFonts.bodySmall.copyWith(
                        color: order.isPaid
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Status
            _buildStatusChip(order),
            const SizedBox(width: 16),

            // Time
            SizedBox(
              width: 80,
              child: Text(
                _formatTime(order.createdAt),
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
                if (order.canBeTracked)
                  const PopupMenuItem(
                    value: 'track',
                    child: Text(
                      'Track Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (order.status == OrderStatus.pending)
                  const PopupMenuItem(
                    value: 'assign',
                    child: Text(
                      'Mark as Assigned',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (order.status == OrderStatus.assigned)
                  const PopupMenuItem(
                    value: 'start',
                    child: Text(
                      'Start Service',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (order.status == OrderStatus.inProgress)
                  const PopupMenuItem(
                    value: 'complete',
                    child: Text(
                      'Complete Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                if (order.isActive)
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text(
                      'Cancel Order',
                      style: TextStyle(color: Color(0xFFEF4444)),
                    ),
                  ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _showOrderDetails(order);
                    break;
                  case 'track':
                    _trackOrder(order);
                    break;
                  case 'assign':
                    _updateOrderStatus(order, OrderStatus.assigned);
                    break;
                  case 'start':
                    _updateOrderStatus(order, OrderStatus.inProgress);
                    break;
                  case 'complete':
                    _updateOrderStatus(order, OrderStatus.completed);
                    break;
                  case 'cancel':
                    _updateOrderStatus(order, OrderStatus.cancelled);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderModel order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: order.statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: order.statusColor.withOpacity(0.3)),
      ),
      child: Text(
        order.statusDisplayName,
        style: AppFonts.bodySmall.copyWith(
          color: order.statusColor,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getServiceColor(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.plumbing:
        return const Color(0xFF3B82F6);
      case ServiceType.electrical:
        return const Color(0xFFF59E0B);
      case ServiceType.cleaning:
        return const Color(0xFF10B981);
      case ServiceType.hvac:
        return const Color(0xFF8B5CF6);
      case ServiceType.gardening:
        return const Color(0xFFEF4444);
      case ServiceType.painting:
        return const Color(0xFF06B6D4);
      case ServiceType.carpentry:
        return const Color(0xFF84CC16);
      case ServiceType.appliance:
        return const Color(0xFFEC4899);
      case ServiceType.pest:
        return const Color(0xFFF97316);
      case ServiceType.locksmith:
        return const Color(0xFF6366F1);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
