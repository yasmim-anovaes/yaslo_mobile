
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cadastro_page.dart';
import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color azul = Color(0xFF004AAD);
  static const Color fundo = Color(0xFFF8FAFC);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;
  bool _lembrarMe = false;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate() || _carregando) return;

    setState(() {
      _carregando = true;
    });

    try {
      // Autenticação pelo Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      );

      if (!mounted) return;

      // Direciona para a tela inicial
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );

    } on FirebaseAuthException catch (e) {
      String mensagem;

      switch (e.code) {
        case 'invalid-email':
          mensagem = 'E-mail inválido.';
          break;

        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          mensagem = 'E-mail ou senha incorretos.';
          break;

        case 'user-disabled':
          mensagem = 'Esta conta está desativada.';
          break;

        case 'too-many-requests':
          mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
          break;

        default:
          mensagem = 'Erro ao realizar login. Tente novamente.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red,
        ),
      );

    }  catch (e, stackTrace) {
      debugPrint('ERRO NO LOGIN: $e');
      debugPrint('DETALHES: $stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text('Erro: $e'),
      backgroundColor: Colors.red,
      ),
  );

    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  Future <void> _recuperarSenha() async {
    final email = _emailController.text.trim();

    if(email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite seu e-mail para recuperar a senha.'),
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: email
      );

      if (!mounted) return;

      showDialog
        (context: context,
          builder: (context) => AlertDialog(
            title: const Text('E-mail enviado!'),
            content: const Text('Enviamos um link para redefinir sua senha.'
                            'Verifique sua caixa de entrada e também o spam.'
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Entendi'),
              ),
            ],
          ),
      );
    } on FirebaseAuthException catch (e) {
      String mensagem = 'Não foi possível enviar o e-mail. Tente novamente.';

      if (e.code == 'invalid-email') {
        mensagem = 'O endereço de e-mail é inválido.';
      } else if (e.code == 'user-not-found') {
        mensagem = 'Não encontramos uma conta com esse e-mail.';
      } else if (e.code == 'too-many-requests') {
        mensagem = 'Muitas tentativas. Aguarde um pouco e tente novamente.';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
    }
  }


  InputDecoration _decoracaoCampo({
    required String label,
    required IconData icone,
    Widget? sufixo,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone, color: azul, size: 21),
      suffixIcon: sufixo,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: azul, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Botão voltar
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: azul,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),


                  const SizedBox(height: 4),

                  const Text(
                    'YasLo!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: azul,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),


                  const SizedBox(height: 36),

                  const Text(
                    'Bem-vindo de volta!',
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Entre na sua conta para continuar.',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // E-mail
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: _decoracaoCampo(
                      label: 'E-mail',
                      icone: Icons.email_outlined,
                    ),
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Informe seu e-mail.';
                      }

                      final email = valor.trim();

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(email)) {
                        return 'Digite um e-mail válido.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _entrar(),
                    decoration: _decoracaoCampo(
                      label: 'Senha',
                      icone: Icons.lock_outline,
                      sufixo: IconButton(
                        onPressed: () {
                          setState(() {
                            _mostrarSenha = !_mostrarSenha;
                          });
                        },
                        icon: Icon(
                          _mostrarSenha
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    validator: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Informe sua senha.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Lembrar-me e recuperar senha
                  Row(
                    children: [
                      Checkbox(
                        value: _lembrarMe,
                        activeColor: azul,
                        onChanged: (valor) {
                          setState(() {
                            _lembrarMe = valor ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Lembrar-me',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'A recuperação de senha será implementada depois.',
                              ),
                            ),
                          );
                        },
                        child: TextButton(
                          onPressed: _recuperarSenha,
                          child: const Text(
                            'Esqueceu a senha?',
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Entrar
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _entrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azul,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _carregando
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cadastro
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Flexible(
                        child: Text(
                          'Ainda não tem uma conta?',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CadastroPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(
                            color: azul,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
