import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ForgotPasswordWidget extends StatelessWidget {
  final VoidCallback onForgotPassword;

  const ForgotPasswordWidget({
    super.key,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onForgotPassword();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 1.h,
          ),
          child: Text(
            'Esqueceu a senha?',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.primary,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ),
    );
  }
}