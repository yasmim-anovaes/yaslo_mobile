import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  static const Color azul = Color(0xFF004AAD);
  static const Color fundo = Color(0xFFF8FAFC);

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _celularController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;
  bool _carregando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _celularController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate() || _carregando) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    try {
      // Criar conta no Firebase Authentication
      UserCredential resultado =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      );

      User? usuario = resultado.user;

      if (usuario == null) {
        throw Exception('Usuário não foi criado.');
      }

      // Salvar informações no Realtime Database
      await FirebaseDatabase.instance
          .ref('usuarios/${usuario.uid}')
          .set({
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'telefone': _celularController.text.trim(),
        'cargo': 'usuario',
        'criadoEm': ServerValue.timestamp,
      });

      // Encerrar sessão
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Voltar para o login
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      String mensagem;

      switch (e.code) {
        case 'email-already-in-use':
          mensagem = 'Este e-mail já está cadastrado.';
          break;
        case 'invalid-email':
          mensagem = 'E-mail inválido.';
          break;
        case 'weak-password':
          mensagem = 'A senha é muito fraca.';
          break;
        default:
          mensagem = 'Erro ao realizar cadastro: ${e.message}';
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red,
        ),
      );

    } catch (e) {
      debugPrint('Erro no cadastro: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar os dados do usuário.'),
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
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: azul,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: fundo,
        foregroundColor: azul,
        elevation: 0,
        title: const Text(
          'Criar conta',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                const SizedBox(height: 4),

                const Text(
                  'YasLo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: azul,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Crie sua conta',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Preencha seus dados para começar a '
                      'organizar suas finanças.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 26),

                // Nome completo
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: _decoracaoCampo(
                    label: 'Nome completo',
                    icone: Icons.person_outline,
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu nome.';
                    }

                    if (valor.trim().length < 3) {
                      return 'Digite seu nome completo.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

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

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(valor.trim())) {
                      return 'Digite um e-mail válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),


                // Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  textInputAction: TextInputAction.next,
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
                      return 'Crie uma senha.';
                    }

                    if (valor.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirmar senha
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: !_mostrarConfirmarSenha,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _cadastrar(),
                  decoration: _decoracaoCampo(
                    label: 'Confirmar senha',
                    icone: Icons.lock_outline,
                    sufixo: IconButton(
                      onPressed: () {
                        setState(() {
                          _mostrarConfirmarSenha =
                          !_mostrarConfirmarSenha;
                        });
                      },
                      icon: Icon(
                        _mostrarConfirmarSenha
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Confirme sua senha.';
                    }

                    if (valor != _senhaController.text) {
                      return 'As senhas não coincidem.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 26),

                // Botão cadastrar
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _carregando
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                        : const Text(
                      'Criar conta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Voltar ao login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'Já tem uma conta?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Fazer login',
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
    );
  }
}
