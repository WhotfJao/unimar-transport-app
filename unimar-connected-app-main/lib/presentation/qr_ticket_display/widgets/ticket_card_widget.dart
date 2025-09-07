import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class TicketCardWidget extends StatelessWidget {
  final Map<String, dynamic> ticketData;
  final bool isActive;

  const TicketCardWidget({
    super.key,
    required this.ticketData,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context); // no uso direto aqui
    // final colorScheme = theme.colorScheme; // not used

    return Container(
      width: 85.w,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.textSecondary.withValues(alpha: 0.3),
                  AppTheme.textSecondary.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            _buildTicketHeader(),
            _buildQRCodeSection(),
            _buildTicketDetails(),
            _buildTicketFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (ticketData["eventName"] as String?) ??
                      "Evento Universitário",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.accent.withValues(alpha: 0.2)
                        : AppTheme.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isActive ? AppTheme.accent : AppTheme.textSecondary,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isActive ? "ATIVO" : "EXPIRADO",
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isActive ? AppTheme.accent : AppTheme.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'directions_bus',
              color: AppTheme.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Container(
        width: 72.w,
        height: 72.w,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isActive
            ? CustomImageWidget(
                imageUrl: (ticketData["qrCodeUrl"] as String?) ??
                    "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${Uri.encodeComponent((ticketData["ticketId"] as String?) ?? "TICKET123")}",
                fit: BoxFit.contain,
              )
            : Container(
                decoration: BoxDecoration(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'qr_code',
                    color: AppTheme.textSecondary,
                    size: 48,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTicketDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildDetailRow(
            "Horário de Saída",
            (ticketData["departureTime"] as String?) ?? "08:00",
            Icons.schedule,
          ),
          SizedBox(height: 1.h),
          _buildDetailRow(
            "Horário de Retorno",
            (ticketData["returnTime"] as String?) ?? "18:00",
            Icons.schedule,
          ),
          SizedBox(height: 1.h),
          _buildDetailRow(
            "Ônibus",
            (ticketData["busNumber"] as String?) ?? "Ônibus 01",
            Icons.directions_bus,
          ),
          SizedBox(height: 1.h),
          _buildDetailRow(
            "Local de Embarque",
            (ticketData["pickupLocation"] as String?) ?? "Portaria Principal",
            Icons.location_on,
          ),
          if (ticketData["seatNumber"] != null) ...[
            SizedBox(height: 1.h),
            _buildDetailRow(
              "Assento",
              (ticketData["seatNumber"] as String?) ?? "15",
              Icons.airline_seat_recline_normal,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: AppTheme.textSecondary,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTicketFooter() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ID do Ticket",
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                (ticketData["ticketId"] as String?) ?? "UNIMAR2024001",
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          if (isActive)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.textPrimary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    "Compartilhar",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
