import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final bool isAdmin;
  final void Function()? onProfile;
  final void Function()? onTutorial;
  final void Function()? onScanner;
  final void Function()? onDashboard;
  final void Function()? onLogout;

  const AppDrawer({
    super.key,
    this.isAdmin = false,
    this.onProfile,
    this.onTutorial,
    this.onScanner,
    this.onDashboard,
    this.onLogout,
  });

  Widget _menuItem(IconData icon, String label, VoidCallback? onTap,
      {Color? color}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color ?? Colors.white12,
        child: Icon(icon, color: Colors.white, size: 22),
      ),
      title: Text(
        label,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF291537), Color(0xFF0F1724)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage:
                          AssetImage('assets/images/placeholder-user.jpg'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Olá, Usuário',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('Ver perfil',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              _menuItem(Icons.person, 'Perfil', onProfile),
              _menuItem(Icons.school, 'Rever Tutorial', onTutorial),
              _menuItem(
                  Icons.qr_code_scanner, 'Modo Validador (Scan)', onScanner),
              if (isAdmin)
                _menuItem(
                    Icons.dashboard, 'Dashboard / Criar Evento', onDashboard),
              Spacer(),
              Divider(color: Colors.white12),
              _menuItem(Icons.exit_to_app, 'Sair', onLogout,
                  color: Colors.redAccent),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
