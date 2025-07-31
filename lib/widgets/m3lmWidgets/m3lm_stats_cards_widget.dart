import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';

class M3lmStatsCardsWidget extends StatelessWidget {
  final List<M3lmModel> allM3lms;

  const M3lmStatsCardsWidget({super.key, required this.allM3lms});

  @override
  Widget build(BuildContext context) {
    final totalM3lms = allM3lms.length;
    final activeM3lms = allM3lms
        .where((m) => m.isActive && !m.isBlocked && m.isVerified)
        .length;
    final availableM3lms = allM3lms
        .where((m) => m.isAvailable && m.isActive && !m.isBlocked)
        .length;
    final pendingVerification = allM3lms
        .where((m) => m.verificationStatus == 'Pending')
        .length;
    final totalEarnings = allM3lms.fold(
      0.0,
      (sum, m3lm) => sum + m3lm.totalEarnings,
    );
    final averageRating = allM3lms.isNotEmpty
        ? allM3lms.fold(0.0, (sum, m3lm) => sum + m3lm.rating) / allM3lms.length
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive layout based on screen width
        if (constraints.maxWidth < 800) {
          // Stack cards vertically on smaller screens
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total M3LMs',
                      totalM3lms.toString(),
                      '+15%',
                      true,
                      Icons.engineering_outlined,
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Available Now',
                      availableM3lms.toString(),
                      '+5%',
                      true,
                      Icons.verified_user_outlined,
                      const Color(0xFF3B82F6),
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
                      pendingVerification.toString(),
                      '-8%',
                      false,
                      Icons.pending_actions_outlined,
                      const Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Avg Rating',
                      averageRating.toStringAsFixed(1),
                      '+0.2',
                      true,
                      Icons.star_outline,
                      const Color(0xFF8B5CF6),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          // Single row on larger screens
          return IntrinsicHeight(
            // Ensures all cards have the same height
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total M3LMs',
                    totalM3lms.toString(),
                    '+15%',
                    true,
                    Icons.engineering_outlined,
                    const Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Available Now',
                    availableM3lms.toString(),
                    '+5%',
                    true,
                    Icons.verified_user_outlined,
                    const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Pending Review',
                    pendingVerification.toString(),
                    '-8%',
                    false,
                    Icons.pending_actions_outlined,
                    const Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildStatCard(
                    'Avg Rating',
                    averageRating.toStringAsFixed(1),
                    '+0.2',
                    true,
                    Icons.star_outline,
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
      // Fixed height to prevent flex issues
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
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribute space evenly
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
