import 'package:admin_totp_panel/widgets/ordersWidgets/order_list_widget.dart';
import 'package:admin_totp_panel/widgets/ordersWidgets/order_model.dart';
import 'package:admin_totp_panel/widgets/ordersWidgets/order_stats_cards_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/generalWidgets/font.dart';
import '../widgets/generalWidgets/nav_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;
  int _currentIndex = 3; // Since this is the Orders tab

  // Mock order data with comprehensive information
  final List<OrderModel> _allOrders = [
    OrderModel(
      id: 'ORD-2024-001',
      customerId: 'USR001',
      customerName: 'John Smith',
      customerEmail: 'john.smith@email.com',
      customerPhone: '+1-555-0123',
      customerAddress: '123 Main Street, Downtown, NY 10001',
      m3lmId: 'M3L001',
      m3lmName: 'Mike Johnson',
      m3lmPhone: '+1-555-0201',
      m3lmAvatar: 'MJ',
      serviceType: ServiceType.plumbing,
      serviceDescription: 'Emergency pipe repair in kitchen sink',
      price: 150.00,
      platformFee: 15.00,
      totalAmount: 165.00,
      status: OrderStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      scheduledAt: DateTime.now().add(const Duration(hours: 1)),
      startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      location: 'Downtown, NY',
      latitude: 40.7128,
      longitude: -74.0060,
      notes: 'Customer prefers morning appointment',
      isPaid: true,
      paymentMethod: 'Credit Card',
      estimatedDuration: 120,
      priority: 'high',
    ),
    OrderModel(
      id: 'ORD-2024-002',
      customerId: 'USR002',
      customerName: 'Sarah Wilson',
      customerEmail: 'sarah.wilson@email.com',
      customerPhone: '+1-555-0124',
      customerAddress: '456 Oak Avenue, Suburbs South, NY 10002',
      m3lmId: 'M3L002',
      m3lmName: 'David Brown',
      m3lmPhone: '+1-555-0203',
      m3lmAvatar: 'DB',
      serviceType: ServiceType.electrical,
      serviceDescription: 'Install new outlet and fix wiring issues',
      price: 275.00,
      platformFee: 27.50,
      totalAmount: 302.50,
      status: OrderStatus.assigned,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      scheduledAt: DateTime.now().add(const Duration(hours: 3)),
      location: 'Suburbs South, NY',
      latitude: 40.6892,
      longitude: -74.0445,
      notes: 'Safety inspection required',
      isPaid: true,
      paymentMethod: 'PayPal',
      estimatedDuration: 180,
      priority: 'normal',
    ),
    OrderModel(
      id: 'ORD-2024-003',
      customerId: 'USR003',
      customerName: 'Robert Davis',
      customerEmail: 'robert.davis@email.com',
      customerPhone: '+1-555-0125',
      customerAddress: '789 Pine Street, East Side, NY 10003',
      m3lmId: 'M3L003',
      m3lmName: 'Sarah Miller',
      m3lmPhone: '+1-555-0202',
      m3lmAvatar: 'SM',
      serviceType: ServiceType.cleaning,
      serviceDescription: 'Deep cleaning service for 3-bedroom apartment',
      price: 85.00,
      platformFee: 8.50,
      totalAmount: 93.50,
      status: OrderStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      scheduledAt: DateTime.now().subtract(const Duration(hours: 6)),
      startedAt: DateTime.now().subtract(const Duration(hours: 4)),
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'East Side, NY',
      latitude: 40.7282,
      longitude: -73.9942,
      notes: 'Pet-friendly cleaning products requested',
      isPaid: true,
      paymentMethod: 'Credit Card',
      rating: 4.8,
      review: 'Excellent service, very thorough!',
      estimatedDuration: 240,
      priority: 'normal',
    ),
    OrderModel(
      id: 'ORD-2024-004',
      customerId: 'USR004',
      customerName: 'Lisa Anderson',
      customerEmail: 'lisa.anderson@email.com',
      customerPhone: '+1-555-0126',
      customerAddress: '321 Elm Drive, West Side, NY 10004',
      m3lmId: 'M3L004',
      m3lmName: 'Emily Garcia',
      m3lmPhone: '+1-555-0204',
      m3lmAvatar: 'EG',
      serviceType: ServiceType.hvac,
      serviceDescription: 'AC unit maintenance and filter replacement',
      price: 420.00,
      platformFee: 42.00,
      totalAmount: 462.00,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      scheduledAt: DateTime.now().add(const Duration(hours: 4)),
      location: 'West Side, NY',
      latitude: 40.7580,
      longitude: -73.9855,
      notes: 'Building access code: #1234',
      isPaid: false,
      paymentMethod: 'Cash',
      estimatedDuration: 90,
      isUrgent: true,
      priority: 'urgent',
    ),
    OrderModel(
      id: 'ORD-2024-005',
      customerId: 'USR005',
      customerName: 'Mark Thompson',
      customerEmail: 'mark.thompson@email.com',
      customerPhone: '+1-555-0127',
      customerAddress: '654 Maple Lane, Industrial District, NY 10005',
      serviceType: ServiceType.gardening,
      serviceDescription: 'Lawn mowing and hedge trimming',
      price: 95.00,
      platformFee: 9.50,
      totalAmount: 104.50,
      status: OrderStatus.cancelled,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      scheduledAt: DateTime.now().subtract(const Duration(days: 1)),
      cancelledAt: DateTime.now().subtract(const Duration(hours: 12)),
      cancellationReason: 'Weather conditions',
      location: 'Industrial District, NY',
      latitude: 40.6782,
      longitude: -74.0442,
      notes: 'Weather-dependent service',
      isPaid: false,
      paymentMethod: 'Credit Card',
      estimatedDuration: 60,
      priority: 'low',
    ),
    OrderModel(
      id: 'ORD-2024-006',
      customerId: 'USR001',
      customerName: 'John Smith',
      customerEmail: 'john.smith@email.com',
      customerPhone: '+1-555-0123',
      customerAddress: '123 Main Street, Downtown, NY 10001',
      serviceType: ServiceType.painting,
      serviceDescription: 'Interior wall painting - 2 rooms',
      price: 350.00,
      platformFee: 35.00,
      totalAmount: 385.00,
      status: OrderStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      scheduledAt: DateTime.now().add(const Duration(days: 2)),
      location: 'Downtown, NY',
      latitude: 40.7128,
      longitude: -74.0060,
      notes: 'Customer will provide paint',
      isPaid: true,
      paymentMethod: 'Credit Card',
      promoCode: 'PAINT20',
      discount: 70.00,
      estimatedDuration: 480,
      priority: 'normal',
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
        Navigator.pushNamed(context, '/users');
        break;
      case 2:
        Navigator.pushNamed(context, '/m3lms');
        break;
      case 3:
        break; // Current screen
      case 4:
        break; // Categories - not yet implemented
      case 5:
        break; // Tracking - not yet implemented
    }
  }

  Future<void> _refreshOrders() async {
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
          content: const Text('Orders data refreshed successfully'),
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
        onRefresh: _refreshOrders,
        color: const Color(0xFF3B82F6),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 32),

                  // Statistics Cards Widget
                  SizedBox(
                    height: 180,
                    child: OrderStatsCardsWidget(allOrders: _allOrders),
                  ),
                  const SizedBox(height: 32),

                  // Order List Widget
                  OrderListWidget(
                    allOrders: _allOrders,
                    onRefresh: _refreshOrders,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Icon and Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Management',
                      style: AppFonts.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage and track all service orders',
                      style: AppFonts.bodyLarge.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Spacer(),

        // Right side - Action Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Export Orders Button
            _buildActionButton(
              'Export Orders',
              Icons.download,
              const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              ),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Exporting orders data...'),
                    backgroundColor: const Color(0xFF8B5CF6),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),

            // Live Tracking Button
            _buildActionButton(
              'Live Tracking',
              Icons.location_on,
              const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Opening live tracking dashboard...'),
                    backgroundColor: const Color(0xFF10B981),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),

            // Refresh Button
            _buildActionButton(
              _isLoading ? 'Refreshing...' : 'Refresh Data',
              _isLoading ? null : Icons.refresh_rounded,
              const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
              ),
              _isLoading ? null : _refreshOrders,
              isLoading: _isLoading,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData? icon,
    Gradient gradient,
    VoidCallback? onPressed, {
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Icon(icon, color: Colors.white, size: 18),
        label: Text(text, style: AppFonts.button.copyWith(color: Colors.white)),
      ),
    );
  }
}
