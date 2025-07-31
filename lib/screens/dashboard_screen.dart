import 'package:admin_totp_panel/widgets/dashboardWidgets/active_orders_table_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/geographic_heatmap_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/m3lm_performance_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/orders_chart_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/real_time_activity_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/revenue_chart_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/service_metrics_widget.dart';
import 'package:admin_totp_panel/widgets/dashboardWidgets/stats_cards_widget.dart';
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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
  }

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/users');
        break;
      case 2:
        Navigator.pushNamed(context, '/m3lms');
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
    }
  }

  Future<void> _refreshDashboard() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard refreshed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        29,
        41,
        57,
      ), // Original relaxing color
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
        color: const Color(0xFF3B82F6), // Blue-500
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),
                const SizedBox(height: 32),

                // Stats Cards
                const StatsCardsWidget(),
                const SizedBox(height: 32),

                // Real-time Activity & Service Metrics Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          const RealTimeActivityWidget(),
                          const SizedBox(height: 24),
                          const ServiceMetricsWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Expanded(flex: 1, child: M3lmPerformanceWidget()),
                  ],
                ),
                const SizedBox(height: 32),

                // Charts Row
                Row(
                  children: [
                    const Expanded(child: RevenueChartWidget()),
                    const SizedBox(width: 24),
                    const Expanded(child: OrdersChartWidget()),
                  ],
                ),
                const SizedBox(height: 32),

                // Geographic and Orders Table Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 1, child: GeographicHeatmapWidget()),
                    const SizedBox(width: 24),
                    const Expanded(flex: 2, child: ActiveOrdersTableWidget()),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: AppFonts.heading1.copyWith(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Monitor your home service platform performance',
              style: AppFonts.bodyLarge.copyWith(color: Colors.grey[400]),
            ),
          ],
        ),
        const Spacer(),

        // Refresh Button
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _isRefreshing ? null : _refreshDashboard,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh_rounded, color: Colors.white),
            label: Text(
              _isRefreshing ? 'Refreshing...' : 'Refresh Data',
              style: AppFonts.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
