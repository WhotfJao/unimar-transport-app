import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/qr_ticket_display/qr_ticket_display.dart';
import '../presentation/home_feed/home_feed.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/event_details/event_details.dart';
import '../presentation/qr_scanner/qr_scanner.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String qrTicketDisplay = '/qr-ticket-display';
  static const String homeFeed = '/home-feed';
  static const String login = '/login-screen';
  static const String eventDetails = '/event-details';
  static const String qrScanner = '/qr-scanner';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    qrTicketDisplay: (context) => const QrTicketDisplay(),
    homeFeed: (context) => const HomeFeed(),
    login: (context) => const LoginScreen(),
    eventDetails: (context) => const EventDetails(),
    qrScanner: (context) => const QrScanner(),
    // TODO: Add your other routes here
  };
}
