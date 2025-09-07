import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom app bar variants for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with search functionality
  search,

  /// App bar with back navigation and title
  detail,

  /// App bar for QR scanner with overlay controls
  scanner,

  /// Minimal app bar for authentication screens
  minimal,
}

/// Production-ready custom app bar implementing Contemporary Spatial Minimalism
/// with contextual adaptations for university transportation app
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The variant of the app bar to display
  final CustomAppBarVariant variant;

  /// The title text to display
  final String? title;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// Custom leading widget (overrides default back button)
  final Widget? leading;

  /// List of action widgets to display on the right
  final List<Widget>? actions;

  /// Whether to show the back button automatically
  final bool automaticallyImplyLeading;

  /// Background color override
  final Color? backgroundColor;

  /// Foreground color override
  final Color? foregroundColor;

  /// Elevation override
  final double? elevation;

  /// Search query for search variant
  final String? searchQuery;

  /// Search callback for search variant
  final ValueChanged<String>? onSearchChanged;

  /// Search submit callback
  final ValueChanged<String>? onSearchSubmitted;

  /// Whether search is active (for search variant)
  final bool isSearchActive;

  /// Callback when search is toggled
  final VoidCallback? onSearchToggle;

  const CustomAppBar({
    super.key,
    this.variant = CustomAppBarVariant.standard,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.searchQuery,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.isSearchActive = false,
    this.onSearchToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.standard:
        return _buildStandardAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.detail:
        return _buildDetailAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.scanner:
        return _buildScannerAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: leading ??
          (automaticallyImplyLeading ? _buildLeading(context) : null),
      title: title != null ? _buildTitle(context, theme) : null,
      actions: _buildActions(context, theme),
      centerTitle: false,
      titleSpacing: leading == null && !automaticallyImplyLeading ? 16 : null,
    );
  }

  Widget _buildSearchAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: leading ??
          (automaticallyImplyLeading ? _buildLeading(context) : null),
      title: isSearchActive
          ? _buildSearchField(context, theme)
          : _buildTitle(context, theme),
      actions: _buildSearchActions(context, theme),
      centerTitle: false,
    );
  }

  Widget _buildDetailAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: _buildBackButton(context, theme),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) _buildTitle(context, theme),
          if (subtitle != null) _buildSubtitle(context, theme),
        ],
      ),
      actions: _buildActions(context, theme),
      centerTitle: false,
    );
  }

  Widget _buildScannerAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? theme.colorScheme.onSurface,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: title != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title!,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      actions: actions
          ?.map((action) => Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: action,
              ))
          .toList(),
      centerTitle: true,
    );
  }

  Widget _buildMinimalAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation ?? 0,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: leading,
      title: title != null ? _buildTitle(context, theme) : null,
      actions: _buildActions(context, theme),
      centerTitle: true,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (ModalRoute.of(context)?.canPop == true) {
      return _buildBackButton(context, Theme.of(context));
    }
    return null;
  }

  Widget _buildBackButton(BuildContext context, ThemeData theme) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      tooltip: 'Back',
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Text(
      title!,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        letterSpacing: 0.15,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle(BuildContext context, ThemeData theme) {
    return Text(
      subtitle!,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: (foregroundColor ?? theme.appBarTheme.foregroundColor)
            ?.withValues(alpha: 0.7),
        letterSpacing: 0.25,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme) {
    return TextField(
      autofocus: true,
      controller: TextEditingController(text: searchQuery),
      onChanged: onSearchChanged,
      onSubmitted: onSearchSubmitted,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: theme.appBarTheme.foregroundColor,
      ),
      decoration: InputDecoration(
        hintText: 'Search events, routes...',
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.appBarTheme.foregroundColor?.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  List<Widget>? _buildActions(BuildContext context, ThemeData theme) {
    if (actions != null) {
      return actions!.map((action) {
        if (action is IconButton) {
          return IconButton(
            icon: action.icon,
            onPressed: () {
              HapticFeedback.lightImpact();
              action.onPressed?.call();
            },
            tooltip: action.tooltip,
          );
        }
        return action;
      }).toList();
    }
    return null;
  }

  List<Widget> _buildSearchActions(BuildContext context, ThemeData theme) {
    final defaultActions = <Widget>[
      IconButton(
        icon: Icon(isSearchActive ? Icons.close : Icons.search),
        onPressed: () {
          HapticFeedback.lightImpact();
          onSearchToggle?.call();
        },
        tooltip: isSearchActive ? 'Close search' : 'Search',
      ),
    ];

    if (actions != null && !isSearchActive) {
      return [...actions!, ...defaultActions];
    }
    return defaultActions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Factory constructor for home screen app bar
  factory CustomAppBar.home({
    Key? key,
    VoidCallback? onNotificationTap,
    VoidCallback? onProfileTap,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.standard,
      title: 'Campus Transport',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onNotificationTap,
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: onProfileTap ?? () {},
          tooltip: 'Profile',
        ),
      ],
    );
  }

  /// Factory constructor for QR scanner app bar
  factory CustomAppBar.scanner({
    Key? key,
    String? title,
    VoidCallback? onFlashToggle,
    VoidCallback? onGalleryTap,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.scanner,
      title: title ?? 'Scan QR Code',
      actions: [
        if (onFlashToggle != null)
          IconButton(
            icon: const Icon(Icons.flash_on_outlined, color: Colors.white),
            onPressed: onFlashToggle,
            tooltip: 'Toggle flash',
          ),
        if (onGalleryTap != null)
          IconButton(
            icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
            onPressed: onGalleryTap,
            tooltip: 'Choose from gallery',
          ),
      ],
    );
  }

  /// Factory constructor for event details app bar
  factory CustomAppBar.eventDetails({
    Key? key,
    required String title,
    String? subtitle,
    VoidCallback? onShareTap,
    VoidCallback? onFavoriteTap,
    bool isFavorite = false,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.detail,
      title: title,
      subtitle: subtitle,
      actions: [
        if (onShareTap != null)
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: onShareTap,
            tooltip: 'Share event',
          ),
        if (onFavoriteTap != null)
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: onFavoriteTap,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
      ],
    );
  }

  /// Factory constructor for search app bar
  factory CustomAppBar.search({
    Key? key,
    String? title,
    String? searchQuery,
    ValueChanged<String>? onSearchChanged,
    ValueChanged<String>? onSearchSubmitted,
    bool isSearchActive = false,
    VoidCallback? onSearchToggle,
  }) {
    return CustomAppBar(
      key: key,
      variant: CustomAppBarVariant.search,
      title: title ?? 'Search',
      searchQuery: searchQuery,
      onSearchChanged: onSearchChanged,
      onSearchSubmitted: onSearchSubmitted,
      isSearchActive: isSearchActive,
      onSearchToggle: onSearchToggle,
    );
  }
}
