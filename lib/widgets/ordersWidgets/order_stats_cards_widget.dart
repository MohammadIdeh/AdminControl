import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'order_model.dart';

class OrderStatsCardsWidget extends StatelessWidget {
  final List<OrderModel> allOrders;

  const OrderStatsCardsWidget({super.key, required this.allOrders});

  @override
  Widget build(BuildContext context) {
    final totalOrders = allOrders.length;
    final activeOrders = allOrders.where((o) => o.isActive).length;
    final completedOrders = allOrders
        .where((o) => o.status == OrderStatus.completed)
        .length;
    final pendingOrders = allOrders
        .where((o) => o.status == OrderStatus.pending)
        .length;
    final urgentOrders = allOrders
        .where((o) => o.isUrgent || o.priority == 'urgent')
        .length;
    final totalRevenue = allOrders
        .where((o) => o.isPaid)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
    final averageOrderValue = totalOrders > 0
        ? totalRevenue / totalOrders
        : 0.0;
    final completionRate = totalOrders > 0
        ? (completedOrders / totalOrders * 100)
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout based on screen width
        if (constraints.maxWidth < 1200) {
          // Stack cards in 2x2 grid on smaller screens
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Orders',
                      totalOrders.toString(),
                      '+12%',
                      true,
                      Icons.receipt_long_outlined,
                      const Color(0xFF3B82F6),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Active Orders',
                      activeOrders.toString(),
                      '+8%',
                      true,
                      Icons.pending_actions_outlined,
                      const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Pending Review',
                      pendingOrders.toString(),
                      '-3%',
                      false,
                      Icons.schedule_outlined,
                      const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Revenue',
                      '\$${totalRevenue.toStringAsFixed(0)}',
                      '+23%',
                      true,
                      Icons.monetization_on_outlined,
                      const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Single row on larger screens with 5 cards
          return IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Orders',
                    totalOrders.toString(),
                    '+12%',
                    true,
                    Icons.receipt_long_outlined,
                    const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Active Orders',
                    activeOrders.toString(),
                    '+8%',
                    true,
                    Icons.pending_actions_outlined,
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Urgent Orders',
                    urgentOrders.toString(),
                    '+15%',
                    true,
                    Icons.priority_high_outlined,
                    const Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Completion Rate',
                    '${completionRate.toStringAsFixed(1)}%',
                    '+2.1%',
                    true,
                    Icons.check_circle_outline,
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildStatCard(
                    'Avg Order Value',
                    '\$${averageOrderValue.toStringAsFixed(0)}',
                    '+5.3%',
                    true,
                    Icons.monetization_on_outlined,
                    const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          );
        }
      },
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
      height: 140,
      padding: const EdgeInsets.all(20),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top row - Icon and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF10B981).withOpacity(0.2)
                      : const Color(0xFFEF4444).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPositive
                        ? const Color(0xFF10B981).withOpacity(0.3)
                        : const Color(0xFFEF4444).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      percentage,
                      style: AppFonts.bodySmall.copyWith(
                        color: isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bottom section - Value and title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppFonts.heading1.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: AppFonts.bodySmall.copyWith(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
