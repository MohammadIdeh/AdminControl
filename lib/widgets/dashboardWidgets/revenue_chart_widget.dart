import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class RevenueChartWidget extends StatefulWidget {
  const RevenueChartWidget({super.key});

  @override
  State<RevenueChartWidget> createState() => _RevenueChartWidgetState();
}

class _RevenueChartWidgetState extends State<RevenueChartWidget> {
  String _selectedPeriod = '7D';
  final List<String> _periods = ['24H', '7D', '30D', '90D'];

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
                      'Revenue Analytics',
                      style: AppFonts.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track earnings over time',
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
                    children: _periods.map((period) {
                      final isSelected = period == _selectedPeriod;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPeriod = period),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF3B82F6),
                                      Color(0xFF1D4ED8),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            period,
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

            // Revenue Summary
            Row(
              children: [
                _buildSummaryItem(
                  'Total Revenue',
                  '\$45,230',
                  '+12.5%',
                  true,
                  const Color(0xFF10B981),
                ),
                const SizedBox(width: 32),
                _buildSummaryItem(
                  'Average Order',
                  '\$183',
                  '+8.2%',
                  true,
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 32),
                _buildSummaryItem(
                  'Commission',
                  '\$4,523',
                  '+15.1%',
                  true,
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart Area
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
                    painter: RevenueChartPainter(),
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

  Widget _buildSummaryItem(
    String label,
    String value,
    String change,
    bool isPositive,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFonts.heading3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_up : Icons.trending_down,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              change,
              style: AppFonts.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Create gradient for the chart line
    final gradient = LinearGradient(
      colors: [const Color(0xFF3B82F6), const Color(0xFF10B981)],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = gradient;

    // Mock data points for revenue chart
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.15, size.height * 0.6),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.75, size.height * 0.5),
      Offset(size.width, size.height * 0.2),
    ];

    // Draw the chart line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) / 3,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        points[i].dx - (points[i].dx - points[i - 1].dx) / 3,
        points[i].dy,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    // Draw gradient fill
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF3B82F6).withOpacity(0.3),
          const Color(0xFF10B981).withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw data points
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(
        point,
        2,
        Paint()
          ..color = const Color(0xFF3B82F6)
          ..style = PaintingStyle.fill,
      );
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
