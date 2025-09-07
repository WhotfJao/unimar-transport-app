import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime departureTime;
  final bool isActive;

  const CountdownTimerWidget({
    super.key,
    required this.departureTime,
    this.isActive = true,
  });

  @override
  State<CountdownTimerWidget> createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;
  Color _urgencyColor = AppTheme.accent;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    if (widget.isActive) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeRemaining();
    });
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    final difference = widget.departureTime.difference(now);

    setState(() {
      _timeRemaining = difference.isNegative ? Duration.zero : difference;
      _urgencyColor = _getUrgencyColor(_timeRemaining);
    });

    if (_timeRemaining == Duration.zero) {
      _timer?.cancel();
    }
  }

  Color _getUrgencyColor(Duration timeRemaining) {
    final hours = timeRemaining.inHours;
    if (hours <= 1) {
      return AppTheme.error; // Red for urgent (1 hour or less)
    } else if (hours <= 3) {
      return AppTheme.warning; // Yellow for moderate urgency (3 hours or less)
    } else {
      return AppTheme.accent; // Green for safe (more than 3 hours)
    }
  }

  String _formatTimeRemaining(Duration duration) {
    if (duration == Duration.zero) {
      return "Partiu!";
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m";
    } else if (hours > 0) {
      return "${hours}h ${minutes}m ${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${seconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return _buildExpiredTimer();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _urgencyColor.withValues(alpha: 0.2),
            _urgencyColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _urgencyColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: _urgencyColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'schedule',
                  color: _urgencyColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                _timeRemaining == Duration.zero
                    ? "Embarque Liberado"
                    : "Tempo para Embarque",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _formatTimeRemaining(_timeRemaining),
            style: GoogleFonts.jetBrainsMono(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: _urgencyColor,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Saída às ${widget.departureTime.hour.toString().padLeft(2, '0')}:${widget.departureTime.minute.toString().padLeft(2, '0')}",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredTimer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.textSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                "Ticket Expirado",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            "FINALIZADO",
            style: GoogleFonts.jetBrainsMono(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textSecondary,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Evento realizado em ${widget.departureTime.day.toString().padLeft(2, '0')}/${widget.departureTime.month.toString().padLeft(2, '0')}/${widget.departureTime.year}",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}