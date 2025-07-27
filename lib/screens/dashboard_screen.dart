import 'package:flutter/material.dart';
import '../widgets/generalWidgets/font.dart';
import '../widgets/generalWidgets/nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    // You can load profile picture from preferences here
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Stay on dashboard
        break;
      case 1:
        // Navigate to users
        break;
      case 2:
        // Navigate to security
        break;
      case 3:
        // Navigate to QR codes
        break;
      case 4:
        // Navigate to settings
        break;
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
          profilePictureUrl: profilePictureUrl,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshDashboard,
        color: const Color(0xFF1976D2),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 45, top: 20, right: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard Title & Refresh Button
                  Row(
                    children: [
                      Text(
                        'Dashboard',
                        style: AppFonts.heading1.copyWith(
                          color: const Color.fromARGB(255, 246, 246, 246),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            36,
                            50,
                            69,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 1,
                        ),
                        onPressed: _refreshDashboard,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.refresh,
                              color: Color.fromARGB(255, 105, 123, 123),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Refresh',
                              style: AppFonts.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 105, 123, 123),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Stats Cards
                  _buildStatsCards(),
                  const SizedBox(height: 20),

                  // Dashboard Widgets
                  _buildDashboardWidgets(),

                  const SizedBox(height: 20),

                  // Recent Activity
                  _buildRecentActivity(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        const numberOfCards = 4;
        const spacing = 40.0;
        final cardWidth =
            (availableWidth - ((numberOfCards - 1) * spacing)) / numberOfCards;

        return Wrap(
          spacing: spacing,
          runSpacing: 20,
          children: [
            _buildStatsCard(
              title: 'Total Users',
              value: '1,234',
              percentage: '+12%',
              isPositive: true,
              icon: Icons.people,
              width: cardWidth,
            ),
            _buildStatsCard(
              title: 'Active Sessions',
              value: '567',
              percentage: '+8%',
              isPositive: true,
              icon: Icons.login,
              width: cardWidth,
            ),
            _buildStatsCard(
              title: 'Failed Attempts',
              value: '23',
              percentage: '-5%',
              isPositive: true,
              icon: Icons.warning,
              width: cardWidth,
            ),
            _buildStatsCard(
              title: 'QR Codes Generated',
              value: '89',
              percentage: '+15%',
              isPositive: true,
              icon: Icons.qr_code,
              width: cardWidth,
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
    required double width,
  }) {
    return Container(
      width: width,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: const Color(0xFF1976D2), size: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  percentage,
                  style: AppFonts.bodySmall.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: AppFonts.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppFonts.bodyMedium.copyWith(
              color: const Color.fromARGB(255, 105, 123, 123),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardWidgets() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 20.0;
        const columns = 2;
        final itemWidth =
            (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _buildUserActivityChart(itemWidth),
            _buildSecurityEvents(itemWidth),
            _buildTopRegions(itemWidth),
            _buildSystemHealth(itemWidth),
          ],
        );
      },
    );
  }

  Widget _buildUserActivityChart(double width) {
    return Container(
      width: width,
      height: 400,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Activity',
            style: AppFonts.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 64,
                    color: const Color(0xFF1976D2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Activity chart would go here',
                    style: AppFonts.bodyMedium.copyWith(
                      color: const Color.fromARGB(255, 105, 123, 123),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityEvents(double width) {
    return Container(
      width: width,
      height: 400,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Events',
            style: AppFonts.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 41, 57),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        index % 2 == 0 ? Icons.check_circle : Icons.warning,
                        color: index % 2 == 0 ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              index % 2 == 0
                                  ? 'Successful Login'
                                  : 'Failed Login Attempt',
                              style: AppFonts.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${index + 1} minute${index == 0 ? '' : 's'} ago',
                              style: AppFonts.bodySmall.copyWith(
                                color: const Color.fromARGB(255, 105, 123, 123),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRegions(double width) {
    return Container(
      width: width,
      height: 400,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Regions',
            style: AppFonts.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.public, size: 64, color: const Color(0xFF1976D2)),
                  const SizedBox(height: 16),
                  Text(
                    'Geographic data would go here',
                    style: AppFonts.bodyMedium.copyWith(
                      color: const Color.fromARGB(255, 105, 123, 123),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth(double width) {
    return Container(
      width: width,
      height: 400,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Health',
            style: AppFonts.heading3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildHealthItem('CPU Usage', '45%', Colors.green),
          _buildHealthItem('Memory Usage', '67%', Colors.orange),
          _buildHealthItem('Storage Usage', '23%', Colors.green),
          _buildHealthItem('Network Status', 'Healthy', Colors.green),
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.bodyMedium.copyWith(
              color: const Color.fromARGB(255, 105, 123, 123),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: AppFonts.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppFonts.heading3.copyWith(
            color: const Color.fromARGB(255, 246, 246, 246),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 36, 50, 69),
            borderRadius: BorderRadius.circular(24),
          ),
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  'User',
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Action',
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Time',
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Status',
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            rows: List.generate(5, (index) {
              final users = [
                'admin@example.com',
                'user1@example.com',
                'user2@example.com',
                'test@example.com',
                'demo@example.com',
              ];
              final actions = [
                'Login',
                'QR Generated',
                'Password Reset',
                'Login',
                'Failed Login',
              ];
              final times = [
                '2 min ago',
                '5 min ago',
                '10 min ago',
                '15 min ago',
                '20 min ago',
              ];
              final statuses = [
                'Success',
                'Success',
                'Success',
                'Success',
                'Failed',
              ];

              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      users[index],
                      style: AppFonts.bodyMedium.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      actions[index],
                      style: AppFonts.bodyMedium.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      times[index],
                      style: AppFonts.bodyMedium.copyWith(
                        color: const Color.fromARGB(255, 105, 123, 123),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statuses[index] == 'Success'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statuses[index],
                        style: AppFonts.bodySmall.copyWith(
                          color: statuses[index] == 'Success'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshDashboard() async {
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));
    // Reload data here
  }
}
