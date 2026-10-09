
import 'package:flutter/material.dart';

import '../controller/login_controller.dart';
import '../main.dart';
import 'cadastrar_usuario_view.dart';
import 'common_widgets.dart';
import 'recuperar_senha_view.dart';

class LoginPage extends StatefulWidget {
  final void Function(String, String) onLogin;

  const LoginPage({
    super.key,
    required this.onLogin,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final controller = LoginController();

  bool mostrar = false;
  bool lembrar = false;

  @override
  void dispose() {
    email.dispose();
    senha.dispose();
    controller.dispose();
    super.dispose();
  }

  void entrar() {
    final erro = controller.validar(email.text, senha.text);

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
      return;
    }

    widget.onLogin(
      controller.nomePeloEmail(email.text),
      email.text.trim(),
    );
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
                          builder: (_) => const RecoverPage(),
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
                PrimaryButton(
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
                  onPressed: () => widget.onLogin('Colecionador', ''),
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
