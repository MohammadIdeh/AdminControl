import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class M3lmPerformanceWidget extends StatefulWidget {
  const M3lmPerformanceWidget({super.key});

  @override
  State<M3lmPerformanceWidget> createState() => _M3lmPerformanceWidgetState();
}

class _M3lmPerformanceWidgetState extends State<M3lmPerformanceWidget> {
  String _selectedTab = 'Top Performers';
  final List<String> _tabs = ['Top Performers', 'New M3LMs', 'Issues'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
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
            Text(
              'M3LM Performance',
              style: AppFonts.heading3.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Service provider analytics',
              style: AppFonts.bodySmall.copyWith(
                color: const Color.fromARGB(
                  255,
                  105,
                  123,
                  123,
                ), // Original gray color
              ),
            ),
            const SizedBox(height: 24),

            // Tab Controls
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
                children: _tabs.map((tab) {
                  final isSelected = tab == _selectedTab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = tab),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                          tab,
                          textAlign: TextAlign.center,
                          style: AppFonts.bodySmall.copyWith(
                            color: isSelected
                                ? Colors.white
                                : const Color.fromARGB(255, 105, 123, 123),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Top Performers':
        return _buildTopPerformers();
      case 'New M3LMs':
        return _buildNewM3lms();
      case 'Issues':
        return _buildIssues();
      default:
        return _buildTopPerformers();
    }
  }

  Widget _buildTopPerformers() {
    final topPerformers = [
      {
        'name': 'Mike Johnson',
        'service': 'Plumbing',
        'rating': 4.9,
        'orders': 145,
        'earnings': '\$12,450',
        'avatar': 'MJ',
        'online': true,
      },
      {
        'name': 'Sarah Miller',
        'service': 'Cleaning',
        'rating': 4.8,
        'orders': 132,
        'earnings': '\$8,960',
        'avatar': 'SM',
        'online': true,
      },
      {
        'name': 'David Brown',
        'service': 'Electrical',
        'rating': 4.9,
        'orders': 98,
        'earnings': '\$15,230',
        'avatar': 'DB',
        'online': false,
      },
      {
        'name': 'Emily Garcia',
        'service': 'HVAC',
        'rating': 4.7,
        'orders': 87,
        'earnings': '\$18,420',
        'avatar': 'EG',
        'online': true,
      },
    ];

    return ListView.builder(
      itemCount: topPerformers.length,
      itemBuilder: (context, index) {
        final performer = topPerformers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: Row(
            children: [
              // Avatar with online status
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF10B981),
                    child: Text(
                      performer['avatar'] as String,
                      style: AppFonts.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (performer['online'] as bool)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 29, 41, 57),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Name and Service
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      performer['name'] as String,
                      style: AppFonts.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      performer['service'] as String,
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${performer['rating']}',
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color(0xFFF59E0B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    performer['earnings'] as String,
                    style: AppFonts.bodyMedium.copyWith(
                      color: const Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${performer['orders']} orders',
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color.fromARGB(255, 105, 123, 123),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewM3lms() {
    final newM3lms = [
      {
        'name': 'Alex Rodriguez',
        'service': 'Painting',
        'joinDate': '2 days ago',
        'status': 'Pending Verification',
        'avatar': 'AR',
      },
      {
        'name': 'Jessica Chen',
        'service': 'Pet Care',
        'joinDate': '3 days ago',
        'status': 'Verified',
        'avatar': 'JC',
      },
      {
        'name': 'Robert Taylor',
        'service': 'Handyman',
        'joinDate': '5 days ago',
        'status': 'Training',
        'avatar': 'RT',
      },
    ];

    return ListView.builder(
      itemCount: newM3lms.length,
      itemBuilder: (context, index) {
        final m3lm = newM3lms[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF3B82F6),
                child: Text(
                  m3lm['avatar'] as String,
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m3lm['name'] as String,
                      style: AppFonts.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m3lm['service'] as String,
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m3lm['joinDate'] as String,
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(m3lm['status'] as String),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIssues() {
    final issues = [
      {
        'title': 'Customer Complaint',
        'description': 'Late arrival for plumbing service',
        'severity': 'Medium',
        'time': '1 hour ago',
        'm3lm': 'Mike Johnson',
      },
      {
        'title': 'Payment Dispute',
        'description': 'Service fee disagreement',
        'severity': 'High',
        'time': '3 hours ago',
        'm3lm': 'Sarah Miller',
      },
      {
        'title': 'No-Show',
        'description': 'M3LM didn\'t arrive for scheduled service',
        'severity': 'High',
        'time': '5 hours ago',
        'm3lm': 'David Brown',
      },
    ];

    return ListView.builder(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    issue['title'] as String,
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildSeverityChip(issue['severity'] as String),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                issue['description'] as String,
                style: AppFonts.bodySmall.copyWith(
                  color: const Color.fromARGB(255, 105, 123, 123),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'M3LM: ${issue['m3lm']}',
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color(0xFF3B82F6),
                    ),
                  ),
                  Text(
                    issue['time'] as String,
                    style: AppFonts.bodySmall.copyWith(
                      color: const Color.fromARGB(255, 105, 123, 123),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Verified':
        color = const Color(0xFF10B981);
        break;
      case 'Pending Verification':
        color = const Color(0xFFF59E0B);
        break;
      case 'Training':
        color = const Color(0xFF3B82F6);
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

  Widget _buildSeverityChip(String severity) {
    Color color;
    switch (severity) {
      case 'High':
        color = const Color(0xFFEF4444);
        break;
      case 'Medium':
        color = const Color(0xFFF59E0B);
        break;
      case 'Low':
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
        severity,
        style: AppFonts.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}
