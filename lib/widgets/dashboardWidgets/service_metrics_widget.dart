import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class ServiceMetricsWidget extends StatefulWidget {
  const ServiceMetricsWidget({super.key});

  @override
  State<ServiceMetricsWidget> createState() => _ServiceMetricsWidgetState();
}

class _ServiceMetricsWidgetState extends State<ServiceMetricsWidget> {
  String _selectedMetric = 'Performance';
  final List<String> _metrics = ['Performance', 'Quality', 'Efficiency'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 510,
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
                      'Service Metrics',
                      style: AppFonts.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Key performance indicators',
                      style: AppFonts.bodySmall.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      29,
                      41,
                      57,
                    ), // Original background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: _metrics.map((metric) {
                      final isSelected = metric == _selectedMetric;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedMetric = metric),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFEF4444),
                                      Color(0xFFDC2626),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            metric,
                            style: AppFonts.bodySmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : const Color.fromARGB(
                                      255,
                                      105,
                                      123,
                                      123,
                                    ), // Original gray
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Metrics Grid
            Expanded(child: _buildMetricsContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsContent() {
    switch (_selectedMetric) {
      case 'Performance':
        return _buildPerformanceMetrics();
      case 'Quality':
        return _buildQualityMetrics();
      case 'Efficiency':
        return _buildEfficiencyMetrics();
      default:
        return _buildPerformanceMetrics();
    }
  }

  Widget _buildPerformanceMetrics() {
    return Column(
      children: [
        // Top row metrics
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Avg. Response Time',
                '12 min',
                0.75,
                const Color(0xFF10B981),
                Icons.timer_outlined,
                '+5% vs yesterday',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Success Rate',
                '94.2%',
                0.94,
                const Color(0xFF3B82F6),
                Icons.check_circle_outline,
                '+2.1% this week',
                true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Bottom row metrics
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Avg. Service Time',
                '45 min',
                0.65,
                const Color(0xFFF59E0B),
                Icons.schedule_outlined,
                '-3 min vs last week',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Completion Rate',
                '91.8%',
                0.91,
                const Color(0xFF8B5CF6),
                Icons.task_alt_outlined,
                '+1.5% this month',
                true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQualityMetrics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Customer Rating',
                '4.7/5',
                0.94,
                const Color(0xFFF59E0B),
                Icons.star_outline,
                '+0.2 this month',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Repeat Customers',
                '68%',
                0.68,
                const Color(0xFF10B981),
                Icons.repeat_outlined,
                '+5% vs last month',
                true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Complaints',
                '12',
                0.12,
                const Color(0xFFEF4444),
                Icons.warning_outlined,
                '-3 vs last week',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Resolution Time',
                '2.3 hrs',
                0.77,
                const Color(0xFF3B82F6),
                Icons.support_agent_outlined,
                '-15 min avg',
                true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEfficiencyMetrics() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Orders/M3LM',
                '5.2',
                0.86,
                const Color(0xFF3B82F6),
                Icons.person_outline,
                '+0.3 daily avg',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Utilization Rate',
                '78%',
                0.78,
                const Color(0xFF10B981),
                Icons.trending_up_outlined,
                '+8% this week',
                true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                'Idle Time',
                '15 min',
                0.25,
                const Color(0xFFF59E0B),
                Icons.schedule_outlined,
                '-5 min avg',
                true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(
                'Peak Hours',
                '2-6 PM',
                0.75,
                const Color(0xFF8B5CF6),
                Icons.access_time_outlined,
                '4hr window',
                false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    double progress,
    Color color,
    IconData icon,
    String change,
    bool showTrend,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          29,
          41,
          57,
        ).withOpacity(0.5), // Original color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              if (showTrend)
                Icon(
                  Icons.trending_up,
                  color: const Color(0xFF10B981),
                  size: 16,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Value
          Text(
            value,
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),

          // Title
          Text(
            title,
            style: AppFonts.bodySmall.copyWith(
              color: const Color.fromARGB(255, 105, 123, 123), // Original gray
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),

          // Progress bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Change indicator
          Text(
            change,
            style: AppFonts.bodySmall.copyWith(
              color: showTrend
                  ? const Color(0xFF10B981)
                  : const Color.fromARGB(255, 105, 123, 123), // Original gray
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
