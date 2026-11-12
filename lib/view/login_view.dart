
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../controller/login_controller.dart';
import '../core/erro_app.dart';
import '../main.dart';
import 'cadastrar_usuario_view.dart';
import 'common_widgets.dart';
import 'recuperar_senha_view.dart';

class LoginPage extends StatefulWidget {
  /// Chamado ao tocar em "Explorar sem conta" (modo visitante).
  final VoidCallback onExplorar;

  const LoginPage({
    super.key,
    required this.onExplorar,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final controller = LoginController();
  final auth = getIt<AuthController>();

  bool mostrar = false;
  bool lembrar = true;
  bool carregando = false;

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    controller.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> entrar() async {
    if (carregando) return;

    final erro = controller.validar(email.text, senha.text);
    if (erro != null) {
      _mensagem(erro);
      return;
    }

    setState(() => carregando = true);
    try {
      await auth.entrar(
        email: email.text,
        senha: senha.text,
        lembrar: lembrar,
      );
      // A navegação para a tela principal acontece no main.dart,
      // que escuta as mudanças de autenticação do Firebase.
      if (mounted) _mensagem('Login realizado com sucesso!');
    } on ErroApp catch (e) {
      if (mounted) _mensagem(e.mensagem);
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: lime,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ZENKAI',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    const Text(
                      ' FIGURES',
                      style: TextStyle(
                        color: muted,
                        fontSize: 10,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.help_outline),
                  ],
                ),
                const SizedBox(height: 34),
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/zenkai_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.bolt,
                        color: lime,
                        size: 80,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Entre no seu universo.',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sua próxima figura favorita está aqui.',
                  style: TextStyle(color: muted),
                ),
                const SizedBox(height: 22),
                const Text('E-mail'),
                const SizedBox(height: 6),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Seu e-mail',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Senha'),
                const SizedBox(height: 6),
                TextField(
                  controller: senha,
                  obscureText: !mostrar,
                  onSubmitted: (_) => entrar(),
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        mostrar = !mostrar;
                      }),
                      icon: Icon(
                        mostrar
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: lembrar,
                      onChanged: (v) => setState(() {
                        lembrar = v ?? false;
                      }),
                      activeColor: lime,
                    ),
                    const Text(
                      'Lembrar de mim',
                      style: TextStyle(
                        color: muted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecoverPage(emailInicial: email.text),
                        ),
                      ),
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: lime,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                carregando
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: CircularProgressIndicator(color: lime),
                        ),
                      )
                    : PrimaryButton(
                        'Entrar',
                        onPressed: entrar,
                      ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'ou descubra a coleção',
                    style: TextStyle(color: muted),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: widget.onExplorar,
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Explorar sem conta'),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterPage(),
                      ),
                    ),
                    child: const Text(
                      'Ainda não tem uma conta? Cadastre-se',
                      style: TextStyle(color: lime),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
