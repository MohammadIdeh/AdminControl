import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class GeographicHeatmapWidget extends StatefulWidget {
  const GeographicHeatmapWidget({super.key});

  @override
  State<GeographicHeatmapWidget> createState() =>
      _GeographicHeatmapWidgetState();
}

class _GeographicHeatmapWidgetState extends State<GeographicHeatmapWidget> {
  String _selectedView = 'Orders';
  final List<String> _views = ['Orders', 'M3LMs', 'Revenue'];

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
                      'Geographic Distribution',
                      style: AppFonts.heading3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Regional activity overview',
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color.fromARGB(
                          255,
                          105,
                          123,
                          123,
                        ), // Original gray
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
                    children: _views.map((view) {
                      final isSelected = view == _selectedView;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedView = view),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF8B5CF6),
                                      Color(0xFF7C3AED),
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            view,
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
            const SizedBox(height: 24),

            // Map Area (Mock representation)
            Expanded(
              flex: 3,
              child: Container(
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
                child: Stack(
                  children: [
                    // Mock map background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: RadialGradient(
                          center: const Alignment(0.2, -0.3),
                          radius: 1.2,
                          colors: [
                            const Color(0xFF3B82F6).withOpacity(0.2),
                            const Color(0xFF1E293B).withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Mock heat points
                    ...List.generate(8, (index) {
                      final positions = [
                        const Alignment(-0.3, -0.2),
                        const Alignment(0.2, -0.4),
                        const Alignment(0.5, 0.1),
                        const Alignment(-0.1, 0.3),
                        const Alignment(0.3, 0.5),
                        const Alignment(-0.4, 0.2),
                        const Alignment(0.1, -0.1),
                        const Alignment(-0.2, 0.4),
                      ];

                      final intensities = [
                        0.9,
                        0.7,
                        0.8,
                        0.5,
                        0.6,
                        0.4,
                        0.7,
                        0.3,
                      ];

                      return Align(
                        alignment: positions[index],
                        child: _buildHeatPoint(intensities[index]),
                      );
                    }),

                    // Center info overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            36,
                            50,
                            69,
                          ).withOpacity(0.9), // Original color
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: Colors.grey[400],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Interactive Map',
                              style: AppFonts.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Would integrate with Maps API',
                              style: AppFonts.bodySmall.copyWith(
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Regional Stats
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top Regions',
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getRegionalData().length,
                      itemBuilder: (context, index) {
                        final region = _getRegionalData()[index];
                        return _buildRegionItem(region, index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatPoint(double intensity) {
    return Container(
      width: 20 + (intensity * 30),
      height: 20 + (intensity * 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _getHeatColor(intensity).withOpacity(0.8),
            _getHeatColor(intensity).withOpacity(0.3),
            _getHeatColor(intensity).withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getHeatColor(intensity),
          ),
        ),
      ),
    );
  }

  Color _getHeatColor(double intensity) {
    if (intensity > 0.7) {
      return const Color(0xFFEF4444); // Red for high activity
    } else if (intensity > 0.4) {
      return const Color(0xFFF59E0B); // Orange for medium activity
    } else {
      return const Color(0xFF10B981); // Green for low activity
    }
  }

  List<Map<String, dynamic>> _getRegionalData() {
    switch (_selectedView) {
      case 'Orders':
        return [
          {
            'region': 'Downtown',
            'value': '245 orders',
            'percentage': 0.8,
            'color': const Color(0xFF3B82F6),
          },
          {
            'region': 'Suburbs North',
            'value': '178 orders',
            'percentage': 0.6,
            'color': const Color(0xFF10B981),
          },
          {
            'region': 'Suburbs South',
            'value': '134 orders',
            'percentage': 0.45,
            'color': const Color(0xFFF59E0B),
          },
          {
            'region': 'Industrial',
            'value': '89 orders',
            'percentage': 0.3,
            'color': const Color(0xFF8B5CF6),
          },
        ];
      case 'M3LMs':
        return [
          {
            'region': 'Downtown',
            'value': '45 M3LMs',
            'percentage': 0.7,
            'color': const Color(0xFF3B82F6),
          },
          {
            'region': 'Suburbs North',
            'value': '32 M3LMs',
            'percentage': 0.5,
            'color': const Color(0xFF10B981),
          },
          {
            'region': 'Suburbs South',
            'value': '28 M3LMs',
            'percentage': 0.4,
            'color': const Color(0xFFF59E0B),
          },
          {
            'region': 'Industrial',
            'value': '18 M3LMs',
            'percentage': 0.25,
            'color': const Color(0xFF8B5CF6),
          },
        ];
      case 'Revenue':
        return [
          {
            'region': 'Downtown',
            'value': '\$15.2K',
            'percentage': 0.9,
            'color': const Color(0xFF3B82F6),
          },
          {
            'region': 'Suburbs North',
            'value': '\$8.9K',
            'percentage': 0.55,
            'color': const Color(0xFF10B981),
          },
          {
            'region': 'Suburbs South',
            'value': '\$6.7K',
            'percentage': 0.4,
            'color': const Color(0xFFF59E0B),
          },
          {
            'region': 'Industrial',
            'value': '\$4.2K',
            'percentage': 0.25,
            'color': const Color(0xFF8B5CF6),
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildRegionItem(Map<String, dynamic> region, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          29,
          41,
          57,
        ).withOpacity(0.3), // Original color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: region['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppFonts.bodySmall.copyWith(
                  color: region['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Region name
          Expanded(
            child: Text(
              region['region'],
              style: AppFonts.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Value
          Text(
            region['value'],
            style: AppFonts.bodySmall.copyWith(
              color: Colors.grey[300],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),

          // Progress bar
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: region['percentage'],
              child: Container(
                decoration: BoxDecoration(
                  color: region['color'],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
