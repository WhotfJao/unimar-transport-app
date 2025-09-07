import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const TutorialScreen({super.key, this.onFinish});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const _prefKey = 'seen_tutorial_v1';

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (widget.onFinish != null) widget.onFinish!();
  }

  static Future<bool> hasSeenTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

 Widget _buildPage({
  required String title,
  required String subtitle,
  String? image, // <-- parâmetro opcional
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 28.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: image != null
                ? Image.asset(image, fit: BoxFit.contain) // se vier imagem, mostra ela
                : Text(
                    'Illustration',
                    style: TextStyle(color: Colors.white38),
                  ),
          ),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(title: 'Bem-vindo', subtitle: 'Organize e confirme seu transporte com QR code', image: 'assets/tutorial1.png' ),
      _buildPage(title: 'Gerar Ticket', subtitle: 'Receba QR code com seu horário e bloco.',  image: 'assets/tutorial2.png'),
      _buildPage(title: 'Validação', subtitle: 'Motoristas validam com scanner ou busca manual.',  image: 'assets/tutorial3.png'),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18),
              child: Row(
                children: [
                  Row(
                    children: List.generate(pages.length, (i) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: _page == i ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _page == i ? Colors.white : Colors.white30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      if (_page < pages.length - 1) {
                        _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
                      } else {
                        _finish();
                      }
                    },
                    child: Text(_page < pages.length - 1 ? 'Próximo' : 'Concluir', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
