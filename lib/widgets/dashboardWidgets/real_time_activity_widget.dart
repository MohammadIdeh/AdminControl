import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'dart:async';

class RealTimeActivityWidget extends StatefulWidget {
  const RealTimeActivityWidget({super.key});

  @override
  State<RealTimeActivityWidget> createState() => _RealTimeActivityWidgetState();
}

class _RealTimeActivityWidgetState extends State<RealTimeActivityWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _activityTimer;
  List<ActivityItem> _activities = [];
  int _activityCounter = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);

    // Initialize with some activities
    _initializeActivities();

    // Start real-time updates
    _startActivityUpdates();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _activityTimer?.cancel();
    super.dispose();
  }

  void _initializeActivities() {
    _activities = [
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.newOrder,
        message: 'New plumbing order received',
        user: 'John Smith',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.orderCompleted,
        message: 'Cleaning service completed',
        user: 'Sarah Wilson',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.m3lmOnline,
        message: 'Mike Johnson came online',
        user: 'Mike Johnson',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.payment,
        message: 'Payment received for electrical work',
        user: 'David Brown',
        timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      ),
    ];
  }

  void _startActivityUpdates() {
    _activityTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _addRandomActivity();
      }
    });
  }

  void _addRandomActivity() {
    final random = DateTime.now().millisecondsSinceEpoch % 4;
    final activities = [
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.newOrder,
        message: _getRandomOrderMessage(),
        user: _getRandomCustomer(),
        timestamp: DateTime.now(),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.orderCompleted,
        message: _getRandomCompletionMessage(),
        user: _getRandomCustomer(),
        timestamp: DateTime.now(),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.m3lmOnline,
        message: '${_getRandomM3lm()} came online',
        user: _getRandomM3lm(),
        timestamp: DateTime.now(),
      ),
      ActivityItem(
        id: _activityCounter++,
        type: ActivityType.payment,
        message: _getRandomPaymentMessage(),
        user: _getRandomCustomer(),
        timestamp: DateTime.now(),
      ),
    ];

    setState(() {
      _activities.insert(0, activities[random]);
      if (_activities.length > 10) {
        _activities.removeRange(10, _activities.length);
      }
    });
  }

  String _getRandomOrderMessage() {
    final services = [
      'plumbing',
      'electrical',
      'cleaning',
      'HVAC',
      'gardening',
    ];
    final service =
        services[DateTime.now().millisecondsSinceEpoch % services.length];
    return 'New $service order received';
  }

  String _getRandomCompletionMessage() {
    final services = [
      'plumbing',
      'electrical',
      'cleaning',
      'HVAC',
      'gardening',
    ];
    final service =
        services[DateTime.now().millisecondsSinceEpoch % services.length];
    return '$service service completed';
  }

  String _getRandomPaymentMessage() {
    final services = [
      'plumbing',
      'electrical',
      'cleaning',
      'HVAC',
      'gardening',
    ];
    final service =
        services[DateTime.now().millisecondsSinceEpoch % services.length];
    return 'Payment received for $service work';
  }

  String _getRandomCustomer() {
    final customers = [
      'John Smith',
      'Sarah Wilson',
      'Robert Davis',
      'Lisa Anderson',
      'Mark Thompson',
    ];
    return customers[DateTime.now().millisecondsSinceEpoch % customers.length];
  }

  String _getRandomM3lm() {
    final m3lms = [
      'Mike Johnson',
      'Emily Garcia',
      'David Brown',
      'Anna Martinez',
      'Tom Wilson',
    ];
    return m3lms[DateTime.now().millisecondsSinceEpoch % m3lms.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
            // Header with live indicator
            Row(
              children: [
                Text(
                  'Real-time Activity',
                  style: AppFonts.heading3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: AppFonts.bodySmall.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Latest platform activities',
              style: AppFonts.bodySmall.copyWith(
                color: const Color.fromARGB(
                  255,
                  105,
                  123,
                  123,
                ), // Original gray
              ),
            ),
            const SizedBox(height: 20),

            // Activity Feed
            Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  final activity = _activities[index];
                  return _buildActivityItem(activity, index == 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getActivityColors(activity.type),
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isLatest
                  ? [
                      BoxShadow(
                        color: _getActivityColors(
                          activity.type,
                        )[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              _getActivityIcon(activity.type),
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),

          // Activity Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.message,
                  style: AppFonts.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      activity.user,
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color(0xFF3B82F6),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(activity.timestamp),
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color.fromARGB(
                          255,
                          105,
                          123,
                          123,
                        ), // Original gray
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Activity Badge
          if (isLatest)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'NEW',
                style: AppFonts.bodySmall.copyWith(
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                  fontSize: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Color> _getActivityColors(ActivityType type) {
    switch (type) {
      case ActivityType.newOrder:
        return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
      case ActivityType.orderCompleted:
        return [const Color(0xFF10B981), const Color(0xFF059669)];
      case ActivityType.m3lmOnline:
        return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
      case ActivityType.payment:
        return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.newOrder:
        return Icons.assignment_outlined;
      case ActivityType.orderCompleted:
        return Icons.check_circle_outline;
      case ActivityType.m3lmOnline:
        return Icons.person_outline;
      case ActivityType.payment:
        return Icons.attach_money_outlined;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

enum ActivityType { newOrder, orderCompleted, m3lmOnline, payment }

class ActivityItem {
  final int id;
  final ActivityType type;
  final String message;
  final String user;
  final DateTime timestamp;

  ActivityItem({
    required this.id,
    required this.type,
    required this.message,
    required this.user,
    required this.timestamp,
  });
}
