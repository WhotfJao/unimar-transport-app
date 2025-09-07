import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialCharacters =
        RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final hasMinLength = password.length >= 8;

    setState(() {
      _isPasswordValid = hasUppercase &&
          hasLowercase &&
          hasNumbers &&
          hasSpecialCharacters &&
          hasMinLength;
    });
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() == true &&
        _isEmailValid &&
        _isPasswordValid) {
      HapticFeedback.lightImpact();
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isEmailValid
                    ? AppTheme.accent
                    : (_emailController.text.isNotEmpty && !_isEmailValid)
                        ? AppTheme.error
                        : AppTheme.border,
                width: _isEmailValid ? 2 : 1,
              ),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              enabled: !widget.isLoading,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Email institucional',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'email',
                    color: _isEmailValid
                        ? AppTheme.accent
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: _emailController.text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: _isEmailValid ? 'check_circle' : 'error',
                          color:
                              _isEmailValid ? AppTheme.accent : AppTheme.error,
                          size: 20,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email é obrigatório';
                }
                if (!_isEmailValid) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 2.h),

          // Password Field
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isPasswordValid
                    ? AppTheme.accent
                    : (_passwordController.text.isNotEmpty && !_isPasswordValid)
                        ? AppTheme.error
                        : AppTheme.border,
                width: _isPasswordValid ? 2 : 1,
              ),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              textInputAction: TextInputAction.done,
              enabled: !widget.isLoading,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Senha',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary.withValues(alpha: 0.7),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'lock',
                    color: _isPasswordValid
                        ? AppTheme.accent
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_passwordController.text.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 1.w),
                        child: CustomIconWidget(
                          iconName: _isPasswordValid ? 'check_circle' : 'error',
                          color: _isPasswordValid
                              ? AppTheme.accent
                              : AppTheme.error,
                          size: 20,
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Senha é obrigatória';
                }
                if (!_isPasswordValid) {
                  return 'Senha deve conter maiúscula, minúscula, número e símbolo';
                }
                return null;
              },
              onFieldSubmitted: (_) => _handleLogin(),
            ),
          ),
          SizedBox(height: 1.h),

          // Password Requirements
          if (_passwordController.text.isNotEmpty && !_isPasswordValid)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A senha deve conter:',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.error,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  _buildPasswordRequirement('Pelo menos 8 caracteres',
                      _passwordController.text.length >= 8),
                  _buildPasswordRequirement('Uma letra maiúscula',
                      RegExp(r'[A-Z]').hasMatch(_passwordController.text)),
                  _buildPasswordRequirement('Uma letra minúscula',
                      RegExp(r'[a-z]').hasMatch(_passwordController.text)),
                  _buildPasswordRequirement('Um número',
                      RegExp(r'[0-9]').hasMatch(_passwordController.text)),
                  _buildPasswordRequirement(
                      'Um símbolo especial',
                      RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                          .hasMatch(_passwordController.text)),
                ],
              ),
            ),
          SizedBox(height: 2.h),

          // Login Button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6.h,
            decoration: BoxDecoration(
              gradient: (_isEmailValid && _isPasswordValid && !widget.isLoading)
                  ? LinearGradient(
                      colors: [
                        AppTheme.primary,
                        AppTheme.primary.withValues(alpha: 0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: (!_isEmailValid || !_isPasswordValid || widget.isLoading)
                  ? AppTheme.textSecondary.withValues(alpha: 0.3)
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow:
                  (_isEmailValid && _isPasswordValid && !widget.isLoading)
                      ? [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (_isEmailValid && _isPasswordValid && !widget.isLoading)
                    ? _handleLogin
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.textPrimary),
                          ),
                        )
                      : Text(
                          'Entrar',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: (_isEmailValid && _isPasswordValid)
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                            letterSpacing: 0.15,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.2.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isMet ? 'check' : 'close',
            color: isMet ? AppTheme.accent : AppTheme.error,
            size: 12,
          ),
          SizedBox(width: 2.w),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: isMet ? AppTheme.accent : AppTheme.error,
            ),
          ),
        ],
      ),
    );
  }
}