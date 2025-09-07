import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatefulWidget {
  final bool isUserRegistered;
  final bool isEventFull;
  final bool isUserProfessor;
  final VoidCallback onJoinEvent;
  final VoidCallback onLeaveEvent;
  final VoidCallback onJoinWaitlist;
  final VoidCallback onBulkRegister;
  final bool isLoading;

  const ActionButtonsWidget({
    super.key,
    required this.isUserRegistered,
    required this.isEventFull,
    required this.isUserProfessor,
    required this.onJoinEvent,
    required this.onLeaveEvent,
    required this.onJoinWaitlist,
    required this.onBulkRegister,
    this.isLoading = false,
  });

  @override
  State<ActionButtonsWidget> createState() => _ActionButtonsWidgetState();
}

class _ActionButtonsWidgetState extends State<ActionButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppTheme.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isUserProfessor) ...[
              _buildBulkRegisterButton(),
              SizedBox(height: 2.h),
            ],
            _buildPrimaryActionButton(),
            if (widget.isUserRegistered) ...[
              SizedBox(height: 2.h),
              _buildSecondaryActionButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton() {
    String buttonText;
    Color buttonColor;
    VoidCallback? onPressed;
    IconData iconData;

    if (widget.isUserRegistered) {
      buttonText = 'Inscrito no Evento';
      buttonColor = AppTheme.accent;
      onPressed = null; // Disabled when registered
      iconData = Icons.check_circle;
    } else if (widget.isEventFull) {
      buttonText = 'Entrar na Lista de Espera';
      buttonColor = AppTheme.warning;
      onPressed = widget.isLoading ? null : widget.onJoinWaitlist;
      iconData = Icons.schedule;
    } else {
      buttonText = 'Participar do Evento';
      buttonColor = AppTheme.primary;
      onPressed = widget.isLoading ? null : widget.onJoinEvent;
      iconData = Icons.add_circle_outline;
    }

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: widget.isUserRegistered ? 0 : 4,
          shadowColor: AppTheme.shadowDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: iconData.codePoint.toString(),
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    buttonText,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSecondaryActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: OutlinedButton(
        onPressed: widget.isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                _showLeaveConfirmation();
              },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.error,
          side: BorderSide(color: AppTheme.error, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'exit_to_app',
              color: AppTheme.error,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              'Cancelar Inscrição',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 5.h,
      child: OutlinedButton(
        onPressed: widget.isLoading
            ? null
            : () {
                HapticFeedback.lightImpact();
                widget.onBulkRegister();
              },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.secondary,
          side: BorderSide(color: AppTheme.secondary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.secondary,
              size: 18,
            ),
            SizedBox(width: 2.w),
            Text(
              'Inscrição em Grupo',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Cancelar Inscrição',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Tem certeza que deseja cancelar sua inscrição neste evento? Esta ação não pode ser desfeita.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Manter Inscrição',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onLeaveEvent();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Cancelar Inscrição',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
