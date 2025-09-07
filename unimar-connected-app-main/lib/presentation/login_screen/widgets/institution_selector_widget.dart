import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class InstitutionSelectorWidget extends StatefulWidget {
  final Function(String institution) onInstitutionSelected;
  final String? selectedInstitution;
  final bool isEnabled;

  const InstitutionSelectorWidget({
    super.key,
    required this.onInstitutionSelected,
    this.selectedInstitution,
    this.isEnabled = true,
  });

  @override
  State<InstitutionSelectorWidget> createState() =>
      _InstitutionSelectorWidgetState();
}

class _InstitutionSelectorWidgetState extends State<InstitutionSelectorWidget> {
  final List<Map<String, dynamic>> institutions = [
    {
      "id": "unimar",
      "name": "Universidade de Marília",
      "shortName": "UNIMAR",
      "logo":
          "https://images.unsplash.com/photo-1562774053-701939374585?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "city": "Marília, SP",
    },
    {
      "id": "usp",
      "name": "Universidade de São Paulo",
      "shortName": "USP",
      "logo":
          "https://images.unsplash.com/photo-1541339907198-e08756dedf3f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "city": "São Paulo, SP",
    },
    {
      "id": "unicamp",
      "name": "Universidade Estadual de Campinas",
      "shortName": "UNICAMP",
      "logo":
          "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "city": "Campinas, SP",
    },
    {
      "id": "unesp",
      "name": "Universidade Estadual Paulista",
      "shortName": "UNESP",
      "logo":
          "https://images.unsplash.com/photo-1607237138185-eedd9c632b0b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "city": "São Paulo, SP",
    },
  ];

  bool _isExpanded = false;

  void _toggleDropdown() {
    if (widget.isEnabled) {
      HapticFeedback.lightImpact();
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  void _selectInstitution(Map<String, dynamic> institution) {
    HapticFeedback.lightImpact();
    widget.onInstitutionSelected(institution["id"] as String);
    setState(() {
      _isExpanded = false;
    });
  }

  Map<String, dynamic>? get _selectedInstitutionData {
    if (widget.selectedInstitution == null) return null;
    return institutions.firstWhere(
      (inst) => (inst["id"] as String) == widget.selectedInstitution,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Selecione sua instituição',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        SizedBox(height: 1.h),

        // Main Selector
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isExpanded ? AppTheme.primary : AppTheme.border,
              width: _isExpanded ? 2 : 1,
            ),
            boxShadow: _isExpanded
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleDropdown,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Row(
                  children: [
                    // Institution Logo/Icon
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedInstitutionData != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl:
                                    _selectedInstitutionData!["logo"] as String,
                                width: 10.w,
                                height: 10.w,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CustomIconWidget(
                              iconName: 'school',
                              color: AppTheme.primary,
                              size: 24,
                            ),
                    ),
                    SizedBox(width: 3.w),

                    // Institution Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedInstitutionData != null
                                ? (_selectedInstitutionData!["shortName"]
                                    as String)
                                : 'Selecionar instituição',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: _selectedInstitutionData != null
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                          if (_selectedInstitutionData != null)
                            Text(
                              _selectedInstitutionData!["city"] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Dropdown Arrow
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: widget.isEnabled
                            ? AppTheme.textSecondary
                            : AppTheme.textSecondary.withValues(alpha: 0.5),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Dropdown List
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _isExpanded ? (institutions.length * 8.h) : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isExpanded ? 1.0 : 0.0,
            child: Container(
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: institutions.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: AppTheme.border.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final institution = institutions[index];
                    final isSelected = widget.selectedInstitution ==
                        (institution["id"] as String);

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _selectInstitution(institution),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              // Institution Logo
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CustomImageWidget(
                                    imageUrl: institution["logo"] as String,
                                    width: 8.w,
                                    height: 8.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),

                              // Institution Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      institution["shortName"] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? AppTheme.primary
                                            : AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      institution["city"] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Selection Indicator
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color: AppTheme.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}