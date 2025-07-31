import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';

class VerificationManagementDialog extends StatefulWidget {
  final M3lmModel m3lm;
  final VoidCallback onVerificationUpdated;

  const VerificationManagementDialog({
    super.key,
    required this.m3lm,
    required this.onVerificationUpdated,
  });

  @override
  State<VerificationManagementDialog> createState() =>
      _VerificationManagementDialogState();
}

class _VerificationManagementDialogState
    extends State<VerificationManagementDialog> {
  final TextEditingController _notesController = TextEditingController();
  String _selectedStatus = '';
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.m3lm.verificationStatus;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verification Management',
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Review and update ${widget.m3lm.name}\'s verification status',
                        style: AppFonts.bodyMedium.copyWith(
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // M3LM Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.m3lm.name,
                              style: AppFonts.bodyLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: widget.m3lm.statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.m3lm.statusColor.withOpacity(
                                    0.3,
                                  ),
                                ),
                              ),
                              child: Text(
                                widget.m3lm.verificationStatus,
                                style: AppFonts.bodySmall.copyWith(
                                  color: widget.m3lm.statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.m3lm.services.join(', ')} • ${widget.m3lm.experienceLevel}',
                          style: AppFonts.bodyMedium.copyWith(
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildInfoChip(
                              '${widget.m3lm.totalJobs} Jobs',
                              Icons.work,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              '${widget.m3lm.rating} Rating',
                              Icons.star,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              '${widget.m3lm.completionRate.toStringAsFixed(0)}% Complete',
                              Icons.check_circle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Verification Checklist
            Expanded(
              child: Container(
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
                      'Verification Checklist',
                      style: AppFonts.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildChecklistItem(
                              'Identity Verification',
                              'Government ID verified and matches profile',
                              widget.m3lm.verificationStatus != 'Pending',
                            ),
                            _buildChecklistItem(
                              'Background Check',
                              'Criminal background check completed',
                              widget.m3lm.verificationStatus == 'Verified',
                            ),
                            _buildChecklistItem(
                              'Skill Assessment',
                              'Technical skills verified for ${widget.m3lm.primaryService}',
                              widget.m3lm.totalJobs > 0,
                            ),
                            _buildChecklistItem(
                              'Insurance Coverage',
                              'Liability insurance verified and current',
                              widget.m3lm.verificationStatus == 'Verified',
                            ),
                            _buildChecklistItem(
                              'Certifications',
                              'Professional certifications validated',
                              widget.m3lm.certifications.isNotEmpty,
                            ),
                            _buildChecklistItem(
                              'Bank Account',
                              'Payment details verified for payouts',
                              widget.m3lm.bankAccount.isNotEmpty,
                            ),
                            _buildChecklistItem(
                              'Tax Information',
                              'Tax ID and documentation provided',
                              widget.m3lm.taxId.isNotEmpty,
                            ),
                            _buildChecklistItem(
                              'Trial Period',
                              'Successfully completed trial jobs',
                              widget.m3lm.completedJobs >= 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status Selection
            Container(
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
                    'Update Verification Status',
                    style: AppFonts.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Options
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusOption(
                          'Pending',
                          Icons.schedule,
                          const Color(0xFFF59E0B),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusOption(
                          'Verified',
                          Icons.verified,
                          const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatusOption(
                          'Rejected',
                          Icons.cancel,
                          const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    style: AppFonts.bodyMedium.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Verification Notes (Optional)',
                      labelStyle: AppFonts.bodyMedium.copyWith(
                        color: Colors.grey[400],
                      ),
                      hintText: 'Add notes about the verification decision...',
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
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Cancel', style: AppFonts.button),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isUpdating ||
                            _selectedStatus == widget.m3lm.verificationStatus
                        ? null
                        : _updateVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text('Update Status', style: AppFonts.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF3B82F6), size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppFonts.bodySmall.copyWith(
              color: const Color(0xFF3B82F6),
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(
    String title,
    String description,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? const Color(0xFF10B981).withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted ? Icons.check : Icons.schedule,
              color: isCompleted ? const Color(0xFF10B981) : Colors.grey,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String status, IconData icon, Color color) {
    final isSelected = _selectedStatus == status;

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey[400], size: 24),
            const SizedBox(height: 8),
            Text(
              status,
              style: AppFonts.bodyMedium.copyWith(
                color: isSelected ? color : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateVerification() async {
    setState(() {
      _isUpdating = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Update M3LM verification status
    widget.m3lm.verificationStatus = _selectedStatus;
    widget.m3lm.isVerified = _selectedStatus == 'Verified';

    setState(() {
      _isUpdating = false;
    });

    widget.onVerificationUpdated();
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.m3lm.name}\'s verification status updated to $_selectedStatus',
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
