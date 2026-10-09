import 'package:flutter/foundation.dart';

/// Mantém os dados básicos do perfil durante a sessão do aplicativo.
class PerfilController extends ChangeNotifier {
  String _nomeUsuario = 'Lucas Martins';
  String _email = 'lucas.martins@email.com';

  String get nomeUsuario => _nomeUsuario;
  String get email => _email;

  bool atualizarNome(String novoNome) {
    final nome = novoNome.trim();
    if (nome.isEmpty) return false;
    _nomeUsuario = nome;
    notifyListeners();
    return true;
  }

  void atualizarEmail(String novoEmail) {
    final email = novoEmail.trim();
    if (email.isEmpty) return;
    _email = email;
    notifyListeners();
  }
}
