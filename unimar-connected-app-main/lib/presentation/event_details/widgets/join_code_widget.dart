import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JoinCodeWidget extends StatefulWidget {
  final String joinCode;

  const JoinCodeWidget({
    super.key,
    required this.joinCode,
  });

  @override
  State<JoinCodeWidget> createState() => _JoinCodeWidgetState();
}

class _JoinCodeWidgetState extends State<JoinCodeWidget> {
  bool _isCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.joinCode));
    HapticFeedback.lightImpact();

    setState(() {
      _isCopied = true;
    });

    // Reset the copied state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Código de Entrada',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.secondary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.joinCode,
                      style: AppTheme.dataTextStyle(
                        isDark: true,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ).copyWith(
                        color: AppTheme.secondary,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                GestureDetector(
                  onTap: _copyToClipboard,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: _isCopied
                          ? AppTheme.accent.withValues(alpha: 0.2)
                          : AppTheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isCopied
                            ? AppTheme.accent.withValues(alpha: 0.5)
                            : AppTheme.secondary.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: _isCopied ? 'check' : 'content_copy',
                          color:
                              _isCopied ? AppTheme.accent : AppTheme.secondary,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _isCopied ? 'Copiado!' : 'Copiar Código',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: _isCopied
                                ? AppTheme.accent
                                : AppTheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Compartilhe este código com outros estudantes para que possam se inscrever rapidamente no evento.',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
