
import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'order_model.dart';

class OrderDetailsDialog extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onOrderUpdated;

  const OrderDetailsDialog({
    super.key,
    required this.order,
    required this.onOrderUpdated,
  });

  @override
  State<OrderDetailsDialog> createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  void _trackOrder() {
    // This would open the tracking interface
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening live tracking for order ${widget.order.id}...'),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _contactCustomer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${widget.order.customerName}...'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _contactM3lm() {
    if (widget.order.m3lmName != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling ${widget.order.m3lmName}...'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _showLocationOnMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening location on map: ${widget.order.customerAddress}'),
        backgroundColor: const Color(0xFF8B5CF6),
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
        width: 1100,
        height: 800,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getServiceColor(widget.order.serviceType).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getServiceColor(widget.order.serviceType).withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    widget.order.serviceIcon,
                    color: _getServiceColor(widget.order.serviceType),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Order ${widget.order.id}',
                            style: AppFonts.heading2.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildStatusChip(widget.order.status),
                          if (widget.order.isUrgent || widget.order.priority == 'urgent') ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.3)),
                              ),
                              child: Text(
                                'URGENT',
                                style: AppFonts.bodySmall.copyWith(
                                  color: const Color(0xFFEF4444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.order.serviceDisplayName} Service',
                        style: AppFonts.bodyMedium.copyWith(
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.order.canBeTracked)
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ElevatedButton.icon(
                      onPressed: _trackOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.location_on, size: 16),
                      label: Text('Track Order', style: AppFonts.button),
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
                  // Left Column: Order Details and Customer Info
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 3, child: _buildOrderDetailsSection()),
                        const SizedBox(height: 16),
                        Expanded(flex: 2, child: _buildCustomerSection()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Middle Column: M3LM and Payment Info
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 2, child: _buildM3lmSection()),
                        const SizedBox(height: 16),
                        Expanded(flex: 3, child: _buildPaymentSection()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Right Column: Timeline and Location
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(flex: 3, child: _buildTimelineSection()),
                        const SizedBox(height: 16),
                        Expanded(flex: 2, child: _buildLocationSection()),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsSection() {
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
              const Icon(Icons.receipt_long, color: Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                'Order Details',
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
                  _buildDetailRow('Order ID', widget.order.id),
                  _buildDetailRow('Service Type', widget.order.serviceDisplayName),
                  _buildDetailRow('Description', widget.order.serviceDescription),
                  _buildDetailRow('Priority', widget.order.priority.toUpperCase()),
                  _buildDetailRow('Estimated Duration', widget.order.formattedDuration),
                  _buildDetailRow('Created', _formatDateTime(widget.order.createdAt)),
                  if (widget.order.scheduledAt != null)
                    _buildDetailRow('Scheduled', _formatDateTime(widget.order.scheduledAt!)),
                  if (widget.order.startedAt != null)
                    _buildDetailRow('Started', _formatDateTime(widget.order.startedAt!)),
                  if (widget.order.completedAt != null)
                    _buildDetailRow('Completed', _formatDateTime(widget.order.completedAt!)),
                  if (widget.order.cancelledAt != null)
                    _buildDetailRow('Cancelled', _formatDateTime(widget.order.cancelledAt!)),
                  if (widget.order.cancellationReason != null)
                    _buildDetailRow('Cancellation Reason', widget.order.cancellationReason!),
                  if (widget.order.notes.isNotEmpty)
                    _buildDetailRow('Notes', widget.order.notes),
                  if (widget.order.rating != null)
                    _buildDetailRow('Rating', '${widget.order.rating!}/5.0'),
                  if (widget.order.review != null)
                    _buildDetailRow('Review', widget.order.review!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
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
              const Icon(Icons.person, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 8),
              Text(
                'Customer Information',
                style: AppFonts.heading3.copyWith(
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
                Row(
                  children: [
                    CircateAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF10B981),
                      child: Text(
                        widget.order.customerName[0].toUpperCase(),
                        style: AppFonts.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.order.customerName,
                            style: AppFonts.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.order.customerId,
                            style: AppFonts.bodySmall.copyWith(
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Email', widget.order.customerEmail),
                _buildDetailRow('Phone', widget.order.customerPhone),
                _buildDetailRow('Address', widget.order.customerAddress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildM3lmSection() {
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
              const Icon(Icons.engineering, color: Color(0xFF8B5CF6), size: 20),
              const SizedBox(width: 8),
              Text(
                'Service Provider (M3LM)',
                style: AppFonts.heading3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.order.m3lmName != null
                ? Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF8B5CF6),
                            child: Text(
                              widget.order.m3lmAvatar ?? '?',
                              style: AppFonts.bodyMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.order.m3lmName!,
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  widget.order.m3lmId ?? 'Unknown ID',
                                  style: AppFonts.bodySmall.copyWith(
                                    color: const Color(0xFF3B82F6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (widget.order.m3lmPhone != null)
                        _buildDetailRow('Phone', widget.order.m3lmPhone!),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _contactM3lm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.phone, size: 16),
                          label: Text('Contact M3LM', style: AppFonts.button),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          color: Colors.grey[400],
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No M3LM Assigned',
                          style: AppFonts.bodyMedium.copyWith(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Order is pending assignment',
                          style: AppFonts.bodySmall.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.order.isPaid ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
            widget.order.isPaid
                ? const Color(0xFF059669)
                : const Color(0xFFD97706),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: (widget.order.isPaid
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF59E0B))
                .withOpacity(0.3),
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
              const Icon(Icons.payment, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Payment Information',
                style: AppFonts.heading3.copyWith(
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
                // Payment Status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.order.isPaid ? 'PAID' : 'UNPAID',
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Payment Status',
                        style: AppFonts.bodySmall.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Breakdown
                _buildPaymentRow('Service Amount', '\$${widget.order.price.toStringAsFixed(2)}'),
                _buildPaymentRow('Platform Fee', '\$${widget.order.platformFee.toStringAsFixed(2)}'),
                if (widget.order.discount > 0)
                  _buildPaymentRow('Discount', '-\$${widget.order.discount.toStringAsFixed(2)}'),
                const Divider(color: Colors.white24),
                _buildPaymentRow(
                  'Total Amount',
                  '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                _buildPaymentRow('Payment Method', widget.order.paymentMethod),
                if (widget.order.promoCode != null)
                  _buildPaymentRow('Promo Code', widget.order.promoCode!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
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
              const Icon(Icons.timeline, color: Color(0xFFF59E0B), size: 20),
              const SizedBox(width: 8),
              Text(
                'Order Timeline',
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
                  _buildTimelineItem(
                    'Order Created',
                    widget.order.createdAt,
                    true,
                    Icons.add_circle_outline,
                  ),
                  if (widget.order.status.index >= OrderStatus.assigned.index)
                    _buildTimelineItem(
                      'M3LM Assigned',
                      widget.order.scheduledAt ?? widget.order.createdAt.add(const Duration(minutes: 15)),
                      true,
                      Icons.person_add,
                    ),
                  if (widget.order.status.index >= OrderStatus.inProgress.index)
                    _buildTimelineItem(
                      'Service Started',
                      widget.order.startedAt ?? DateTime.now().subtract(const Duration(hours: 1)),
                      true,
                      Icons.play_arrow,
                    ),
                  if (widget.order.status == OrderStatus.completed)
                    _buildTimelineItem(
                      'Service Completed',
                      widget.order.completedAt ?? DateTime.now(),
                      true,
                      Icons.check_circle,
                    ),
                  if (widget.order.status == OrderStatus.cancelled)
                    _buildTimelineItem(
                      'Order Cancelled',
                      widget.order.cancelledAt ?? DateTime.now(),
                      true,
                      Icons.cancel,
                    ),
                  if (widget.order.status != OrderStatus.completed && widget.order.status != OrderStatus.cancelled)
                    _buildTimelineItem(
                      'Service Completion',
                      widget.order.scheduledAt?.add(Duration(minutes: widget.order.estimatedDuration)) ?? 
                          DateTime.now().add(const Duration(hours: 2)),
                      false,
                      Icons.flag,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
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
              const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 20),
              const SizedBox(width: 8),
              Text(
                'Location Details',
                style: AppFonts.heading3.copyWith(
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 41, 57),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Address',
                        style: AppFonts.bodySmall.copyWith(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.order.customerAddress,
                        style: AppFonts.bodySmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow('Area', widget.order.location),
                _buildDetailRow('Coordinates', '${widget.order.latitude.toStringAsFixed(4)}, ${widget.order.longitude.toStringAsFixed(4)}'),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showLocationOnMap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.map, size: 16),
                    label: Text('View on Map', style: AppFonts.button),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Contact Customer
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _contactCustomer,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.phone, size: 16),
            label: Text('Contact Customer', style: AppFonts.button),
          ),
        ),
        const SizedBox(width: 16),

        // Track Order (if applicable)
        if (widget.order.canBeTracked)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _trackOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.location_on, size: 16),
              label: Text('Live Tracking', style: AppFonts.button),
            ),
          ),
        if (widget.order.canBeTracked) const SizedBox(width: 16),

        // More Actions
        ElevatedButton.icon(
          onPressed: () {
            // Show more actions
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          icon: const Icon(Icons.more_horiz, size: 16),
          label: Text('More Actions', style: AppFonts.button),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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

  Widget _buildPaymentRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppFonts.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: AppFonts.bodySmall.copyWith(
              color: Colors.white,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime dateTime, bool isCompleted, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isCompleted ? const Color(0xFF10B981) : Colors.grey[600],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.bodySmall.copyWith(
                    color: isCompleted ? Colors.white : Colors.grey[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formatDateTime(dateTime),
                  style: AppFonts.bodySmall.copyWith(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    switch (status) {
      case OrderStatus.pending:
        color = const Color(0xFFF59E0B);
        break;
      case OrderStatus.assigned:
        color = const Color(0xFF8B5CF6);
        break;
      case OrderStatus.inProgress:
        color = const Color(0xFF3B82F6);
        break;
      case OrderStatus.completed:
        color = const Color(0xFF10B981);
        break;
      case OrderStatus.cancelled:
        color = const Color(0xFFEF4444);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: AppFonts.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getServiceColor(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.plumbing:
        return const Color(0xFF3B82F6);
      case ServiceType.electrical:
        return const Color(0xFFF59E0B);
      case ServiceType.cleaning:
        return const Color(0xFF10B981);
      case ServiceType.hvac:
        return const Color(0xFF8B5CF6);
      case ServiceType.gardening:
        return const Color(0xFFEF4444);
      case ServiceType.painting:
        return const Color(0xFF06B6D4);
      case ServiceType.carpentry:
        return const Color(0xFF84CC16);
      case ServiceType.appliance:
        return const Color(0xFFEC4899);
      case ServiceType.pest:
        return const Color(0xFFF97316);
      case ServiceType.locksmith:
        return const Color(0xFF6366F1);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}