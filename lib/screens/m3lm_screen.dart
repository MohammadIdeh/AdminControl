import 'package:admin_totp_panel/widgets/m3lmWidgets/m3lm_list_widget.dart';
import 'package:admin_totp_panel/widgets/m3lmWidgets/m3lm_stats_cards_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/generalWidgets/font.dart';
import '../widgets/generalWidgets/nav_bar.dart';
import '../widgets/m3lmWidgets/m3lm_model.dart';

class M3lmScreen extends StatefulWidget {
  const M3lmScreen({super.key});

  @override
  State<M3lmScreen> createState() => _M3lmScreenState();
}

class _M3lmScreenState extends State<M3lmScreen> {
  bool _isLoading = false;
  int _currentIndex = 2; // Since this is the M3LMs tab

  // Mock M3LM data with comprehensive information
  final List<M3lmModel> _allM3lms = [
    M3lmModel(
      id: 'M3L001',
      name: 'Mike Johnson',
      email: 'mike.johnson@email.com',
      phone: '+1-555-0201',
      location: 'Downtown, NY',
      isActive: true,
      isBlocked: false,
      isVerified: true,
      isAvailable: true,
      joinDate: DateTime(2023, 1, 10),
      lastActive: DateTime.now().subtract(const Duration(minutes: 2)),
      totalJobs: 145,
      activeJobs: 3,
      completedJobs: 138,
      avatar: 'MJ',
      rating: 4.9,
      walletBalance: 2450.75,
      monthlyEarnings: 3200.50,
      totalEarnings: 18750.25,
      services: ['Plumbing', 'General Repairs'],
      experienceLevel: 'Expert',
      verificationStatus: 'Verified',
      serviceAreas: ['Downtown', 'Suburbs North'],
      completionRate: 95.2,
      reviewsCount: 247,
      certifications: ['Licensed Plumber', 'Safety Certified'],
      bankAccount: '****1234',
      taxId: 'TX123456789',
      lastPayment: DateTime.now().subtract(const Duration(days: 7)),
    ),
    M3lmModel(
      id: 'M3L002',
      name: 'Sarah Miller',
      email: 'sarah.miller@email.com',
      phone: '+1-555-0202',
      location: 'Suburbs South, NY',
      isActive: true,
      isBlocked: false,
      isVerified: true,
      isAvailable: false, // Currently busy
      joinDate: DateTime(2023, 2, 15),
      lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
      totalJobs: 132,
      activeJobs: 2,
      completedJobs: 127,
      avatar: 'SM',
      rating: 4.8,
      walletBalance: 1875.30,
      monthlyEarnings: 2850.00,
      totalEarnings: 15420.80,
      services: ['Cleaning', 'Organizing'],
      experienceLevel: 'Expert',
      verificationStatus: 'Verified',
      serviceAreas: ['Suburbs South', 'Downtown'],
      completionRate: 96.2,
      reviewsCount: 189,
      certifications: ['Professional Cleaner', 'Eco-Friendly Certified'],
      bankAccount: '****5678',
      taxId: 'TX987654321',
      lastPayment: DateTime.now().subtract(const Duration(days: 14)),
    ),
    M3lmModel(
      id: 'M3L003',
      name: 'David Brown',
      email: 'david.brown@email.com',
      phone: '+1-555-0203',
      location: 'East Side, NY',
      isActive: true,
      isBlocked: false,
      isVerified: true,
      isAvailable: true,
      joinDate: DateTime(2023, 3, 8),
      lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      totalJobs: 98,
      activeJobs: 1,
      completedJobs: 95,
      avatar: 'DB',
      rating: 4.7,
      walletBalance: 3120.45,
      monthlyEarnings: 4100.75,
      totalEarnings: 22340.60,
      services: ['Electrical', 'Smart Home Installation'],
      experienceLevel: 'Expert',
      verificationStatus: 'Verified',
      serviceAreas: ['East Side', 'Industrial District'],
      completionRate: 96.9,
      reviewsCount: 156,
      certifications: ['Certified Electrician', 'Smart Home Specialist'],
      bankAccount: '****9012',
      taxId: 'TX456789123',
      lastPayment: DateTime.now().subtract(const Duration(days: 3)),
    ),
    M3lmModel(
      id: 'M3L004',
      name: 'Emily Garcia',
      email: 'emily.garcia@email.com',
      phone: '+1-555-0204',
      location: 'West Side, NY',
      isActive: true,
      isBlocked: false,
      isVerified: false, // Pending verification
      isAvailable: false,
      joinDate: DateTime(2024, 1, 12),
      lastActive: DateTime.now().subtract(const Duration(hours: 3)),
      totalJobs: 24,
      activeJobs: 0,
      completedJobs: 22,
      avatar: 'EG',
      rating: 4.6,
      walletBalance: 680.20,
      monthlyEarnings: 1200.00,
      totalEarnings: 3450.75,
      services: ['HVAC', 'Air Quality Testing'],
      experienceLevel: 'Intermediate',
      verificationStatus: 'Pending',
      serviceAreas: ['West Side'],
      completionRate: 91.7,
      reviewsCount: 38,
      certifications: ['HVAC Technician'],
      bankAccount: '****3456',
      taxId: 'TX789123456',
    ),
    M3lmModel(
      id: 'M3L005',
      name: 'Alex Rodriguez',
      email: 'alex.rodriguez@email.com',
      phone: '+1-555-0205',
      location: 'Suburbs North, NY',
      isActive: false, // Inactive
      isBlocked: false,
      isVerified: true,
      isAvailable: false,
      joinDate: DateTime(2023, 6, 20),
      lastActive: DateTime.now().subtract(const Duration(days: 5)),
      totalJobs: 67,
      activeJobs: 0,
      completedJobs: 63,
      avatar: 'AR',
      rating: 4.4,
      walletBalance: 245.80,
      monthlyEarnings: 0.00,
      totalEarnings: 8920.40,
      services: ['Painting', 'Interior Design'],
      experienceLevel: 'Intermediate',
      verificationStatus: 'Verified',
      serviceAreas: ['Suburbs North', 'Suburbs South'],
      completionRate: 94.0,
      reviewsCount: 89,
      certifications: ['Professional Painter'],
      bankAccount: '****7890',
      taxId: 'TX321654987',
      lastPayment: DateTime.now().subtract(const Duration(days: 30)),
    ),
    M3lmModel(
      id: 'M3L006',
      name: 'Jessica Chen',
      email: 'jessica.chen@email.com',
      phone: '+1-555-0206',
      location: 'Downtown, NY',
      isActive: true,
      isBlocked: true, // Blocked M3LM
      isVerified: true,
      isAvailable: false,
      joinDate: DateTime(2023, 4, 3),
      lastActive: DateTime.now().subtract(const Duration(days: 10)),
      totalJobs: 89,
      activeJobs: 0,
      completedJobs: 76,
      avatar: 'JC',
      rating: 3.8,
      walletBalance: 0.00,
      monthlyEarnings: 0.00,
      totalEarnings: 7650.30,
      services: ['Gardening', 'Landscaping'],
      experienceLevel: 'Intermediate',
      verificationStatus: 'Verified',
      serviceAreas: ['Downtown'],
      completionRate: 85.4,
      reviewsCount: 98,
      certifications: ['Landscape Designer'],
      bankAccount: '****2468',
      taxId: 'TX654987321',
    ),
    M3lmModel(
      id: 'M3L007',
      name: 'Robert Taylor',
      email: 'robert.taylor@email.com',
      phone: '+1-555-0207',
      location: 'Industrial District, NY',
      isActive: true,
      isBlocked: false,
      isVerified: false, // Recently joined, pending
      isAvailable: true,
      joinDate: DateTime(2024, 1, 28),
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      totalJobs: 8,
      activeJobs: 1,
      completedJobs: 7,
      avatar: 'RT',
      rating: 4.3,
      walletBalance: 145.50,
      monthlyEarnings: 890.25,
      totalEarnings: 890.25,
      services: ['Handyman', 'General Repairs'],
      experienceLevel: 'Beginner',
      verificationStatus: 'Pending',
      serviceAreas: ['Industrial District'],
      completionRate: 87.5,
      reviewsCount: 12,
      certifications: [],
      bankAccount: '****1357',
      taxId: 'TX147258369',
    ),
    M3lmModel(
      id: 'M3L008',
      name: 'Anna Martinez',
      email: 'anna.martinez@email.com',
      phone: '+1-555-0208',
      location: 'Suburbs South, NY',
      isActive: true,
      isBlocked: false,
      isVerified: true,
      isAvailable: true,
      joinDate: DateTime(2023, 5, 18),
      lastActive: DateTime.now().subtract(const Duration(minutes: 45)),
      totalJobs: 156,
      activeJobs: 4,
      completedJobs: 149,
      avatar: 'AM',
      rating: 4.9,
      walletBalance: 3850.90,
      monthlyEarnings: 4200.00,
      totalEarnings: 28750.80,
      services: ['Appliance Repair', 'Electronics'],
      experienceLevel: 'Expert',
      verificationStatus: 'Verified',
      serviceAreas: ['Suburbs South', 'East Side'],
      completionRate: 95.5,
      reviewsCount: 298,
      certifications: ['Electronics Specialist', 'Appliance Certified'],
      bankAccount: '****9753',
      taxId: 'TX258369147',
      lastPayment: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  void _onNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/users');
        break;
      case 2:
        break; // Current screen
      case 3:
        break; // Orders - not yet implemented
      case 4:
        break; // Categories - not yet implemented
      case 5:
        break; // Tracking - not yet implemented
    }
  }

  Future<void> _refreshM3lms() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('M3LMs data refreshed successfully'),
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
      backgroundColor: const Color.fromARGB(255, 29, 41, 57),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: myNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTap,
          profilePictureUrl: null,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshM3lms,
        color: const Color(0xFF3B82F6),
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

                // Statistics Cards Widget
                M3lmStatsCardsWidget(allM3lms: _allM3lms),
                const SizedBox(height: 32),

                // M3LM List Widget
                M3lmListWidget(allM3lms: _allM3lms, onRefresh: _refreshM3lms),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.engineering,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M3LM Management',
                      style: AppFonts.heading1.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage service providers and their performance',
                      style: AppFonts.bodyLarge.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Spacer(),

        // Action Buttons Row
        Row(
          children: [
            // Add New M3LM Button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement add new M3LM functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Add New M3LM feature coming soon!'),
                      backgroundColor: const Color(0xFF3B82F6),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Add New M3LM',
                  style: AppFonts.button.copyWith(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Export Data Button
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: Implement export functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Exporting M3LMs data...'),
                      backgroundColor: const Color(0xFF8B5CF6),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white, size: 18),
                label: Text(
                  'Export Data',
                  style: AppFonts.button.copyWith(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(width: 16),

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _refreshM3lms,
                icon: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, color: Colors.white),
                label: Text(
                  _isLoading ? 'Refreshing...' : 'Refresh Data',
                  style: AppFonts.button.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
