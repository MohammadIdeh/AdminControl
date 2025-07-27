import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class ActiveOrdersTableWidget extends StatefulWidget {
  const ActiveOrdersTableWidget({super.key});

  @override
  State<ActiveOrdersTableWidget> createState() =>
      _ActiveOrdersTableWidgetState();
}

class _ActiveOrdersTableWidgetState extends State<ActiveOrdersTableWidget> {
  String _sortBy = 'time';
  bool _sortAscending = false;
  String _filterStatus = 'All';

  final List<String> _statusFilters = [
    'All',
    'In Progress',
    'Assigned',
    'En Route',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 36, 50, 69),
            Color.fromARGB(255, 42, 56, 75),
          ], // Original relaxing colors
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Orders',
                      style: AppFonts.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real-time order tracking',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                // Filter and Sort Controls
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(
                          255,
                          29,
                          41,
                          57,
                        ), // Original background
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterStatus,
                          items: _statusFilters.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                style: AppFonts.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _filterStatus = value!;
                            });
                          },
                          dropdownColor: const Color(0xFF0F172A),
                          iconEnabledColor: Colors.white,
                          style: AppFonts.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                      icon: Icon(
                        _sortAscending ? Icons.sort : Icons.sort,
                        color: Colors.white,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          29,
                          41,
                          57,
                        ), // Original background
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  29,
                  41,
                  57,
                ).withOpacity(0.5), // Original color
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Order ID',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'M3LM',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Service',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Status',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Value',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // For actions
                ],
              ),
            ),

            // Table Body
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    29,
                    41,
                    57,
                  ).withOpacity(0.3), // Original color
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: ListView.builder(
                  itemCount: _getFilteredOrders().length,
                  itemBuilder: (context, index) {
                    final order = _getFilteredOrders()[index];
                    return _buildOrderRow(order, index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    final mockOrders = [
      {
        'id': '#ORD-2024-001',
        'customer': 'John Smith',
        'm3lm': 'Mike Johnson',
        'service': 'Plumbing',
        'status': 'In Progress',
        'value': '\$150',
        'time': '2 min ago',
        'avatar': 'JS',
        'm3lmAvatar': 'MJ',
      },
      {
        'id': '#ORD-2024-002',
        'customer': 'Sarah Wilson',
        'm3lm': 'David Brown',
        'service': 'Electrical',
        'status': 'En Route',
        'value': '\$275',
        'time': '5 min ago',
        'avatar': 'SW',
        'm3lmAvatar': 'DB',
      },
      {
        'id': '#ORD-2024-003',
        'customer': 'Robert Davis',
        'm3lm': 'Emily Garcia',
        'service': 'Cleaning',
        'status': 'Assigned',
        'value': '\$85',
        'time': '8 min ago',
        'avatar': 'RD',
        'm3lmAvatar': 'EG',
      },
      {
        'id': '#ORD-2024-004',
        'customer': 'Lisa Anderson',
        'm3lm': 'Tom Wilson',
        'service': 'HVAC',
        'status': 'In Progress',
        'value': '\$420',
        'time': '12 min ago',
        'avatar': 'LA',
        'm3lmAvatar': 'TW',
      },
      {
        'id': '#ORD-2024-005',
        'customer': 'Mark Thompson',
        'm3lm': 'Anna Martinez',
        'service': 'Gardening',
        'status': 'Completed',
        'value': '\$95',
        'time': '15 min ago',
        'avatar': 'MT',
        'm3lmAvatar': 'AM',
      },
    ];

    if (_filterStatus == 'All') {
      return mockOrders;
    } else {
      return mockOrders
          .where((order) => order['status'] == _filterStatus)
          .toList();
    }
  }

  Widget _buildOrderRow(Map<String, dynamic> order, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Order ID
          Expanded(
            flex: 2,
            child: Text(
              order['id'],
              style: AppFonts.bodySmall.copyWith(
                color: const Color(0xFF3B82F6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Customer
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF3B82F6),
                  child: Text(
                    order['avatar'],
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  order['customer'],
                  style: AppFonts.bodySmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          // M3LM
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF10B981),
                  child: Text(
                    order['m3lmAvatar'],
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  order['m3lm'],
                  style: AppFonts.bodySmall.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

          // Service
          Expanded(
            flex: 2,
            child: Text(
              order['service'],
              style: AppFonts.bodySmall.copyWith(color: Colors.grey[300]),
            ),
          ),

          // Status - FIXED: Now properly aligned with header
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _buildStatusChip(order['status']),
                const SizedBox(width: 12), // Space between status and value
              ],
            ),
          ),

          // Value
          Expanded(
            flex: 1,
            child: Text(
              order['value'],
              style: AppFonts.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Actions
          SizedBox(
            width: 40,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[400], size: 16),
              color: const Color.fromARGB(
                255,
                36,
                50,
                69,
              ), // Original card color
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'track',
                  child: Text(
                    'Track Order',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const PopupMenuItem(
                  value: 'message',
                  child: Text('Message', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'In Progress':
        color = const Color(0xFF3B82F6);
        break;
      case 'En Route':
        color = const Color(0xFFF59E0B);
        break;
      case 'Assigned':
        color = const Color(0xFF8B5CF6);
        break;
      case 'Completed':
        color = const Color(0xFF10B981);
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
}
