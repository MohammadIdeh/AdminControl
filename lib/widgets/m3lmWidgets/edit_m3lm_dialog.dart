import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';

class EditM3lmDialog extends StatefulWidget {
  final M3lmModel m3lm;
  final VoidCallback onM3lmUpdated;

  const EditM3lmDialog({
    super.key,
    required this.m3lm,
    required this.onM3lmUpdated,
  });

  @override
  State<EditM3lmDialog> createState() => _EditM3lmDialogState();
}

class _EditM3lmDialogState extends State<EditM3lmDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bankAccountController;
  late TextEditingController _taxIdController;

  late String _selectedExperienceLevel;
  late String _selectedVerificationStatus;
  late List<String> _selectedServices;
  late List<String> _selectedServiceAreas;
  late List<String> _selectedCertifications;

  final List<String> _experienceLevels = ['Beginner', 'Intermediate', 'Expert'];
  final List<String> _verificationStatuses = [
    'Pending',
    'Verified',
    'Rejected',
  ];
  final List<String> _availableServices = [
    'Plumbing',
    'Electrical',
    'Cleaning',
    'HVAC',
    'Gardening',
    'Painting',
    'Carpentry',
    'Appliance Repair',
    'Pest Control',
    'Locksmith',
  ];
  final List<String> _availableServiceAreas = [
    'Downtown',
    'Suburbs North',
    'Suburbs South',
    'East Side',
    'West Side',
    'Industrial District',
  ];
  final List<String> _availableCertifications = [
    'Licensed Plumber',
    'Certified Electrician',
    'HVAC Technician',
    'Professional Cleaner',
    'Landscape Designer',
    'Home Inspector',
    'Safety Certified',
    'First Aid Certified',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.m3lm.name);
    _emailController = TextEditingController(text: widget.m3lm.email);
    _phoneController = TextEditingController(text: widget.m3lm.phone);
    _locationController = TextEditingController(text: widget.m3lm.location);
    _bankAccountController = TextEditingController(
      text: widget.m3lm.bankAccount,
    );
    _taxIdController = TextEditingController(text: widget.m3lm.taxId);

    _selectedExperienceLevel = widget.m3lm.experienceLevel;
    _selectedVerificationStatus = widget.m3lm.verificationStatus;
    _selectedServices = List.from(widget.m3lm.services);
    _selectedServiceAreas = List.from(widget.m3lm.serviceAreas);
    _selectedCertifications = List.from(widget.m3lm.certifications);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bankAccountController.dispose();
    _taxIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
        height: 650,
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
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  'Edit M3LM Profile',
                  style: AppFonts.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Basic Information
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Name',
                            _nameController,
                            Icons.person,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Email',
                            _emailController,
                            Icons.email,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Phone',
                            _phoneController,
                            Icons.phone,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Location',
                            _locationController,
                            Icons.location_on,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Professional Information
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Experience Level',
                            _selectedExperienceLevel,
                            _experienceLevels,
                            Icons.trending_up,
                            (value) => setState(
                              () => _selectedExperienceLevel = value!,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            'Verification Status',
                            _selectedVerificationStatus,
                            _verificationStatuses,
                            Icons.verified,
                            (value) => setState(
                              () => _selectedVerificationStatus = value!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Financial Information
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'Bank Account',
                            _bankAccountController,
                            Icons.account_balance,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            'Tax ID',
                            _taxIdController,
                            Icons.receipt_long,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Services Section
                    _buildMultiSelectSection(
                      'Services Offered',
                      _selectedServices,
                      _availableServices,
                      Icons.build,
                      (selected) =>
                          setState(() => _selectedServices = selected),
                    ),
                    const SizedBox(height: 16),

                    // Service Areas Section
                    _buildMultiSelectSection(
                      'Service Areas',
                      _selectedServiceAreas,
                      _availableServiceAreas,
                      Icons.location_city,
                      (selected) =>
                          setState(() => _selectedServiceAreas = selected),
                    ),
                    const SizedBox(height: 16),

                    // Certifications Section
                    _buildMultiSelectSection(
                      'Certifications',
                      _selectedCertifications,
                      _availableCertifications,
                      Icons.workspace_premium,
                      (selected) =>
                          setState(() => _selectedCertifications = selected),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            const SizedBox(height: 24),
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
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Save Changes', style: AppFonts.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: AppFonts.bodyMedium.copyWith(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.bodyMedium.copyWith(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: const Color.fromARGB(255, 29, 41, 57),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    IconData icon,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppFonts.bodyMedium.copyWith(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey[400]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: AppFonts.bodyMedium.copyWith(color: Colors.white),
        dropdownColor: const Color.fromARGB(255, 29, 41, 57),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(
              option,
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildMultiSelectSection(
    String title,
    List<String> selected,
    List<String> available,
    IconData icon,
    ValueChanged<List<String>> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Icon(icon, color: const Color(0xFF3B82F6), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppFonts.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${selected.length} selected',
                style: AppFonts.bodySmall.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: available.map((item) {
              final isSelected = selected.contains(item);
              return GestureDetector(
                onTap: () {
                  final newSelected = List<String>.from(selected);
                  if (isSelected) {
                    newSelected.remove(item);
                  } else {
                    newSelected.add(item);
                  }
                  onChanged(newSelected);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3B82F6).withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3B82F6)
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item,
                        style: AppFonts.bodySmall.copyWith(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : Colors.grey[400],
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.check,
                          size: 12,
                          color: Color(0xFF3B82F6),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    // Validate required fields
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill in all required fields and select at least one service',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    // Update M3LM data
    widget.m3lm.name = _nameController.text.trim();
    widget.m3lm.email = _emailController.text.trim();
    widget.m3lm.phone = _phoneController.text.trim();
    widget.m3lm.location = _locationController.text.trim();
    widget.m3lm.bankAccount = _bankAccountController.text.trim();
    widget.m3lm.taxId = _taxIdController.text.trim();
    widget.m3lm.experienceLevel = _selectedExperienceLevel;
    widget.m3lm.verificationStatus = _selectedVerificationStatus;
    widget.m3lm.services = _selectedServices;
    widget.m3lm.serviceAreas = _selectedServiceAreas;
    widget.m3lm.certifications = _selectedCertifications;

    // Update verification status
    widget.m3lm.isVerified = _selectedVerificationStatus == 'Verified';

    // Call the callback to refresh the parent widget
    widget.onM3lmUpdated();

    // Close dialog
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.m3lm.name} profile updated successfully'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
