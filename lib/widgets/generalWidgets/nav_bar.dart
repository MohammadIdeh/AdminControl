import 'package:admin_totp_panel/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../generalWidgets/font.dart';

class myNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? profilePictureUrl;

  const myNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.profilePictureUrl,
  }) : super(key: key);

  @override
  State<myNavigationBar> createState() => _myNavigationBarState();
}

class _myNavigationBarState extends State<myNavigationBar>
    with TickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  bool _isMenuOpen = false;
  late AnimationController _profileMenuController;
  late Animation<double> _profileMenuAnimation;

  // Add animation controller for nav items
  late AnimationController _navAnimationController;

  @override
  void initState() {
    super.initState();
    _profileMenuController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _profileMenuAnimation = CurvedAnimation(
      parent: _profileMenuController,
      curve: Curves.easeInOut,
    );

    _navAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _closeMenu();
    _profileMenuController.dispose();
    _navAnimationController.dispose();
    super.dispose();
  }

  void _toggleProfileMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            Positioned(
              right: 40,
              top: 100,
              child: Material(
                color: Colors.transparent,
                child: AnimatedBuilder(
                  animation: _profileMenuAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _profileMenuAnimation.value,
                      alignment: Alignment.topRight,
                      child: Opacity(
                        opacity: _profileMenuAnimation.value,
                        child: _buildProfilePopup(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
      setState(() {
        _isMenuOpen = true;
      });
      _profileMenuController.forward();
    }
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      _profileMenuController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) {
          setState(() {
            _isMenuOpen = false;
          });
        }
      });
    }
  }

  Widget _buildProfilePopup() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 50, 69),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPopupItem(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              _closeMenu();
              // Navigate to profile
            },
          ),
          _buildPopupItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              _closeMenu();
              // Navigate to settings
            },
          ),
          const Divider(color: Color.fromARGB(255, 105, 123, 123)),
          _buildPopupItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              _closeMenu();
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopupItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 105, 123, 123),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppFonts.bodyMedium.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() async {
    try {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      // If logout fails, still try to navigate
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      color: const Color.fromARGB(255, 29, 41, 57),
      padding: const EdgeInsets.only(left: 45, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Logo + Title
          Row(
            children: [
              const Icon(Icons.security, color: Color(0xFF1976D2), size: 35),
              const SizedBox(width: 12),
              Text(
                'M3lm Admin Panel',
                style: AppFonts.heading3.copyWith(color: Colors.white),
              ),
            ],
          ),
          // Middle: Navigation Items
          Row(children: _buildNavItems()),
          // Right side: Profile
          Row(
            children: [
              // Profile + Arrow
              InkWell(
                onTap: _toggleProfileMenu,
                borderRadius: BorderRadius.circular(30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: _isMenuOpen
                        ? const Color.fromARGB(30, 25, 118, 210)
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 36, 50, 69),
                        ),
                        child: widget.profilePictureUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  widget.profilePictureUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      color: Color.fromARGB(255, 105, 123, 123),
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 105, 123, 123),
                              ),
                      ),
                      const SizedBox(width: 2),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 200),
                        turns: _isMenuOpen ? 0.5 : 0,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 35,
                          color: Color.fromARGB(255, 105, 123, 123),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavItems() {
    final List<String> navItems = [
      'Dashboard',
      'Users',
      'M3lms',
      'Orders',
      'Categories',
      'Tracking',
    ];

    final List<IconData> navIcons = [
      Icons.dashboard,
      Icons.people,
      Icons.personal_injury_outlined,
      Icons.bookmark_added_outlined,
      Icons.category,
      Icons.map_outlined,
    ];

    return navItems.asMap().entries.map((entry) {
      final index = entry.key;
      final text = entry.value;
      final bool isSelected = (index == widget.currentIndex);

      return AnimatedNavItem(
        isSelected: isSelected,
        icon: navIcons[index],
        text: text,
        onTap: () => widget.onTap(index),
      );
    }).toList();
  }
}

// Separate widget for animated navigation items
class AnimatedNavItem extends StatefulWidget {
  final bool isSelected;
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const AnimatedNavItem({
    Key? key,
    required this.isSelected,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimation =
        ColorTween(
          begin: const Color.fromARGB(255, 34, 53, 62),
          end: const Color.fromARGB(255, 45, 64, 73),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        if (!widget.isSelected) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        if (!widget.isSelected) {
          _animationController.reverse();
        }
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.isSelected ? 1.0 : _scaleAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(left: 24),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? const Color(0xFF1976D2)
                        : (_isHovered && !widget.isSelected)
                        ? _colorAnimation.value
                        : Colors.transparent,
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.transparent
                          : (_isHovered && !widget.isSelected)
                          ? const Color.fromARGB(255, 25, 118, 210)
                          : const Color.fromARGB(255, 34, 53, 62),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF1976D2).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Icon(
                          widget.icon,
                          size: 24,
                          color: widget.isSelected
                              ? Colors.white
                              : (_isHovered && !widget.isSelected)
                              ? const Color.fromARGB(255, 25, 118, 210)
                              : const Color.fromARGB(255, 105, 123, 123),
                        ),
                      ),
                      const SizedBox(width: 9),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        style: AppFonts.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: widget.isSelected
                              ? Colors.white
                              : (_isHovered && !widget.isSelected)
                              ? const Color.fromARGB(255, 25, 118, 210)
                              : const Color.fromARGB(255, 105, 123, 123),
                        ),
                        child: Text(widget.text),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
