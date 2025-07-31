import 'package:admin_totp_panel/widgets/userWidgets/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generalWidgets/font.dart';

// You'll need to import the order details dialog
// import 'order_details_dialog.dart';

class UserDetailsDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onUserUpdated;

  const UserDetailsDialog({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  final TextEditingController _pointsController = TextEditingController();
  bool _isUpdatingWallet = false;

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // You'll need to uncomment this when you add the order_details_dialog.dart file
        // return OrderDetailsDialog(order: order);

        // Temporary placeholder - replace with OrderDetailsDialog
        return AlertDialog(
          title: Text('Order ${order['id']}'),
          content: Text('Order details will be shown here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showWalletDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400,
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
                          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
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
                        'Manage Wallet',
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

                // Current Balance
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
                      Text(
                        'Current Balance',
                        style: AppFonts.bodyMedium.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${widget.user.walletBalance.toStringAsFixed(2)}',
                        style: AppFonts.heading1.copyWith(
                          color: const Color(0xFF10B981),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Amount Input
                TextField(
                  controller: _pointsController,
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
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUpdatingWallet
                            ? null
                            : () => _updateWallet(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
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
                            : const Icon(Icons.remove, size: 16),
                        label: Text('Remove', style: AppFonts.button),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUpdatingWallet
                            ? null
                            : () => _updateWallet(true),
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
                            : const Icon(Icons.add, size: 16),
                        label: Text('Add', style: AppFonts.button),
                      ),
                    ),
                  ],
                ),

                // Quick Actions
                const SizedBox(height: 16),
                Text(
                  'Quick Actions',
                  style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [10, 25, 50, 100].map((amount) {
                    return GestureDetector(
                      onTap: () => _pointsController.text = amount.toString(),
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

  void _updateWallet(bool isAddition) async {
    final amountText = _pointsController.text.trim();
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (isAddition) {
        widget.user.walletBalance += amount;
      } else {
        widget.user.walletBalance = (widget.user.walletBalance - amount).clamp(
          0.0,
          double.infinity,
        );
      }
      _isUpdatingWallet = false;
    });

    widget.onUserUpdated();
    Navigator.of(context).pop(); // Close wallet dialog

    _showSnackBar(
      isAddition
          ? '\$${amount.toStringAsFixed(2)} added to ${widget.user.name}\'s wallet'
          : '\$${amount.toStringAsFixed(2)} removed from ${widget.user.name}\'s wallet',
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
        width: 900,
        height: 700,
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
                CircleAvatar(
                  radius: 30,
                  backgroundColor: widget.user.isBlocked
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
                  child: Text(
                    widget.user.avatar,
                    style: AppFonts.heading3.copyWith(
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
                        widget.user.name,
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'User ID: ${widget.user.id}',
                        style: AppFonts.bodyMedium.copyWith(
                          color: const Color(0xFF3B82F6),
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
                  // User Details and Wallet
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildUserDetailsSection(),
                        const SizedBox(height: 16),
                        _buildWalletSection(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Orders History
                  Expanded(flex: 1, child: _buildOrdersSection()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsSection() {
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
          Text(
            'User Details',
            style: AppFonts.heading3.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Email', widget.user.email),
          _buildDetailRow('Phone', widget.user.phone),
          _buildDetailRow('Location', widget.user.location),
          _buildDetailRow('Total Orders', '${widget.user.totalOrders}'),
          _buildDetailRow('Active Orders', '${widget.user.activeOrders}'),
          _buildDetailRow('Rating', '${widget.user.rating}/5.0'),
          _buildDetailRow('Join Date', _formatDate(widget.user.joinDate)),
          _buildDetailRow('Last Active', _formatDate(widget.user.lastActive)),
          _buildDetailRow(
            'Status',
            widget.user.isBlocked
                ? 'Blocked'
                : (widget.user.isActive ? 'Active' : 'Inactive'),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
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
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Wallet Balance',
                style: AppFonts.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '\$${widget.user.walletBalance.toStringAsFixed(2)}',
            style: AppFonts.heading1.copyWith(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showWalletDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.edit, size: 16),
              label: Text('Manage Wallet', style: AppFonts.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersSection() {
    // Mock orders data
    final orders = [
      {
        'id': 'ORD001',
        'service': 'Plumbing',
        'status': 'Completed',
        'amount': '\$150',
        'date': '2024-01-15',
      },
      {
        'id': 'ORD002',
        'service': 'Electrical',
        'status': 'In Progress',
        'amount': '\$275',
        'date': '2024-01-20',
      },
      {
        'id': 'ORD003',
        'service': 'Cleaning',
        'status': 'Completed',
        'amount': '\$85',
        'date': '2024-01-22',
      },
      {
        'id': 'ORD004',
        'service': 'HVAC',
        'status': 'Pending',
        'amount': '\$420',
        'date': '2024-01-25',
      },
      {
        'id': 'ORD005',
        'service': 'Gardening',
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
                Icons.receipt_long,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Order History',
                style: AppFonts.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${orders.length} orders',
                style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return InkWell(
                  onTap: () => _showOrderDetails(order),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
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
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getServiceColor(
                                  order['service'],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getServiceIcon(order['service']),
                                color: _getServiceColor(order['service']),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        order['id']!,
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: const Color(0xFF3B82F6),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        order['amount']!,
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['service']!,
                                    style: AppFonts.bodySmall.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildOrderStatusChip(order['status']!),
                            Text(
                              order['date']!,
                              style: AppFonts.bodySmall.copyWith(
                                color: Colors.grey[400],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppFonts.bodySmall.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusChip(String status) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
