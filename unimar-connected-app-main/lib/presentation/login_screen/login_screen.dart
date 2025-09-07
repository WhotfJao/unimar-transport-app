import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/forgot_password_widget.dart';
import './widgets/institution_selector_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  String? _selectedInstitution;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    "student": {
      "email": "aluno@unimar.br",
      "password": "Aluno123!",
      "role": "student"
    },
    "professor": {
      "email": "professor@unimar.br",
      "password": "Prof123!",
      "role": "professor"
    },
    "admin": {
      "email": "admin@unimar.br",
      "password": "Admin123!",
      "role": "admin"
    }
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(String email, String password) async {
    if (_selectedInstitution == null) {
      _showErrorMessage('Por favor, selecione uma instituição');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    bool isValidCredentials = false;
    String userRole = 'student';

    for (final credentials in _mockCredentials.values) {
      if (credentials['email'] == email &&
          credentials['password'] == password) {
        isValidCredentials = true;
        userRole = credentials['role']!;
        break;
      }
    }

    setState(() {
      _isLoading = false;
    });

    if (isValidCredentials) {
      HapticFeedback.heavyImpact();
      _showSuccessMessage('Login realizado com sucesso!');

      // Navigate to home screen after success message
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('just_logged_in', true);
        } catch (_) {}
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-feed',
          (route) => false,
        );
      }
    } else {
      HapticFeedback.heavyImpact();
      _showErrorMessage('Credenciais inválidas. Verifique email e senha.');
    }
  }

  void _handleForgotPassword() {
    _showInfoMessage(
        'Link de recuperação será enviado para seu email institucional');
  }

  void _handleRegister() {
    _showInfoMessage('Funcionalidade de registro em desenvolvimento');
  }

  void _showErrorMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: AppTheme.error,
      textColor: AppTheme.textPrimary,
      fontSize: 14.sp,
    );
  }

  void _showSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: AppTheme.accent,
      textColor: AppTheme.textPrimary,
      fontSize: 14.sp,
    );
  }

  void _showInfoMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.secondary,
      textColor: AppTheme.textPrimary,
      fontSize: 14.sp,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.background,
              AppTheme.background.withValues(alpha: 0.8),
              AppTheme.surface.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // App Logo
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const AppLogoWidget(),
                    ),

                    SizedBox(height: 4.h),

                    // Main Login Card
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppTheme.surface.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.border.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.shadowDark,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Welcome Text
                              Text(
                                'Bem-vindo de volta',
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: 0.15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Faça login para acessar o sistema de transporte',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textSecondary,
                                  letterSpacing: 0.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4.h),

                              // Institution Selector
                              InstitutionSelectorWidget(
                                onInstitutionSelected: (institution) {
                                  setState(() {
                                    _selectedInstitution = institution;
                                  });
                                },
                                selectedInstitution: _selectedInstitution,
                                isEnabled: !_isLoading,
                              ),
                              SizedBox(height: 3.h),

                              // Login Form
                              LoginFormWidget(
                                onLogin: _handleLogin,
                                isLoading: _isLoading,
                              ),
                              SizedBox(height: 2.h),

                              // Forgot Password Link
                              ForgotPasswordWidget(
                                onForgotPassword: _handleForgotPassword,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Register Link
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: RegisterLinkWidget(
                        onRegister: _handleRegister,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Mock Credentials Info
                    if (!_isLoading)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.secondary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'info',
                                    color: AppTheme.secondary,
                                    size: 16,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Credenciais de Teste',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Aluno: aluno@unimar.br / Aluno123!\nProfessor: professor@unimar.br / Prof123!\nAdmin: admin@unimar.br / Admin123!',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppTheme.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
