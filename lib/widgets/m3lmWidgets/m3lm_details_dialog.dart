import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';

class M3lmDetailsDialog extends StatefulWidget {
  final M3lmModel m3lm;
  final VoidCallback onM3lmUpdated;

  const M3lmDetailsDialog({
    super.key,
    required this.m3lm,
    required this.onM3lmUpdated,
  });

  @override
  State<M3lmDetailsDialog> createState() => _M3lmDetailsDialogState();
}

class _M3lmDetailsDialogState extends State<M3lmDetailsDialog> {
  final TextEditingController _earningsController = TextEditingController();
  bool _isUpdatingWallet = false;

  @override
  void dispose() {
    _earningsController.dispose();
    super.dispose();
  }

  void _showJobDetails(Map<String, dynamic> job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 36, 50, 69),
          title: Text(
            'Job ${job['id']}',
            style: AppFonts.heading3.copyWith(color: Colors.white),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Service', job['service']),
                _buildDetailRow('Customer', job['customer']),
                _buildDetailRow('Amount', job['amount']),
                _buildDetailRow('Status', job['status']),
                _buildDetailRow('Date', job['date']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: AppFonts.button.copyWith(color: const Color(0xFF3B82F6)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEarningsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(24),
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
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Manage Earnings',
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Current Earnings Display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      29,
                      41,
                      57,
                    ).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${widget.m3lm.walletBalance.toStringAsFixed(2)}',
                                style: AppFonts.heading2.copyWith(
                                  color: const Color(0xFF10B981),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Earnings',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${widget.m3lm.totalEarnings.toStringAsFixed(2)}',
                                style: AppFonts.heading3.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'This Month: \$${widget.m3lm.monthlyEarnings.toStringAsFixed(2)}',
                            style: AppFonts.bodySmall.copyWith(
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            'Avg/Job: \$${widget.m3lm.averageJobValue.toStringAsFixed(2)}',
                            style: AppFonts.bodySmall.copyWith(
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Payment Actions
                TextField(
                  controller: _earningsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount (\$)',
                    labelStyle: AppFonts.bodyMedium.copyWith(
                      color: Colors.grey[400],
                    ),
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF10B981),
                    ),
                    hintText: '0.00',
                    hintStyle: AppFonts.bodyMedium.copyWith(
                      color: Colors.grey[500],
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 29, 41, 57),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUpdatingWallet
                            ? null
                            : () => _updateEarnings(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: _isUpdatingWallet
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
                            : const Icon(Icons.payment, size: 16),
                        label: Text('Pay Out', style: AppFonts.button),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUpdatingWallet
                            ? null
                            : () => _updateEarnings(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: _isUpdatingWallet
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
                            : const Icon(Icons.add, size: 16),
                        label: Text('Add Bonus', style: AppFonts.button),
                      ),
                    ),
                  ],
                ),

                // Quick amounts
                const SizedBox(height: 16),
                Text(
                  'Quick Actions',
                  style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [50, 100, 250, 500].map((amount) {
                    return GestureDetector(
                      onTap: () => _earningsController.text = amount.toString(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '\$$amount',
                          style: AppFonts.bodySmall.copyWith(
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateEarnings(bool isBonus) async {
    final amountText = _earningsController.text.trim();
    if (amountText.isEmpty) {
      _showSnackBar('Please enter an amount', Colors.red);
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showSnackBar('Please enter a valid amount', Colors.red);
      return;
    }

    setState(() {
      _isUpdatingWallet = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (isBonus) {
        widget.m3lm.walletBalance += amount;
        widget.m3lm.totalEarnings += amount;
        widget.m3lm.monthlyEarnings += amount;
      } else {
        // Pay out from wallet
        if (widget.m3lm.walletBalance >= amount) {
          widget.m3lm.walletBalance -= amount;
          widget.m3lm.lastPayment = DateTime.now();
        } else {
          _showSnackBar('Insufficient wallet balance', Colors.red);
          _isUpdatingWallet = false;
          return;
        }
      }
      _isUpdatingWallet = false;
    });

    widget.onM3lmUpdated();
    Navigator.of(context).pop();

    _showSnackBar(
      isBonus
          ? '\$${amount.toStringAsFixed(2)} bonus added to ${widget.m3lm.name}\'s account'
          : '\$${amount.toStringAsFixed(2)} paid out to ${widget.m3lm.name}',
      Colors.green,
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 1000,
        height: 750,
        padding: const EdgeInsets.all(24),
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
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: widget.m3lm.statusColor,
                      child: Text(
                        widget.m3lm.avatar,
                        style: AppFonts.heading3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (widget.m3lm.isVerified)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 36, 50, 69),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.m3lm.name,
                            style: AppFonts.heading2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getExperienceLevelColor(
                                widget.m3lm.experienceLevel,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getExperienceLevelColor(
                                  widget.m3lm.experienceLevel,
                                ).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              widget.m3lm.experienceLevel,
                              style: AppFonts.bodySmall.copyWith(
                                color: _getExperienceLevelColor(
                                  widget.m3lm.experienceLevel,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'M3LM ID: ${widget.m3lm.id}',
                        style: AppFonts.bodyMedium.copyWith(
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      Text(
                        widget.m3lm.primaryService,
                        style: AppFonts.bodySmall.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Details and Services
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 2, child: _buildM3lmDetailsSection()),
                        const SizedBox(height: 16),
                        Expanded(flex: 1, child: _buildServicesSection()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Middle Column: Earnings and Performance
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: _buildEarningsSection()),
                        const SizedBox(height: 16),
                        Expanded(flex: 1, child: _buildPerformanceSection()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Right Column: Job History
                  Expanded(flex: 1, child: _buildJobHistorySection()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildM3lmDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'M3LM Details',
                style: AppFonts.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDetailRow('Email', widget.m3lm.email),
                  _buildDetailRow('Phone', widget.m3lm.phone),
                  _buildDetailRow('Location', widget.m3lm.location),
                  _buildDetailRow('Total Jobs', '${widget.m3lm.totalJobs}'),
                  _buildDetailRow(
                    'Completed Jobs',
                    '${widget.m3lm.completedJobs}',
                  ),
                  _buildDetailRow('Active Jobs', '${widget.m3lm.activeJobs}'),
                  _buildDetailRow(
                    'Rating',
                    '${widget.m3lm.rating}/5.0 (${widget.m3lm.reviewsCount} reviews)',
                  ),
                  _buildDetailRow(
                    'Completion Rate',
                    '${widget.m3lm.completionRate.toStringAsFixed(1)}%',
                  ),
                  _buildDetailRow(
                    'Join Date',
                    _formatDate(widget.m3lm.joinDate),
                  ),
                  _buildDetailRow(
                    'Last Active',
                    _formatDate(widget.m3lm.lastActive),
                  ),
                  _buildDetailRow('Status', widget.m3lm.statusText),
                  _buildDetailRow(
                    'Bank Account',
                    widget.m3lm.bankAccount.isNotEmpty
                        ? '****${widget.m3lm.bankAccount.substring(widget.m3lm.bankAccount.length - 4)}'
                        : 'Not provided',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.build_outlined,
                color: Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Services & Areas',
                style: AppFonts.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Services
          Text(
            'Services Offered:',
            style: AppFonts.bodySmall.copyWith(
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.m3lm.services
                .map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getServiceColor(service).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getServiceColor(service).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      service,
                      style: AppFonts.bodySmall.copyWith(
                        color: _getServiceColor(service),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  );
                })
                .take(6)
                .toList(), // Limit to 6 services to fit in space
          ),

          const SizedBox(height: 12),

          // Service Areas
          Text(
            'Service Areas:',
            style: AppFonts.bodySmall.copyWith(
              color: Colors.grey[400],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: widget.m3lm.serviceAreas
                .map((area) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      area,
                      style: AppFonts.bodySmall.copyWith(
                        color: const Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  );
                })
                .take(4)
                .toList(), // Limit to 4 areas
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Earnings Overview',
                style: AppFonts.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Wallet Balance
          Text(
            'Wallet Balance',
            style: AppFonts.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            '\$${widget.m3lm.walletBalance.toStringAsFixed(2)}',
            style: AppFonts.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 12),

          // Other earnings info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Month',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '\$${widget.m3lm.monthlyEarnings.toStringAsFixed(2)}',
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Earned',
                    style: AppFonts.bodySmall.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    '\$${widget.m3lm.totalEarnings.toStringAsFixed(2)}',
                    style: AppFonts.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showEarningsDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.payment, size: 16),
              label: Text('Manage Earnings', style: AppFonts.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_outlined,
                color: Color(0xFFF59E0B),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Performance Metrics',
                style: AppFonts.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: Column(
              children: [
                _buildPerformanceItem(
                  'Rating',
                  '${widget.m3lm.rating}',
                  '/5.0',
                  const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 12),
                _buildPerformanceItem(
                  'Completion',
                  '${widget.m3lm.completionRate.toStringAsFixed(1)}',
                  '%',
                  const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildPerformanceItem(
                  'Avg Job Value',
                  '\$${widget.m3lm.averageJobValue.toStringAsFixed(0)}',
                  '',
                  const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _buildPerformanceItem(
                  'Reviews',
                  '${widget.m3lm.reviewsCount}',
                  ' total',
                  const Color(0xFF8B5CF6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(
    String label,
    String value,
    String suffix,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: AppFonts.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: suffix,
                style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJobHistorySection() {
    // Mock job data
    final jobs = [
      {
        'id': 'JOB001',
        'service': 'Plumbing',
        'customer': 'John Smith',
        'status': 'Completed',
        'amount': '\$150',
        'date': '2024-01-15',
      },
      {
        'id': 'JOB002',
        'service': 'Electrical',
        'customer': 'Sarah Wilson',
        'status': 'In Progress',
        'amount': '\$275',
        'date': '2024-01-20',
      },
      {
        'id': 'JOB003',
        'service': 'Plumbing',
        'customer': 'Mike Davis',
        'status': 'Completed',
        'amount': '\$85',
        'date': '2024-01-22',
      },
      {
        'id': 'JOB004',
        'service': 'HVAC',
        'customer': 'Lisa Anderson',
        'status': 'Pending',
        'amount': '\$420',
        'date': '2024-01-25',
      },
      {
        'id': 'JOB005',
        'service': 'Plumbing',
        'customer': 'Robert Chen',
        'status': 'Completed',
        'amount': '\$95',
        'date': '2024-01-28',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.work_history_outlined,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Job History',
                style: AppFonts.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${jobs.length} jobs',
                style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return InkWell(
                  onTap: () => _showJobDetails(job),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 29, 41, 57),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _getServiceColor(
                                  job['service'],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                _getServiceIcon(job['service']),
                                color: _getServiceColor(job['service']),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        job['id']!,
                                        style: AppFonts.bodySmall.copyWith(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        job['amount']!,
                                        style: AppFonts.bodySmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${job['service']} for ${job['customer']}',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildJobStatusChip(job['status']!),
                            Text(
                              job['date']!,
                              style: AppFonts.bodySmall.copyWith(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppFonts.bodySmall.copyWith(
                color: Colors.grey[400],
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodySmall.copyWith(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Completed':
        color = const Color(0xFF10B981);
        break;
      case 'In Progress':
        color = const Color(0xFF3B82F6);
        break;
      case 'Pending':
        color = const Color(0xFFF59E0B);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: AppFonts.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 9,
        ),
      ),
    );
  }

  Color _getServiceColor(String? service) {
    switch (service) {
      case 'Plumbing':
        return const Color(0xFF3B82F6);
      case 'Electrical':
        return const Color(0xFFF59E0B);
      case 'Cleaning':
        return const Color(0xFF10B981);
      case 'HVAC':
        return const Color(0xFF8B5CF6);
      case 'Gardening':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  IconData _getServiceIcon(String? service) {
    switch (service) {
      case 'Plumbing':
        return Icons.plumbing;
      case 'Electrical':
        return Icons.electrical_services;
      case 'Cleaning':
        return Icons.cleaning_services;
      case 'HVAC':
        return Icons.ac_unit;
      case 'Gardening':
        return Icons.grass;
      default:
        return Icons.build;
    }
  }

  Color _getExperienceLevelColor(String level) {
    switch (level) {
      case 'Expert':
        return const Color(0xFF10B981);
      case 'Intermediate':
        return const Color(0xFF3B82F6);
      case 'Beginner':
        return const Color(0xFFF59E0B);
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
