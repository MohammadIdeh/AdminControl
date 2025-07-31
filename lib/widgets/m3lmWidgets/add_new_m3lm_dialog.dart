import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generalWidgets/font.dart';
import 'm3lm_model.dart';

class AddNewM3lmDialog extends StatefulWidget {
  final Function(M3lmModel) onM3lmAdded;

  const AddNewM3lmDialog({super.key, required this.onM3lmAdded});

  @override
  State<AddNewM3lmDialog> createState() => _AddNewM3lmDialogState();
}

class _AddNewM3lmDialogState extends State<AddNewM3lmDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _taxIdController = TextEditingController();

  String _selectedExperienceLevel = 'Beginner';
  List<String> _selectedServices = [];
  List<String> _selectedServiceAreas = [];
  List<String> _selectedCertifications = [];
  bool _isCreating = false;

  final List<String> _experienceLevels = ['Beginner', 'Intermediate', 'Expert'];
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
        width: 800,
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
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
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
                        'Add New M3LM',
                        style: AppFonts.heading2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Create a new service provider profile',
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

            // Form Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Personal Information Section
                      _buildSectionTitle('Personal Information', Icons.person),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Full Name *',
                              _nameController,
                              Icons.person,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Name is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Email Address *',
                              _emailController,
                              Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true)
                                  return 'Email is required';
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value!)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Phone Number *',
                              _phoneController,
                              Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Phone is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              'Location *',
                              _locationController,
                              Icons.location_on,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Location is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Professional Information Section
                      _buildSectionTitle(
                        'Professional Information',
                        Icons.work,
                      ),
                      const SizedBox(height: 16),

                      _buildDropdown(
                        'Experience Level *',
                        _selectedExperienceLevel,
                        _experienceLevels,
                        Icons.trending_up,
                        (value) =>
                            setState(() => _selectedExperienceLevel = value!),
                      ),
                      const SizedBox(height: 20),

                      // Services Section
                      _buildMultiSelectSection(
                        'Services Offered *',
                        _selectedServices,
                        _availableServices,
                        Icons.build,
                        (selected) =>
                            setState(() => _selectedServices = selected),
                        isRequired: true,
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
                      const SizedBox(height: 24),

                      // Financial Information Section
                      _buildSectionTitle(
                        'Financial Information',
                        Icons.account_balance,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              'Bank Account (Last 4 digits)',
                              _bankAccountController,
                              Icons.account_balance,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
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
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isCreating
                        ? null
                        : () => Navigator.of(context).pop(),
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
                    onPressed: _isCreating ? null : _createM3lm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isCreating
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
                        : Text('Create M3LM', style: AppFonts.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppFonts.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Expanded(
          child: Divider(color: Color(0xFF3B82F6), thickness: 1, indent: 16),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
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
    ValueChanged<List<String>> onChanged, {
    bool isRequired = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 41, 57).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRequired && selected.isEmpty
              ? const Color(0xFFEF4444).withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
        ),
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
              if (isRequired)
                Text(
                  ' *',
                  style: AppFonts.bodyMedium.copyWith(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selected.isEmpty
                      ? Colors.grey.withOpacity(0.2)
                      : const Color(0xFF10B981).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selected.length} selected',
                  style: AppFonts.bodySmall.copyWith(
                    color: selected.isEmpty
                        ? Colors.grey[400]
                        : const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (isRequired && selected.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Please select at least one ${title.toLowerCase()}',
              style: AppFonts.bodySmall.copyWith(
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
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
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.check,
                          size: 14,
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

  Future<void> _createM3lm() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate required services
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one service'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Create new M3LM
    final newM3lm = M3lmModel(
      id: 'M3L${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      isActive: true,
      isBlocked: false,
      isVerified: false, // New M3LMs start as unverified
      isAvailable: false,
      joinDate: DateTime.now(),
      lastActive: DateTime.now(),
      totalJobs: 0,
      activeJobs: 0,
      completedJobs: 0,
      avatar: _nameController.text
          .trim()
          .split(' ')
          .map((name) => name[0])
          .join('')
          .toUpperCase(),
      rating: 0.0,
      walletBalance: 0.0,
      monthlyEarnings: 0.0,
      totalEarnings: 0.0,
      services: _selectedServices,
      experienceLevel: _selectedExperienceLevel,
      verificationStatus: 'Pending',
      serviceAreas: _selectedServiceAreas.isNotEmpty
          ? _selectedServiceAreas
          : ['Downtown'],
      completionRate: 0.0,
      reviewsCount: 0,
      certifications: _selectedCertifications,
      bankAccount: _bankAccountController.text.trim().isNotEmpty
          ? '****${_bankAccountController.text.trim()}'
          : '',
      taxId: _taxIdController.text.trim(),
    );

    setState(() {
      _isCreating = false;
    });

    // Call the callback to add the new M3LM
    widget.onM3lmAdded(newM3lm);

    // Close dialog
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newM3lm.name} has been added as a new M3LM'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
