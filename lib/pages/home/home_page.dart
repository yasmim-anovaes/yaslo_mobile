
import 'package:flutter/material.dart';
import '../autenticacao/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
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
            ],
          ),
        ),
      ),
    );
  }
}
