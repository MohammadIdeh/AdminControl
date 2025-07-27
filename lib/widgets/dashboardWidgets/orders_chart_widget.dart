import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class OrdersChartWidget extends StatefulWidget {
  const OrdersChartWidget({super.key});

  @override
  State<OrdersChartWidget> createState() => _OrdersChartWidgetState();
}

class _OrdersChartWidgetState extends State<OrdersChartWidget> {
  String _selectedMetric = 'Orders';
  final List<String> _metrics = ['Orders', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
                      'Order Analytics',
                      style: AppFonts.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order volume and completion rates',
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
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF10B981),
                                      Color(0xFF059669),
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
                                  : Colors.grey[400],
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
            const SizedBox(height: 32),

            // Order Statistics
            Row(
              children: [
                _buildOrderStat('Today', '247', const Color(0xFF10B981)),
                const SizedBox(width: 32),
                _buildOrderStat('This Week', '1,542', const Color(0xFF3B82F6)),
                const SizedBox(width: 32),
                _buildOrderStat(
                  'Success Rate',
                  '94.2%',
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bar Chart Area
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    29,
                    41,
                    57,
                  ).withOpacity(0.5), // Original color
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomPaint(
                    painter: OrdersBarChartPainter(),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: AppFonts.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrdersBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Mock data for 7 days
    final data = [0.6, 0.8, 0.4, 0.9, 0.7, 0.5, 0.85];
    final completedData = [0.55, 0.75, 0.35, 0.85, 0.65, 0.45, 0.8];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final numBars = data.length;

    // Use 60% of available width for bars, 40% for spacing
    final totalBarsWidth = size.width * 0.6;
    final totalSpacingWidth = size.width * 0.4;

    final barWidth = totalBarsWidth / numBars;
    final spacing = totalSpacingWidth / (numBars + 1);

    // Colors
    final totalBarColor = const Color(0xFF3B82F6);
    final completedBarColor = const Color(0xFF10B981);

    // Reserve space for labels at bottom
    final chartHeight = size.height - 20;

    for (int i = 0; i < data.length; i++) {
      final x = spacing + (i * (barWidth + spacing));

      // Total orders bar
      final totalHeight = chartHeight * data[i];
      final totalRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, chartHeight - totalHeight, barWidth, totalHeight),
        const Radius.circular(4),
      );

      final totalPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [totalBarColor, totalBarColor.withOpacity(0.6)],
        ).createShader(totalRect.outerRect);

      canvas.drawRRect(totalRect, totalPaint);

      // Completed orders bar (overlaid)
      final completedHeight = chartHeight * completedData[i];
      final completedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          x,
          chartHeight - completedHeight,
          barWidth,
          completedHeight,
        ),
        const Radius.circular(4),
      );

      final completedPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [completedBarColor, completedBarColor.withOpacity(0.6)],
        ).createShader(completedRect.outerRect);

      canvas.drawRRect(completedRect, completedPaint);
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = chartHeight * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw day labels
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < days.length; i++) {
      final x = spacing + (i * (barWidth + spacing)) + barWidth / 2;

      textPainter.text = TextSpan(
        text: days[i],
        style: const TextStyle(color: Colors.grey, fontSize: 10),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartHeight + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
