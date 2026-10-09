import 'package:flutter/foundation.dart';

/// Regras de validação do cadastro de usuário.
class CadastrarUsuarioController extends ChangeNotifier {
  String? validar({
    required String nome,
    required String email,
    required String celular,
    required String senha,
    required String confirmarSenha,
    required bool aceitouTermos,
  }) {
    if (nome.trim().isEmpty) return 'Informe seu nome de usuário.';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      return 'Informe um e-mail válido.';
    }
    if (celular.trim().length < 10) return 'Informe um celular válido.';
    if (senha.length < 8 || !RegExp(r'\d').hasMatch(senha)) {
      return 'A senha deve ter pelo menos 8 caracteres e um número.';
    }
    if (senha != confirmarSenha) return 'As senhas não coincidem.';
    if (!aceitouTermos) return 'Você precisa aceitar os termos de uso.';
    return null;
  }
}
