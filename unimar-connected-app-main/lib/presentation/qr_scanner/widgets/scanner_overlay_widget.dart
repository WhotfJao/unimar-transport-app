import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Scanner overlay widget with animated scanning frame and instructions
class ScannerOverlayWidget extends StatefulWidget {
  final bool isScanning;
  final VoidCallback? onManualEntry;

  const ScannerOverlayWidget({
    super.key,
    required this.isScanning,
    this.onManualEntry,
  });

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanLineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isScanning) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ScannerOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark overlay with transparent scanning area
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withValues(alpha: 0.6),
          child: CustomPaint(
            painter: ScannerOverlayPainter(),
          ),
        ),

        // Scanning frame with corner guides
        Center(
          child: Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Corner guides
                ..._buildCornerGuides(),

                // Animated scan line
                if (widget.isScanning)
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanLineAnimation.value * (70.w - 4),
                        left: 8,
                        right: 8,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.primary,
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),

        // Top instruction text
        Positioned(
          top: 15.h,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Posicione o código QR dentro da moldura',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Bottom manual entry button
        Positioned(
          bottom: 20.h,
          left: 16,
          right: 16,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Mantenha o dispositivo estável para melhor leitura',
                  textAlign: TextAlign.center,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              if (widget.onManualEntry != null)
                ElevatedButton.icon(
                  onPressed: widget.onManualEntry,
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.textPrimary,
                    size: 20,
                  ),
                  label: Text(
                    'Entrada Manual',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surface.withValues(alpha: 0.9),
                    foregroundColor: AppTheme.textPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCornerGuides() {
    const double cornerSize = 20;
    const double cornerThickness = 3;

    return [
      // Top-left corner
      Positioned(
        top: -1,
        left: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.primary, width: cornerThickness),
              left: BorderSide(color: AppTheme.primary, width: cornerThickness),
            ),
          ),
        ),
      ),

      // Top-right corner
      Positioned(
        top: -1,
        right: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.primary, width: cornerThickness),
              right:
                  BorderSide(color: AppTheme.primary, width: cornerThickness),
            ),
          ),
        ),
      ),

      // Bottom-left corner
      Positioned(
        bottom: -1,
        left: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: AppTheme.primary, width: cornerThickness),
              left: BorderSide(color: AppTheme.primary, width: cornerThickness),
            ),
          ),
        ),
      ),

      // Bottom-right corner
      Positioned(
        bottom: -1,
        right: -1,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: AppTheme.primary, width: cornerThickness),
              right:
                  BorderSide(color: AppTheme.primary, width: cornerThickness),
            ),
          ),
        ),
      ),
    ];
  }
}

/// Custom painter for scanner overlay with transparent scanning area
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    final scanAreaSize = size.width * 0.7;
    final scanAreaRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanAreaRect, const Radius.circular(16)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
