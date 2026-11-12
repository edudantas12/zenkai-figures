import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';
import '../controller/recuperar_senha_controller.dart';
import '../core/erro_app.dart';
import '../main.dart';
import 'common_widgets.dart';

class RecoverPage extends StatefulWidget {
  /// E-mail já digitado na tela de login, para não precisar digitar de novo.
  final String emailInicial;

  const RecoverPage({super.key, this.emailInicial = ''});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final controller = RecuperarSenhaController();
  final auth = getIt<AuthController>();
  late final email = TextEditingController(text: widget.emailInicial.trim());

  bool carregando = false;
  bool enviado = false;

  @override
  void dispose() {
    controller.dispose();
    email.dispose();
    super.dispose();
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _enviar() async {
    if (carregando) return;

    if (!controller.emailValido(email.text)) {
      _mensagem('Informe um e-mail válido.');
      return;
    }

    setState(() => carregando = true);
    try {
      await auth.enviarRedefinicaoSenha(email.text);
      if (!mounted) return;
      setState(() => enviado = true);
      _mensagem('Link de recuperação enviado! Verifique seu e-mail.');
    } on ErroApp catch (e) {
      if (mounted) _mensagem(e.mensagem);
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              enviado ? Icons.mark_email_read_outlined : Icons.key_outlined,
              color: lime,
              size: 65,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Esqueceu a senha? A gente te ajuda.',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Informe o e-mail cadastrado e enviaremos um link para '
            'você criar uma nova senha.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 22),
          const Text('E-mail cadastrado'),
          const SizedBox(height: 6),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onSubmitted: (_) => _enviar(),
            decoration: const InputDecoration(
              hintText: 'voce@exemplo.com',
              prefixIcon: Icon(Icons.mail_outline),
            ),
          ),
          const SizedBox(height: 18),
          if (enviado) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF29351D),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: lime),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: lime),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Se houver uma conta com este e-mail, você vai '
                      'receber o link em instantes. Confira também a '
                      'caixa de spam.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          carregando
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: CircularProgressIndicator(color: lime),
                  ),
                )
              : PrimaryButton(
                  enviado ? 'Reenviar link' : 'Enviar link de recuperação',
                  onPressed: _enviar,
                ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Voltar para o login',
              style: TextStyle(color: lime),
            ),
          ),
        ],
      ),
    );
  }
}
