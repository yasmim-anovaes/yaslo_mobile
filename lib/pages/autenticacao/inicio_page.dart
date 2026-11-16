
import 'package:flutter/material.dart';
import 'login_page.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _inicio_page();
}

class _inicio_page extends State<InicioPage> {
  static const Color azul = Color(0xFF004AAD);
  static const Color fundo = Color(0xFFF8FAFC);

  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              const SizedBox(height: 8),

              // Logo YasLo com efeito Fade In
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                curve: Curves.easeIn,
                builder: (context, opacidade, child) {
                  return Opacity(
                    opacity: opacidade,
                    child: child,
                  );
                },
                child: const Text(
                  'YasLo!',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: azul,
                    letterSpacing: -1,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Subtítulo com efeito Fade In
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeIn,
                builder: (context, opacidade, child) {
                  return Opacity(
                    opacity: opacidade,
                    child: child,
                  );
                },
                child: const Text(
                  'Organize suas finanças',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),

              const Spacer(),

              // Botão Começar com efeito Hover
              MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) {
                  setState(() => _hover = true);
                },
                onExit: (_) {
                  setState(() => _hover = false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(_hover ? 1.03 : 1.0),
                  transformAlignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hover
                            ? const Color(0xFF003380)
                            : azul,
                        foregroundColor: Colors.white,
                        elevation: _hover ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Começar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
