import '../common/floating_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../profile/profile_screen.dart';
import '../tutorial/tutorial_screen.dart';
import '../qr_scanner/qr_scanner.dart';
import './widgets/active_ticket_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/quick_action_card.dart';
import './widgets/upcoming_event_card.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final PageController _ticketPageController = PageController();
  bool _isRefreshing = false;
  int _currentTicketIndex = 0;

  // Mock data for active tickets
  final List<Map<String, dynamic>> _activeTickets = [
    {
      "id": "1",
      "eventName": "Visita Técnica - Empresa ABC",
      "departureTime": "08:00",
      "destination": "São Paulo - SP",
      "status": "Ativo",
      "qrCode":
          "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=TICKET001",
      "date": "15/09/2024",
    },
    {
      "id": "2",
      "eventName": "Congresso de Tecnologia",
      "departureTime": "14:30",
      "destination": "Centro de Convenções",
      "status": "Confirmado",
      "qrCode":
          "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=TICKET002",
      "date": "18/09/2024",
    },
  ];

  // Mock data for upcoming events
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      "id": "1",
      "title": "Workshop de Inteligência Artificial",
      "description":
          "Aprenda sobre as últimas tendências em IA e machine learning com especialistas da área.",
      "departureTime": "09:00 - 16/09",
      "destination": "Campus Tecnológico - Bloco A",
      "availableSeats": 15,
      "totalSeats": 40,
      "status": "Disponível",
      "imageUrl":
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=500&h=300&fit=crop",
      "emoji": "🤖",
    },
    {
      "id": "2",
      "title": "Feira de Estágios 2024",
      "description":
          "Conecte-se com as melhores empresas e encontre oportunidades de estágio na sua área.",
      "departureTime": "13:00 - 20/09",
      "destination": "Centro de Eventos da Universidade",
      "availableSeats": 8,
      "totalSeats": 50,
      "status": "Disponível",
      "imageUrl":
          "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500&h=300&fit=crop",
      "emoji": "💼",
    },
    {
      "id": "3",
      "title": "Competição de Robótica",
      "description":
          "Participe da maior competição de robótica da região e mostre suas habilidades.",
      "departureTime": "10:00 - 25/09",
      "destination": "Ginásio Poliesportivo",
      "availableSeats": 0,
      "totalSeats": 30,
      "status": "Lotado",
      "imageUrl":
          "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=500&h=300&fit=crop",
      "emoji": "🤖",
    },
  ];

  @override
  void initState() {
    super.initState();
    _ticketPageController.addListener(() {
      final page = _ticketPageController.page?.round() ?? 0;
      if (page != _currentTicketIndex) {
        setState(() {
          _currentTicketIndex = page;
        });
      }
    });
    // Exibe tutorial no primeiro acesso à Home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowFirstLaunchTutorial();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ticketPageController.dispose();
    super.dispose();
  }

  Future<void> _maybeShowFirstLaunchTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasSeen = prefs.getBool('has_seen_tutorial_v1') ?? false;
      final justLoggedIn = prefs.getBool('just_logged_in') ?? false;
      if (justLoggedIn && !hasSeen && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TutorialScreen()),
        );
        await prefs.setBool('has_seen_tutorial_v1', true);
        await prefs.remove('just_logged_in');
      }
    } catch (_) {
      // falha silenciosa
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dados atualizados com sucesso!'),
          backgroundColor: AppTheme.accent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.primary,
              backgroundColor: AppTheme.surface,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Sticky Header
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    backgroundColor: AppTheme.background,
                    elevation: 0,
                    surfaceTintColor: Colors.transparent,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    expandedHeight: 88,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.background,
                            AppTheme.background.withValues(alpha: 0.95),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        child: Row(
                          children: [
                            // reserva espaço para o menu sobreposto no topo
                            SizedBox(width: 18.w),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Olá, João! 👋',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: AppTheme.textPrimary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'Universidade Federal de São Paulo',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Nenhuma notificação no momento'),
                                    backgroundColor: AppTheme.accent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                              icon: Stack(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'notifications_outlined',
                                    color: AppTheme.textPrimary,
                                    size: 24,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const QrScanner()),
                                        );
                                      },
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.error,
                                          shape: BoxShape.circle,
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
                    ),
                  ),

                  // Main Content
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Active Tickets Section
                        if (_activeTickets.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Row(
                              children: [
                                Text(
                                  'Meus Tickets Ativos',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.pushNamed(
                                        context, '/qr-ticket-display');
                                  },
                                  child: Text(
                                    'Ver todos',
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 28.h,
                            child: PageView.builder(
                              controller: _ticketPageController,
                              itemCount: _activeTickets.length,
                              padEnds: false,
                              itemBuilder: (context, index) {
                                final ticket = _activeTickets[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 4.w : 0),
                                  child: ActiveTicketCard(
                                    ticket: ticket,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pushNamed(
                                          context, '/qr-ticket-display');
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_activeTickets.length > 1) ...[
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _activeTickets.length,
                                (index) => Container(
                                  width: 8,
                                  height: 8,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: index == _currentTicketIndex
                                        ? AppTheme.primary
                                        : AppTheme.border,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 3.h),
                        ],

                        // Quick Actions Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'Ações Rápidas',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: QuickActionCard(
                                  title: 'Horários',
                                  subtitle: 'Ver horários dos ônibus',
                                  iconName: 'schedule',
                                  iconColor: AppTheme.secondary,
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // Navigate to bus schedules
                                  },
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: QuickActionCard(
                                  title: 'Navegação',
                                  subtitle: 'Mapa do campus',
                                  iconName: 'map',
                                  iconColor: AppTheme.accent,
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // Navigate to campus map
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Upcoming Events Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Text(
                                'Próximos Eventos',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pushNamed(
                                      context, '/event-details');
                                },
                                child: Text(
                                  'Ver todos',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),

                        // Events List or Empty State
                        _upcomingEvents.isNotEmpty
                            ? Column(
                                children: _upcomingEvents.map((event) {
                                  return UpcomingEventCard(
                                    event: event,
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pushNamed(
                                          context, '/event-details');
                                    },
                                    onShare: () {
                                      HapticFeedback.lightImpact();
                                      _shareEvent(event);
                                    },
                                    onAddToCalendar: () {
                                      HapticFeedback.lightImpact();
                                      _addToCalendar(event);
                                    },
                                  );
                                }).toList(),
                              )
                            : EmptyStateWidget(
                                title: 'Nenhum evento disponível',
                                subtitle:
                                    'Não há eventos programados no momento. Verifique novamente em breve ou explore outros eventos.',
                                iconName: 'event_busy',
                                buttonText: 'Explorar Eventos',
                                onButtonPressed: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.pushNamed(
                                      context, '/event-details');
                                },
                              ),

                        SizedBox(height: 10.h), // Bottom padding for FAB
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // FloatingMenu fixo no topo (fora do header), permanece visível ao rolar
          Positioned(
            left: 8,
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, top: 8),
                child: FloatingMenu(
                  isAdmin: true,
                  compact: true,
                  onProfile: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                  onTutorial: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TutorialScreen()),
                    );
                  },
                  onScanner: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QrScanner()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showJoinEventDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Participar', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _shareEvent(Map<String, dynamic> event) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartilhando: ${event["title"]}'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _addToCalendar(Map<String, dynamic> event) {
    // Implement add to calendar functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Adicionado ao calendário: ${event["title"]}'),
        backgroundColor: AppTheme.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showJoinEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Participar de Evento',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Digite o código do evento para participar:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Código do evento',
                prefixIcon: CustomIconWidget(
                  iconName: 'qr_code',
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Participação confirmada!'),
                  backgroundColor: AppTheme.accent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            child: const Text('Participar'),
          ),
        ],
      ),
    );
  }
}
