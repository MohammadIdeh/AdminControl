import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class StatsCardsWidget extends StatelessWidget {
  const StatsCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 800
            ? 2
            : 1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 1.8,
          children: [
            _buildStatsCard(
              title: 'Active Orders',
              value: '247',
              percentage: '+12%',
              isPositive: true,
              icon: Icons.assignment_outlined,
              iconColor: const Color(0xFF10B981), // Emerald-500
              gradient: const LinearGradient(
                colors: [Color(0xFF065F46), Color(0xFF047857)],
              ),
            ),
            _buildStatsCard(
              title: 'Available M3LMs',
              value: '89',
              percentage: '+8%',
              isPositive: true,
              icon: Icons.person_outline,
              iconColor: const Color(0xFF3B82F6), // Blue-500
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
              ),
            ),
            _buildStatsCard(
              title: 'Daily Revenue',
              value: '\$12.4K',
              percentage: '+23%',
              isPositive: true,
              icon: Icons.attach_money_outlined,
              iconColor: const Color(0xFFF59E0B), // Amber-500
              gradient: const LinearGradient(
                colors: [Color(0xFF92400E), Color(0xFFD97706)],
              ),
            ),
            _buildStatsCard(
              title: 'Queue Length',
              value: '34',
              percentage: '-5%',
              isPositive: false,
              icon: Icons.queue_outlined,
              iconColor: const Color(0xFFEF4444), // Red-500
              gradient: const LinearGradient(
                colors: [Color(0xFF991B1B), Color(0xFFDC2626)],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Gradient gradient,
  }) {
    return Container(
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
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [iconColor.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? const Color(0xFF10B981).withOpacity(0.2)
                            : const Color(0xFFEF4444).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
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
                            isPositive
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isPositive
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            size: 14,
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
                const Spacer(),
                Text(
                  value,
                  style: AppFonts.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
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
          ),
        ],
      ),
    );
  }
}
