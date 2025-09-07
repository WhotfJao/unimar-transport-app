import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab bar variants for different contexts
enum CustomTabBarVariant {
  /// Standard tab bar for general content
  standard,

  /// Segmented control style for binary choices
  segmented,

  /// Scrollable tab bar for many options
  scrollable,

  /// Chip-style tabs for filtering
  chips,
}

/// Tab item data structure
class CustomTabItem {
  final String label;
  final IconData? icon;
  final Widget? customIcon;
  final String? badge;
  final bool isEnabled;

  const CustomTabItem({
    required this.label,
    this.icon,
    this.customIcon,
    this.badge,
    this.isEnabled = true,
  });
}

/// Production-ready custom tab bar implementing Contemporary Spatial Minimalism
/// with smooth state transitions and contextual prominence
class CustomTabBar extends StatelessWidget {
  /// The variant of the tab bar to display
  final CustomTabBarVariant variant;

  /// List of tab items
  final List<CustomTabItem> tabs;

  /// Currently selected index
  final int selectedIndex;

  /// Callback when tab is selected
  final ValueChanged<int> onTabSelected;

  /// Whether tabs are scrollable
  final bool isScrollable;

  /// Background color override
  final Color? backgroundColor;

  /// Selected tab color override
  final Color? selectedColor;

  /// Unselected tab color override
  final Color? unselectedColor;

  /// Indicator color override
  final Color? indicatorColor;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom margin
  final EdgeInsetsGeometry? margin;

  const CustomTabBar({
    super.key,
    this.variant = CustomTabBarVariant.standard,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.isScrollable = false,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomTabBarVariant.standard:
        return _buildStandardTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.scrollable:
        return _buildScrollableTabBar(context, theme, colorScheme);
      case CustomTabBarVariant.chips:
        return _buildChipsTabBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
      ),
      child: TabBar(
        tabs: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          return _buildStandardTab(context, theme, tab, index == selectedIndex);
        }).toList(),
        controller: null, // Will be managed by parent
        isScrollable: isScrollable,
        labelColor: selectedColor ?? colorScheme.primary,
        unselectedLabelColor: unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        onTap: (index) {
          if (tabs[index].isEnabled) {
            HapticFeedback.lightImpact();
            onTabSelected(index);
          }
        },
      ),
    );
  }

  Widget _buildSegmentedTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: _buildSegmentedTab(context, theme, tab, isSelected, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScrollableTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: margin,
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = index == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildScrollableTab(context, theme, tab, isSelected, index),
          );
        },
      ),
    );
  }

  Widget _buildChipsTabBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return _buildChipTab(context, theme, tab, isSelected, index);
        }).toList(),
      ),
    );
  }

  Widget _buildStandardTab(BuildContext context, ThemeData theme,
      CustomTabItem tab, bool isSelected) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null || tab.customIcon != null) ...[
            tab.customIcon ??
                Icon(
                  tab.icon,
                  size: 20,
                ),
            const SizedBox(width: 8),
          ],
          Text(tab.label),
          if (tab.badge != null) ...[
            const SizedBox(width: 8),
            _buildBadge(context, theme, tab.badge!),
          ],
        ],
      ),
    );
  }

  Widget _buildSegmentedTab(BuildContext context, ThemeData theme,
      CustomTabItem tab, bool isSelected, int index) {
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        if (tab.isEnabled) {
          HapticFeedback.lightImpact();
          onTabSelected(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null || tab.customIcon != null) ...[
              tab.customIcon ??
                  Icon(
                    tab.icon,
                    size: 18,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : (unselectedColor ?? colorScheme.onSurfaceVariant),
                  ),
              const SizedBox(width: 6),
            ],
            Text(
              tab.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? colorScheme.onPrimary
                    : (unselectedColor ?? colorScheme.onSurfaceVariant),
                letterSpacing: 0.1,
              ),
            ),
            if (tab.badge != null) ...[
              const SizedBox(width: 6),
              _buildBadge(context, theme, tab.badge!, isSmall: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableTab(BuildContext context, ThemeData theme,
      CustomTabItem tab, bool isSelected, int index) {
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        if (tab.isEnabled) {
          HapticFeedback.lightImpact();
          onTabSelected(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? colorScheme.primary).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(
                  color: selectedColor ?? colorScheme.primary, width: 1)
              : Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null || tab.customIcon != null) ...[
              tab.customIcon ??
                  Icon(
                    tab.icon,
                    size: 18,
                    color: isSelected
                        ? (selectedColor ?? colorScheme.primary)
                        : (unselectedColor ?? colorScheme.onSurfaceVariant),
                  ),
              const SizedBox(width: 8),
            ],
            Text(
              tab.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected
                    ? (selectedColor ?? colorScheme.primary)
                    : (unselectedColor ?? colorScheme.onSurfaceVariant),
                letterSpacing: 0.1,
              ),
            ),
            if (tab.badge != null) ...[
              const SizedBox(width: 8),
              _buildBadge(context, theme, tab.badge!, isSmall: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChipTab(BuildContext context, ThemeData theme, CustomTabItem tab,
      bool isSelected, int index) {
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(tab.label),
      selected: isSelected,
      onSelected: tab.isEnabled
          ? (selected) {
              HapticFeedback.lightImpact();
              onTabSelected(index);
            }
          : null,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      selectedColor:
          (selectedColor ?? colorScheme.primary).withValues(alpha: 0.2),
      checkmarkColor: selectedColor ?? colorScheme.primary,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        color: isSelected
            ? (selectedColor ?? colorScheme.primary)
            : (unselectedColor ?? colorScheme.onSurfaceVariant),
        letterSpacing: 0.1,
      ),
      side: BorderSide(
        color: isSelected
            ? (selectedColor ?? colorScheme.primary)
            : colorScheme.outline.withValues(alpha: 0.2),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      avatar: tab.icon != null || tab.customIcon != null
          ? (tab.customIcon ??
              Icon(
                tab.icon,
                size: 18,
                color: isSelected
                    ? (selectedColor ?? colorScheme.primary)
                    : (unselectedColor ?? colorScheme.onSurfaceVariant),
              ))
          : null,
    );
  }

  Widget _buildBadge(BuildContext context, ThemeData theme, String badge,
      {bool isSmall = false}) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 6 : 8,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.error,
        borderRadius: BorderRadius.circular(isSmall ? 8 : 10),
      ),
      child: Text(
        badge,
        style: GoogleFonts.inter(
          fontSize: isSmall ? 10 : 12,
          fontWeight: FontWeight.w500,
          color: colorScheme.onError,
          letterSpacing: 0,
        ),
      ),
    );
  }

  /// Factory constructor for event categories
  factory CustomTabBar.eventCategories({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
  }) {
    return CustomTabBar(
      key: key,
      variant: CustomTabBarVariant.scrollable,
      tabs: const [
        CustomTabItem(
          label: 'All Events',
          icon: Icons.event_outlined,
        ),
        CustomTabItem(
          label: 'Transportation',
          icon: Icons.directions_bus_outlined,
        ),
        CustomTabItem(
          label: 'Academic',
          icon: Icons.school_outlined,
        ),
        CustomTabItem(
          label: 'Sports',
          icon: Icons.sports_outlined,
        ),
        CustomTabItem(
          label: 'Cultural',
          icon: Icons.theater_comedy_outlined,
        ),
      ],
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
    );
  }

  /// Factory constructor for ticket status filter
  factory CustomTabBar.ticketStatus({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
  }) {
    return CustomTabBar(
      key: key,
      variant: CustomTabBarVariant.segmented,
      tabs: const [
        CustomTabItem(
          label: 'Active',
          icon: Icons.check_circle_outline,
        ),
        CustomTabItem(
          label: 'Used',
          icon: Icons.history,
        ),
        CustomTabItem(
          label: 'Expired',
          icon: Icons.cancel_outlined,
        ),
      ],
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
    );
  }

  /// Factory constructor for admin dashboard sections
  factory CustomTabBar.adminSections({
    Key? key,
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
  }) {
    return CustomTabBar(
      key: key,
      variant: CustomTabBarVariant.standard,
      tabs: const [
        CustomTabItem(
          label: 'Overview',
          icon: Icons.dashboard_outlined,
        ),
        CustomTabItem(
          label: 'Events',
          icon: Icons.event_outlined,
          badge: '12',
        ),
        CustomTabItem(
          label: 'Users',
          icon: Icons.people_outlined,
        ),
        CustomTabItem(
          label: 'Analytics',
          icon: Icons.analytics_outlined,
        ),
      ],
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
      isScrollable: true,
    );
  }
}
