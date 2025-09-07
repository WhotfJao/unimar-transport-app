import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:sizer/sizer.dart";

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/comments_section_widget.dart';
import './widgets/event_header_widget.dart';
import './widgets/event_info_card_widget.dart';
import './widgets/join_code_widget.dart';
import './widgets/mini_map_widget.dart';
import './widgets/participants_list_widget.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  bool _isFavorite = false;
  bool _isUserRegistered = false;
  bool _isLoading = false;
  final bool _isUserProfessor = true; // Mock user role

  // Mock event data
  final Map<String, dynamic> _eventData = {
    "id": 1,
    "title": "Visita Técnica - Fábrica de Tecnologia Sustentável",
    "organizer": "Prof. Dr. Maria Santos",
    "description": """Uma oportunidade única de conhecer as mais modernas tecnologias sustentáveis aplicadas na indústria. Durante a visita, os estudantes poderão observar processos de produção limpa, sistemas de energia renovável e práticas de economia circular.

A visita incluirá apresentações técnicas, demonstrações práticas e sessão de perguntas e respostas com especialistas da área. É uma excelente oportunidade para complementar o conhecimento teórico com experiência prática.""",
    "image": "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "departureTime": "08:00",
    "returnTime": "17:30",
    "departureDate": "15/12/2024",
    "pickupLocation": "Portaria Principal - Campus Universitário",
    "dropoffLocation": "EcoTech Industries - Distrito Industrial",
    "pickupLat": -23.5505,
    "pickupLng": -46.6333,
    "dropoffLat": -23.5629,
    "dropoffLng": -46.6544,
    "availableSeats": 12,
    "totalSeats": 45,
    "joinCode": "ECO2024",
    "showParticipants": true,
  };

  final List<Map<String, dynamic>> _participants = [
{ "id": 1,
"name": "João Silva",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 2,
"name": "Maria Oliveira",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 3,
"name": "Pedro Santos",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 4,
"name": "Ana Costa",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 5,
"name": "Carlos Lima",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 6,
"name": "Lucia Ferreira",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 7,
"name": "Roberto Alves",
"avatar": null,
},
{ "id": 8,
"name": "Fernanda Rocha",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 9,
"name": "Gustavo Mendes",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 10,
"name": "Camila Torres",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 11,
"name": "Rafael Cardoso",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
},
{ "id": 12,
"name": "Juliana Barbosa",
"avatar": null,
},
];

  final List<Map<String, dynamic>> _comments = [
{ "id": 1,
"authorName": "Prof. Dr. Maria Santos",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"content": "Pessoal, lembrem-se de levar documento de identidade e usar calçados fechados para a visita. Nos vemos na portaria às 7:45!",
"timestamp": DateTime.now().subtract(const Duration(hours: 2)),
"isOrganizer": true,
},
{ "id": 2,
"authorName": "João Silva",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"content": "Muito animado para esta visita! Será que vamos ver os painéis solares em funcionamento?",
"timestamp": DateTime.now().subtract(const Duration(hours: 4)),
"isOrganizer": false,
},
{ "id": 3,
"authorName": "Maria Oliveira",
"avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
"content": "Professora, haverá material de apoio disponível após a visita?",
"timestamp": DateTime.now().subtract(const Duration(hours: 6)),
"isOrganizer": false,
},
];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    HapticFeedback.lightImpact();
  }

  void _shareEvent() {
    HapticFeedback.lightImpact();
    // Implement share functionality
  }

  void _expandMap() {
    HapticFeedback.lightImpact();
    // Navigate to full-screen map
    Navigator.pushNamed(context, '/map-view');
  }

  void _joinEvent() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isUserRegistered = true;
      _isLoading = false;
      _eventData['availableSeats'] = (_eventData['availableSeats'] as int) - 1;
    });
    
    HapticFeedback.lightImpact();
    _showSuccessDialog();
  }

  void _leaveEvent() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isUserRegistered = false;
      _isLoading = false;
      _eventData['availableSeats'] = (_eventData['availableSeats'] as int) + 1;
    });
    
    HapticFeedback.lightImpact();
  }

  void _joinWaitlist() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    HapticFeedback.lightImpact();
    _showWaitlistDialog();
  }

  void _bulkRegister() {
    HapticFeedback.lightImpact();
    // Navigate to bulk registration screen
    Navigator.pushNamed(context, '/bulk-register');
  }

  void _addComment(String comment) {
    setState(() {
      _comments.insert(0, {
        "id": _comments.length + 1,
        "authorName": "Usuário Atual",
        "avatar": "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
        "content": comment,
        "timestamp": DateTime.now(),
        "isOrganizer": false,
      });
    });
    HapticFeedback.lightImpact();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.accent,
                  size: 48,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Inscrição Confirmada!',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Você foi inscrito com sucesso no evento. Seu ticket será gerado automaticamente.',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/qr-ticket-display');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Ver Meu Ticket'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWaitlistDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.warning,
                  size: 48,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Adicionado à Lista de Espera',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Você foi adicionado à lista de espera. Será notificado automaticamente se uma vaga for liberada.',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.warning,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Entendi'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            EventHeaderWidget(
              eventTitle: _eventData['title'] as String,
              organizerName: _eventData['organizer'] as String,
              eventImage: _eventData['image'] as String,
              isFavorite: _isFavorite,
              onFavoriteToggle: _toggleFavorite,
              onShare: _shareEvent,
            ),
            
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 2.h),
                  
                  EventInfoCardWidget(
                    departureTime: _eventData['departureTime'] as String,
                    returnTime: _eventData['returnTime'] as String,
                    departureDate: _eventData['departureDate'] as String,
                    pickupLocation: _eventData['pickupLocation'] as String,
                    dropoffLocation: _eventData['dropoffLocation'] as String,
                    availableSeats: _eventData['availableSeats'] as int,
                    totalSeats: _eventData['totalSeats'] as int,
                    description: _eventData['description'] as String,
                  ),
                  
                  MiniMapWidget(
                    pickupLat: _eventData['pickupLat'] as double,
                    pickupLng: _eventData['pickupLng'] as double,
                    dropoffLat: _eventData['dropoffLat'] as double,
                    dropoffLng: _eventData['dropoffLng'] as double,
                    pickupLocation: _eventData['pickupLocation'] as String,
                    dropoffLocation: _eventData['dropoffLocation'] as String,
                    onExpandMap: _expandMap,
                  ),
                  
                  ParticipantsListWidget(
                    participants: _participants,
                    showPrivacyMessage: !(_eventData['showParticipants'] as bool),
                    totalParticipants: (_eventData['totalSeats'] as int) - (_eventData['availableSeats'] as int),
                  ),
                  
                  JoinCodeWidget(
                    joinCode: _eventData['joinCode'] as String,
                  ),
                  
                  CommentsSectionWidget(
                    comments: _comments,
                    canComment: _isUserRegistered,
                    onAddComment: _addComment,
                  ),
                  
                  SizedBox(height: 10.h), // Space for bottom actions
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: ActionButtonsWidget(
        isUserRegistered: _isUserRegistered,
        isEventFull: (_eventData['availableSeats'] as int) <= 0,
        isUserProfessor: _isUserProfessor,
        onJoinEvent: _joinEvent,
        onLeaveEvent: _leaveEvent,
        onJoinWaitlist: _joinWaitlist,
        onBulkRegister: _bulkRegister,
        isLoading: _isLoading,
      ),
    );
  }
}