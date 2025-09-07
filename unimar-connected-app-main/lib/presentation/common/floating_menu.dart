import 'package:flutter/material.dart';

class FloatingMenu extends StatefulWidget {
  final bool isAdmin;
  final void Function()? onProfile;
  final void Function()? onTutorial;
  final void Function()? onScanner;
  final void Function()? onDashboard;
  final bool useSafeArea;
  final EdgeInsets? outerPadding;
  final bool compact;

  const FloatingMenu(
      {super.key,
      this.isAdmin = false,
      this.onProfile,
      this.onTutorial,
      this.onScanner,
      this.onDashboard,
      this.useSafeArea = true,
      this.outerPadding,
      this.compact = false});

  @override
  _FloatingMenuState createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  bool open = false;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  void toggle() {
    if (open) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => open = !open);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _menuItem(IconData icon, String label, VoidCallback? onTap) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () {
          toggle();
          if (onTap != null) onTap();
        },
        child: Container(
          margin: EdgeInsets.only(bottom: widget.compact ? 8 : 12),
          padding: EdgeInsets.all(widget.compact ? 8 : 10),
          decoration: BoxDecoration(
            color: Color(0xFF1F2937),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black45, blurRadius: widget.compact ? 4 : 8)
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: widget.compact ? 18 : 24),
              SizedBox(width: widget.compact ? 6 : 8),
              Text(label,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: widget.compact ? 12 : 14)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (open) ...[
          _menuItem(Icons.person, 'Perfil', widget.onProfile),
          _menuItem(Icons.school, 'Rever Tutorial', widget.onTutorial),
          _menuItem(Icons.qr_code_scanner, 'Modo Validador', widget.onScanner),
          if (widget.isAdmin)
            _menuItem(Icons.dashboard, 'Dashboard', widget.onDashboard),
        ],
        widget.compact
            ? FloatingActionButton.small(
                onPressed: toggle,
                backgroundColor: Color(0xFF6D28D9),
                child: AnimatedRotation(
                  turns: open ? 0.125 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(open ? Icons.close : Icons.menu, size: 20),
                ),
              )
            : FloatingActionButton(
                onPressed: toggle,
                backgroundColor: Color(0xFF6D28D9),
                child: AnimatedRotation(
                  turns: open ? 0.125 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(open ? Icons.close : Icons.menu),
                ),
              ),
      ],
    );

    if (!widget.useSafeArea) {
      return Padding(
          padding: widget.outerPadding ?? EdgeInsets.zero, child: content);
    }
    return SafeArea(
        child: Padding(
            padding: widget.outerPadding ?? const EdgeInsets.all(12.0),
            child: content));
  }
}
