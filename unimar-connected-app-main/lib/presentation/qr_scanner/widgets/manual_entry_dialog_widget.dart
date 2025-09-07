import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Manual entry dialog for backup validation when QR code is damaged
class ManualEntryDialogWidget extends StatefulWidget {
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  const ManualEntryDialogWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<ManualEntryDialogWidget> createState() =>
      _ManualEntryDialogWidgetState();
}

class _ManualEntryDialogWidgetState extends State<ManualEntryDialogWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Map<String, dynamic>> _filteredParticipants = [];
  String? _selectedParticipant;
  bool _isLoading = false;

  // Mock participant data for demonstration
  final List<Map<String, dynamic>> _mockParticipants = [
    {
      'id': 'USR001',
      'name': 'Ana Silva Santos',
      'email': 'ana.silva@unimar.br',
      'course': 'Engenharia de Software',
      'ticketId': 'TKT-2025-001',
      'eventName': 'Visita Técnica - Google Brasil',
    },
    {
      'id': 'USR002',
      'name': 'Carlos Eduardo Lima',
      'email': 'carlos.lima@unimar.br',
      'course': 'Ciência da Computação',
      'ticketId': 'TKT-2025-002',
      'eventName': 'Visita Técnica - Google Brasil',
    },
    {
      'id': 'USR003',
      'name': 'Mariana Costa Oliveira',
      'email': 'mariana.costa@unimar.br',
      'course': 'Sistemas de Informação',
      'ticketId': 'TKT-2025-003',
      'eventName': 'Visita Técnica - Google Brasil',
    },
    {
      'id': 'USR004',
      'name': 'Pedro Henrique Souza',
      'email': 'pedro.souza@unimar.br',
      'course': 'Engenharia de Software',
      'ticketId': 'TKT-2025-004',
      'eventName': 'Visita Técnica - Google Brasil',
    },
    {
      'id': 'USR005',
      'name': 'Juliana Ferreira Alves',
      'email': 'juliana.alves@unimar.br',
      'course': 'Análise e Desenvolvimento',
      'ticketId': 'TKT-2025-005',
      'eventName': 'Visita Técnica - Google Brasil',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredParticipants = _mockParticipants;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterParticipants(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredParticipants = _mockParticipants;
      } else {
        _filteredParticipants = _mockParticipants.where((participant) {
          final name = (participant['name'] as String).toLowerCase();
          final email = (participant['email'] as String).toLowerCase();
          final course = (participant['course'] as String).toLowerCase();
          final ticketId = (participant['ticketId'] as String).toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              email.contains(searchLower) ||
              course.contains(searchLower) ||
              ticketId.contains(searchLower);
        }).toList();
      }
    });
  }

  void _selectParticipant(Map<String, dynamic> participant) {
    setState(() {
      _selectedParticipant = participant['ticketId'] as String;
    });
  }

  Future<void> _submitManualEntry() async {
    if (_selectedParticipant == null) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate validation process
    await Future.delayed(const Duration(milliseconds: 800));

    HapticFeedback.mediumImpact();
    widget.onSubmit(_selectedParticipant!);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 80.h,
          maxWidth: 90.w,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Entrada Manual',
                      style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      widget.onCancel();
                    },
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textSecondary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _filterParticipants,
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar por nome, email ou código...',
                  hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _filterParticipants('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),

            // Participants list
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxHeight: 40.h),
                child: _filteredParticipants.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredParticipants.length,
                        itemBuilder: (context, index) {
                          final participant = _filteredParticipants[index];
                          final isSelected =
                              _selectedParticipant == participant['ticketId'];

                          return _buildParticipantTile(participant, isSelected);
                        },
                      ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.background.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              HapticFeedback.lightImpact();
                              widget.onCancel();
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppTheme.border),
                      ),
                      child: Text(
                        'Cancelar',
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedParticipant != null && !_isLoading
                          ? _submitManualEntry
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.textPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Confirmar',
                              style: AppTheme.darkTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(
      Map<String, dynamic> participant, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border:
            isSelected ? Border.all(color: AppTheme.primary, width: 1) : null,
      ),
      child: ListTile(
        onTap: () {
          HapticFeedback.lightImpact();
          _selectParticipant(participant);
        },
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
          child: Text(
            (participant['name'] as String)
                .split(' ')
                .map((name) => name[0])
                .take(2)
                .join(),
            style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: Text(
          participant['name'] as String,
          style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              participant['course'] as String,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Ticket: ${participant['ticketId']}',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.primary,
                size: 24,
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum participante encontrado',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente buscar por nome, email ou código do ticket',
              textAlign: TextAlign.center,
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
