import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

/// Splash screen providing branded app launch experience while initializing core services
/// and determining user navigation path for the university transportation system
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _backgroundAnimation;

  bool _isInitialized = false;
  bool _hasError = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _splashDuration = Duration(seconds: 3);
  static const Duration _timeoutDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    // Background gradient animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _backgroundAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
  }

  Future<void> _initializeApp() async {
    try {
      // Start initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _syncCachedTickets(),
        _prepareOfflineData(),
        Future.delayed(_splashDuration), // Minimum splash duration
      ]).timeout(_timeoutDuration);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
        _handleInitializationError();
      }
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    // Simulate authentication check
    await Future.delayed(const Duration(milliseconds: 800));
    // In real implementation, check stored auth tokens
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
    // In real implementation, load from SharedPreferences
  }

  Future<void> _syncCachedTickets() async {
    // Simulate syncing cached QR tickets
    await Future.delayed(const Duration(milliseconds: 700));
    // In real implementation, sync with local storage
  }

  Future<void> _prepareOfflineData() async {
    // Simulate preparing offline data
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation, cache essential data
  }

  void _handleInitializationError() {
    if (_retryCount < _maxRetries) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _hasError = false;
            _retryCount++;
          });
          _initializeApp();
        }
      });
    } else {
      // Show retry option after max retries
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _showRetryDialog();
        }
      });
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Erro de Conexão',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Não foi possível conectar aos serviços. Verifique sua conexão com a internet e tente novamente.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _hasError = false;
                _retryCount = 0;
              });
              _initializeApp();
            },
            child: Text(
              'Tentar Novamente',
              style: TextStyle(
                color: AppTheme.darkTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    // Navigation logic based on app state
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        // For demo purposes, navigate to login screen
        // In real implementation, check authentication status
        Navigator.pushReplacementNamed(context, '/login-screen');
      }
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hide system status bar for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF8B5CF6), // Magenta
                    const Color(0xFF8B5CF6),
                    _backgroundAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF3B82F6), // Deep blue
                    const Color(0xFF1E40AF),
                    _backgroundAnimation.value,
                  )!,
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Glassmorphism background effects
                  _buildGlassmorphismEffects(),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo section
                        _buildLogoSection(),

                        SizedBox(height: 8.h),

                        // Loading indicator
                        _buildLoadingSection(),
                      ],
                    ),
                  ),

                  // App version at bottom
                  _buildVersionInfo(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassmorphismEffects() {
    return Stack(
      children: [
        // Top-left glass effect
        Positioned(
          top: -10.h,
          left: -15.w,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (_backgroundAnimation.value * 0.4),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Bottom-right glass effect
        Positioned(
          bottom: -15.h,
          right: -20.w,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.6 + (_backgroundAnimation.value * 0.6),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoScaleAnimation, _logoFadeAnimation]),
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Column(
              children: [
                // University/App Logo
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'directions_bus',
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                ),

                SizedBox(height: 3.h),

                // App name
                Text(
                  'UnimarTransport',
                  style: AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 1.h),

                // Subtitle
                Text(
                  'Transporte Universitário',
                  style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        // Loading indicator
        _hasError ? _buildErrorIndicator() : _buildLoadingIndicator(),

        SizedBox(height: 2.h),

        // Status text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _hasError
                ? 'Erro na conexão...'
                : _isInitialized
                    ? 'Pronto!'
                    : 'Carregando...',
            key: ValueKey(_hasError
                ? 'error'
                : _isInitialized
                    ? 'ready'
                    : 'loading'),
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 8.w,
      height: 8.w,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.white.withValues(alpha: 0.8),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.darkTheme.colorScheme.error.withValues(alpha: 0.2),
        border: Border.all(
          color: AppTheme.darkTheme.colorScheme.error,
          width: 2,
        ),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'error_outline',
          color: AppTheme.darkTheme.colorScheme.error,
          size: 4.w,
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Positioned(
      bottom: 4.h,
      left: 0,
      right: 0,
      child: Center(
        child: Text(
          'Versão 1.0.0',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
