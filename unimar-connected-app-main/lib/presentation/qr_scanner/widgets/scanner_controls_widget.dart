import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Scanner controls widget with flashlight, camera flip, and close button
class ScannerControlsWidget extends StatelessWidget {
  final bool isFlashOn;
  final bool canFlipCamera;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onCameraFlip;
  final VoidCallback? onClose;
  final VoidCallback? onGalleryPick;

  const ScannerControlsWidget({
    super.key,
    required this.isFlashOn,
    required this.canFlipCamera,
    this.onFlashToggle,
    this.onCameraFlip,
    this.onClose,
    this.onGalleryPick,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Top controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                _buildControlButton(
                  icon: 'close',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onClose?.call();
                  },
                  tooltip: 'Fechar',
                ),

                // Title
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Escanear QR Code',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Gallery button
                _buildControlButton(
                  icon: 'photo_library',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onGalleryPick?.call();
                  },
                  tooltip: 'Galeria',
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom controls
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Flash toggle
                _buildControlButton(
                  icon: isFlashOn ? 'flash_on' : 'flash_off',
                  onTap: onFlashToggle != null
                      ? () {
                          HapticFeedback.lightImpact();
                          onFlashToggle!();
                        }
                      : null,
                  tooltip: isFlashOn ? 'Desligar Flash' : 'Ligar Flash',
                  isActive: isFlashOn,
                ),

                // Camera flip
                if (canFlipCamera)
                  _buildControlButton(
                    icon: 'flip_camera_ios',
                    onTap: onCameraFlip != null
                        ? () {
                            HapticFeedback.lightImpact();
                            onCameraFlip!();
                          }
                        : null,
                    tooltip: 'Trocar Câmera',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    VoidCallback? onTap,
    String? tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary.withValues(alpha: 0.8)
                : Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border:
                isActive ? Border.all(color: AppTheme.primary, width: 2) : null,
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
