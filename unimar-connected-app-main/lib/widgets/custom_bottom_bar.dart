import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bottom navigation bar variants for different user contexts
enum CustomBottomBarVariant {
  /// Standard navigation for regular users
  standard,

  /// Extended navigation for admin users
  admin,

  /// Minimal navigation for authentication flows
  minimal,
}

/// Navigation item data structure
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;
  final bool isAdmin;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
    this.isAdmin = false,
  });
}

/// Production-ready custom bottom navigation bar implementing Adaptive Bottom Navigation
/// with contextual prominence based on user role and current context
class CustomBottomBar extends StatelessWidget {
  /// The variant of the bottom bar to display
  final CustomBottomBarVariant variant;

  /// Currently selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final ValueChanged<int> onTap;

  /// Whether user has admin privileges
  final bool isAdmin;

  /// Background color override
  final Color? backgroundColor;

  /// Selected item color override
  final Color? selectedItemColor;

  /// Unselected item color override
  final Color? unselectedItemColor;

  /// Elevation override
  final double? elevation;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.standard,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  /// Standard navigation items for regular users
  static const List<BottomNavItem> _standardItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-feed',
    ),
    BottomNavItem(
      icon: Icons.qr_code_outlined,
      activeIcon: Icons.qr_code,
      label: 'My Tickets',
      route: '/qr-ticket-display',
    ),
    BottomNavItem(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner,
      label: 'Scan',
      route: '/qr-scanner',
    ),
    BottomNavItem(
      icon: Icons.event_outlined,
      activeIcon: Icons.event,
      label: 'Events',
      route: '/event-details',
    ),
  ];

  /// Extended navigation items for admin users
  static const List<BottomNavItem> _adminItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-feed',
    ),
    BottomNavItem(
      icon: Icons.qr_code_outlined,
      activeIcon: Icons.qr_code,
      label: 'Tickets',
      route: '/qr-ticket-display',
    ),
    BottomNavItem(
      icon: Icons.qr_code_scanner_outlined,
      activeIcon: Icons.qr_code_scanner,
      label: 'Scan',
      route: '/qr-scanner',
    ),
    BottomNavItem(
      icon: Icons.event_outlined,
      activeIcon: Icons.event,
      label: 'Events',
      route: '/event-details',
    ),
    BottomNavItem(
      icon: Icons.admin_panel_settings_outlined,
      activeIcon: Icons.admin_panel_settings,
      label: 'Admin',
      route: '/admin-dashboard',
      isAdmin: true,
    ),
  ];

  /// Minimal navigation items for authentication flows
  static const List<BottomNavItem> _minimalItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home-feed',
    ),
    BottomNavItem(
      icon: Icons.login_outlined,
      activeIcon: Icons.login,
      label: 'Login',
      route: '/login-screen',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final items = _getNavigationItems();

    // Filter admin items if user doesn't have admin privileges
    final filteredItems =
        items.where((item) => !item.isAdmin || isAdmin).toList();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: currentIndex.clamp(0, filteredItems.length - 1),
          onDestinationSelected: (index) {
            HapticFeedback.lightImpact();
            _handleNavigation(context, filteredItems[index], index);
          },
          indicatorColor:
              (selectedItemColor ?? colorScheme.primary).withValues(alpha: 0.2),
          destinations: filteredItems.asMap().entries.map((entry) {
            final item = entry.value;

            return NavigationDestination(
              icon: _buildIcon(
                context,
                item.icon,
                isSelected: false,
                isAdmin: item.isAdmin,
              ),
              selectedIcon: _buildIcon(
                context,
                item.activeIcon ?? item.icon,
                isSelected: true,
                isAdmin: item.isAdmin,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }

  List<BottomNavItem> _getNavigationItems() {
    switch (variant) {
      case CustomBottomBarVariant.standard:
        return _standardItems;
      case CustomBottomBarVariant.admin:
        return _adminItems;
      case CustomBottomBarVariant.minimal:
        return _minimalItems;
    }
  }

  Widget _buildIcon(
    BuildContext context,
    IconData iconData, {
    required bool isSelected,
    required bool isAdmin,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color iconColor;
    if (isSelected) {
      iconColor = selectedItemColor ?? colorScheme.primary;
    } else {
      iconColor = unselectedItemColor ?? colorScheme.onSurfaceVariant;
    }

    // Add special styling for admin items
    if (isAdmin) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isSelected
              ? Border.all(color: iconColor.withValues(alpha: 0.3), width: 1)
              : null,
        ),
        child: Icon(
          iconData,
          size: 24,
          color: iconColor,
        ),
      );
    }

    return Icon(
      iconData,
      size: 24,
      color: iconColor,
    );
  }

  void _handleNavigation(BuildContext context, BottomNavItem item, int index) {
    // Update current index
    onTap(index);

    // Navigate to the selected route
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != item.route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        item.route,
        (route) => false,
      );
    }
  }

  /// Factory constructor for standard user navigation
  factory CustomBottomBar.standard({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      variant: CustomBottomBarVariant.standard,
      currentIndex: currentIndex,
      onTap: onTap,
      isAdmin: false,
    );
  }

  /// Factory constructor for admin user navigation
  factory CustomBottomBar.admin({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      variant: CustomBottomBarVariant.admin,
      currentIndex: currentIndex,
      onTap: onTap,
      isAdmin: true,
    );
  }

  /// Factory constructor for minimal navigation (auth flows)
  factory CustomBottomBar.minimal({
    Key? key,
    required int currentIndex,
    required ValueChanged<int> onTap,
  }) {
    return CustomBottomBar(
      key: key,
      variant: CustomBottomBarVariant.minimal,
      currentIndex: currentIndex,
      onTap: onTap,
      isAdmin: false,
    );
  }

  /// Get the route for a given index
  static String getRouteForIndex(int index, {bool isAdmin = false}) {
    final items = isAdmin ? _adminItems : _standardItems;
    final filteredItems =
        items.where((item) => !item.isAdmin || isAdmin).toList();

    if (index >= 0 && index < filteredItems.length) {
      return filteredItems[index].route;
    }
    return '/home-feed'; // Default fallback
  }

  /// Get the index for a given route
  static int getIndexForRoute(String route, {bool isAdmin = false}) {
    final items = isAdmin ? _adminItems : _standardItems;
    final filteredItems =
        items.where((item) => !item.isAdmin || isAdmin).toList();

    for (int i = 0; i < filteredItems.length; i++) {
      if (filteredItems[i].route == route) {
        return i;
      }
    }
    return 0; // Default to first item
  }
}
