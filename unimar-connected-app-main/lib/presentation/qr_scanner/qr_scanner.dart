import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/manual_entry_dialog_widget.dart';
import './widgets/scan_result_widget.dart';
import './widgets/scanner_controls_widget.dart';
import './widgets/scanner_overlay_widget.dart';

/// QR Scanner screen for ticket validation by bus staff and validators
class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;
  bool _isScanning = true;
  bool _showManualEntry = false;
  bool _showScanResult = false;
  String? _scanResult;
  Map<String, dynamic>? _scanResultData;
  bool _scanSuccess = false;
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';

  // Mock QR code data for demonstration
  final Map<String, Map<String, dynamic>> _mockQrData = {
    'TKT-2025-001': {
      'ticketId': 'TKT-2025-001',
      'participantName': 'Ana Silva Santos',
      'eventName': 'Visita Técnica - Google Brasil',
      'eventDate': '15/01/2025',
      'eventTime': '08:00 - 18:00',
      'status': 'valid',
      'course': 'Engenharia de Software',
    },
    'TKT-2025-002': {
      'ticketId': 'TKT-2025-002',
      'participantName': 'Carlos Eduardo Lima',
      'eventName': 'Visita Técnica - Google Brasil',
      'eventDate': '15/01/2025',
      'eventTime': '08:00 - 18:00',
      'status': 'used',
      'course': 'Ciência da Computação',
    },
    'TKT-2025-003': {
      'ticketId': 'TKT-2025-003',
      'participantName': 'Mariana Costa Oliveira',
      'eventName': 'Visita Técnica - Google Brasil',
      'eventDate': '15/01/2025',
      'eventTime': '08:00 - 18:00',
      'status': 'expired',
      'course': 'Sistemas de Informação',
    },
  };

  // Mock registered students list
  final List<Map<String, String>> _registeredStudents = [
    {
      'name': 'Ana Silva Santos',
      'course': 'Engenharia de Software',
      'ticketId': 'TKT-2025-001'
    },
    {
      'name': 'Carlos Eduardo Lima',
      'course': 'Ciência da Computação',
      'ticketId': 'TKT-2025-002'
    },
    {
      'name': 'Mariana Costa Oliveira',
      'course': 'Sistemas de Informação',
      'ticketId': 'TKT-2025-003'
    },
    {
      'name': 'João Pedro Alves',
      'course': 'Engenharia Civil',
      'ticketId': 'TKT-2025-004'
    },
    {
      'name': 'Beatriz Nunes',
      'course': 'Engenharia Elétrica',
      'ticketId': 'TKT-2025-005'
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final permissionStatus = await Permission.camera.request();
      if (!permissionStatus.isGranted) {
        _showPermissionDeniedDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      // Initialize camera controller with back camera
      final backCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Set camera settings
      await _cameraController!.setFocusMode(FocusMode.auto);
      await _cameraController!.setFlashMode(FlashMode.off);

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }

      // Start simulated QR scanning
      _startQrScanning();
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  void _startQrScanning() {
    if (!_isScanning) return;

    // Simulate QR code detection every 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (_isScanning && mounted) {
        // Simulate finding a QR code
        _simulateQrDetection();
      }
    });
  }

  void _simulateQrDetection() {
    // Simulate random QR code detection
    final qrCodes = _mockQrData.keys.toList();
    final randomCode = qrCodes[DateTime.now().millisecond % qrCodes.length];
    _processQrCode(randomCode);
  }

  void _processQrCode(String qrData) {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
    });

    // Validate QR code
    final ticketData = _mockQrData[qrData];
    if (ticketData != null) {
      final status = ticketData['status'] as String;

      setState(() {
        _scanSuccess = status == 'valid';
        _scanResultData = ticketData;
        _showScanResult = true;

        if (status == 'valid') {
          _scanResult = 'Ticket validado com sucesso!\nBem-vindo(a) ao evento.';
        } else if (status == 'used') {
          _scanResult =
              'Este ticket já foi utilizado.\nVerifique com o organizador.';
        } else if (status == 'expired') {
          _scanResult = 'Ticket expirado.\nEntre em contato com o suporte.';
        }
      });
    } else {
      setState(() {
        _scanSuccess = false;
        _scanResult =
            'QR Code inválido.\nVerifique o código e tente novamente.';
        _showScanResult = true;
      });
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      await _cameraController!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      debugPrint('Flash toggle error: $e');
      setState(() {
        _isFlashOn = false;
      });
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;

    try {
      final currentCamera = _cameraController!.description;
      final newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentCamera.lensDirection,
        orElse: () => currentCamera,
      );

      await _cameraController!.dispose();

      _cameraController = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFocusMode(FocusMode.auto);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Camera flip error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        // Simulate QR code processing from gallery image
        await Future.delayed(const Duration(milliseconds: 500));

        // For demo, randomly select a QR code
        final qrCodes = _mockQrData.keys.toList();
        final randomCode = qrCodes[DateTime.now().millisecond % qrCodes.length];
        _processQrCode(randomCode);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _showManualEntryDialog() {
    setState(() {
      _showManualEntry = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ManualEntryDialogWidget(
        onSubmit: (ticketId) {
          Navigator.of(context).pop();
          _processQrCode(ticketId);
          setState(() {
            _showManualEntry = false;
          });
        },
        onCancel: () {
          Navigator.of(context).pop();
          setState(() {
            _showManualEntry = false;
            _isScanning = true;
          });
          _startQrScanning();
        },
      ),
    );
  }

  void _handleScanResultContinue() {
    setState(() {
      _showScanResult = false;
      _isScanning = true;
      _scanResult = null;
      _scanResultData = null;
    });
    _startQrScanning();
  }

  void _handleScanResultRetry() {
    _showManualEntryDialog();
  }

  void _closeScanner() {
    Navigator.of(context).pop();
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Permissão Necessária',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Para escanear QR codes, precisamos acessar a câmera do seu dispositivo.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _closeScanner();
            },
            child: Text(
              'Cancelar',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(
              'Configurações',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Câmera Não Disponível',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Não foi possível encontrar uma câmera no dispositivo.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _closeScanner();
            },
            child: Text(
              'OK',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text(
          'Erro na Câmera',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Ocorreu um erro ao inicializar a câmera. Tente novamente.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _closeScanner();
            },
            child: Text(
              'Cancelar',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeCamera();
            },
            child: Text(
              'Tentar Novamente',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // TOP: Scanner ocupa 2/3 da tela
          Expanded(
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_isCameraInitialized && _cameraController != null)
                  CameraPreview(_cameraController!)
                else
                  Container(
                    color: AppTheme.background,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Inicializando câmera...',
                            style: AppTheme.darkTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isCameraInitialized && !_showScanResult)
                  ScannerOverlayWidget(
                    isScanning: _isScanning && !_showManualEntry,
                    onManualEntry: _showManualEntryDialog,
                  ),
                if (_isCameraInitialized && !_showScanResult)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: ScannerControlsWidget(
                        isFlashOn: _isFlashOn,
                        canFlipCamera: _cameras.length > 1,
                        onFlashToggle: _toggleFlash,
                        onCameraFlip: _flipCamera,
                        onClose: _closeScanner,
                        onGalleryPick: _pickFromGallery,
                      ),
                    ),
                  ),
                if (_showScanResult && _scanResult != null)
                  ScanResultWidget(
                    isSuccess: _scanSuccess,
                    message: _scanResult!,
                    ticketData: _scanResultData,
                    onContinue: _handleScanResultContinue,
                    onRetry: _handleScanResultRetry,
                  ),
              ],
            ),
          ),

          // BOTTOM: Pesquisa + lista (1/3 da tela)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface.withValues(alpha: 0.6),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border.all(
                    color: AppTheme.border.withValues(alpha: 0.3), width: 1),
              ),
              child: Stack(
                children: [
                  // Lista
                  Padding(
                    padding: EdgeInsets.only(top: 7.h, left: 4.w, right: 4.w),
                    child: _buildStudentList(),
                  ),

                  // Caixa de pesquisa flutuante
                  Positioned(
                    left: 4.w,
                    right: 4.w,
                    top: 2.h,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      color: AppTheme.surface,
                      child: TextField(
                        controller: _searchCtrl,
                        onChanged: (v) => setState(
                            () => _searchQuery = v.trim().toLowerCase()),
                        decoration: InputDecoration(
                          hintText: 'Buscar aluno ou ticket...',
                          prefixIcon:
                              Icon(Icons.search, color: AppTheme.textSecondary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear,
                                      color: AppTheme.textSecondary),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final filtered = _registeredStudents.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s['name']!.toLowerCase().contains(_searchQuery) ||
          s['ticketId']!.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Nenhum aluno encontrado',
          style: AppTheme.darkTheme.textTheme.bodyMedium
              ?.copyWith(color: AppTheme.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) =>
          Divider(color: AppTheme.border.withValues(alpha: 0.2)),
      itemBuilder: (context, index) {
        final s = filtered[index];
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w),
          leading: CircleAvatar(
            backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
            child: Icon(Icons.person, color: AppTheme.primary),
          ),
          title: Text(s['name']!,
              style: AppTheme.darkTheme.textTheme.bodyLarge
                  ?.copyWith(color: AppTheme.textPrimary)),
          subtitle: Text('${s['course']}  •  ${s['ticketId']}',
              style: AppTheme.darkTheme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.textSecondary)),
          trailing: Icon(Icons.qr_code_2, color: AppTheme.textSecondary),
          onTap: () => _processQrCode(s['ticketId']!),
        );
      },
    );
  }
}
