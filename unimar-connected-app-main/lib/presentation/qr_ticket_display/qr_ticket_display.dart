import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import './widgets/countdown_timer_widget.dart';
import './widgets/emergency_contact_widget.dart';
import './widgets/offline_indicator_widget.dart';
import './widgets/ticket_card_widget.dart';

class QrTicketDisplay extends StatefulWidget {
  const QrTicketDisplay({super.key});

  @override
  State<QrTicketDisplay> createState() => _QrTicketDisplayState();
}

class _QrTicketDisplayState extends State<QrTicketDisplay>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _brightnessController;
  int _currentTicketIndex = 0;
  bool _isOffline = false;
  // Removed unused _originalBrightness

  // Mock ticket data
  final List<Map<String, dynamic>> _ticketData = [
    {
      "ticketId": "UNIMAR2024001",
      "eventName": "Visita Técnica - Empresa TechCorp",
      "departureTime": "08:00",
      "returnTime": "17:30",
      "busNumber": "Ônibus 01",
      "pickupLocation": "Portaria Principal - Campus I",
      "seatNumber": "15",
      "qrCodeUrl":
          "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=UNIMAR2024001",
      "isActive": true,
      "departureDateTime":
          DateTime.now().add(const Duration(hours: 2, minutes: 30)),
    },
    {
      "ticketId": "UNIMAR2024002",
      "eventName": "Congresso de Engenharia Civil",
      "departureTime": "07:30",
      "returnTime": "19:00",
      "busNumber": "Ônibus 02",
      "pickupLocation": "Estacionamento Central",
      "seatNumber": "08",
      "qrCodeUrl":
          "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=UNIMAR2024002",
      "isActive": true,
      "departureDateTime":
          DateTime.now().add(const Duration(days: 1, hours: 5)),
    },
    {
      "ticketId": "UNIMAR2024003",
      "eventName": "Feira de Tecnologia - São Paulo",
      "departureTime": "06:00",
      "returnTime": "22:00",
      "busNumber": "Ônibus 03",
      "pickupLocation": "Portaria Principal - Campus I",
      "seatNumber": null,
      "qrCodeUrl":
          "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=UNIMAR2024003",
      "isActive": false,
      "departureDateTime": DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _brightnessController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _initializeScreen();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _brightnessController.dispose();
    _restoreBrightness();
    super.dispose();
  }

  Future<void> _initializeScreen() async {
    // Get current brightness and increase it for better QR scanning
    try {
      await _increaseBrightness();
    } catch (e) {
      // Handle brightness control errors silently
    }

    // Simulate offline detection
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isOffline = false; // Set to true to test offline mode
      });
    }
  }

  Future<void> _increaseBrightness() async {
    try {
      await _brightnessController.forward();
    } catch (e) {
      // Handle brightness control errors silently
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      await _brightnessController.reverse();
    } catch (e) {
      // Handle brightness control errors silently
    }
  }

  void _shareTicket() {
    final currentTicket = _ticketData[_currentTicketIndex];
    HapticFeedback.lightImpact();

    // Show share options
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildShareBottomSheet(currentTicket),
    );
  }

  Widget _buildShareBottomSheet(Map<String, dynamic> ticket) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            "Compartilhar Ticket",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          _buildShareOption(
            "Compartilhar QR Code",
            "Enviar imagem do QR Code",
            Icons.qr_code,
            () {
              Navigator.pop(context);
              // Handle QR code sharing
            },
          ),
          _buildShareOption(
            "Compartilhar Detalhes",
            "Enviar informações do evento",
            Icons.share,
            () {
              Navigator.pop(context);
              // Handle details sharing
            },
          ),
          _buildShareOption(
            "Código de Participação",
            "Gerar código para outros usuários",
            Icons.group_add,
            () {
              Navigator.pop(context);
              // Handle join code sharing
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildShareOption(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: icon.toString().split('.').last,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.textPrimary,
            size: 24,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Meus Tickets",
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          if (_ticketData[_currentTicketIndex]["isActive"] as bool)
            IconButton(
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.textPrimary,
                size: 24,
              ),
              onPressed: _shareTicket,
            ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.textPrimary,
              size: 24,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              // Handle more options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Offline indicator
              OfflineIndicatorWidget(isOffline: _isOffline),

              // Countdown timer
              CountdownTimerWidget(
                departureTime: _ticketData[_currentTicketIndex]
                    ["departureDateTime"] as DateTime,
                isActive: _ticketData[_currentTicketIndex]["isActive"] as bool,
              ),

              // Ticket carousel (exibe um card por vez, sem scroll interno)
              Column(
                children: [
                  // Page indicators
                  if (_ticketData.length > 1)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _ticketData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 1.w),
                            width: index == _currentTicketIndex ? 8.w : 2.w,
                            height: 1.h,
                            decoration: BoxDecoration(
                              color: index == _currentTicketIndex
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary
                                      .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Ticket cards
                  SizedBox(
                    height: 78.h,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _currentTicketIndex = index;
                        });
                      },
                      itemCount: _ticketData.length,
                      itemBuilder: (context, index) {
                        return TicketCardWidget(
                          ticketData: _ticketData[index],
                          isActive: _ticketData[index]["isActive"] as bool,
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Emergency contact
              const EmergencyContactWidget(),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }
}
