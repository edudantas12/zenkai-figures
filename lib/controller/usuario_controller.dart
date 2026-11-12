import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/erro_app.dart';
import '../model/usuario.dart';

/// Leitura e gravação dos dados do usuário na coleção `usuarios`.
class UsuarioController {
  static const colecao = 'usuarios';
  static const _tempoLimite = Duration(seconds: 15);

  final FirebaseFirestore _db;

  UsuarioController({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection(colecao).doc(uid);

  /// Salva o documento `usuarios/{uid}` (o ID é o UID do Authentication).
  Future<void> salvar(Usuario usuario) async {
    try {
      await _doc(usuario.uid).set(usuario.toMap()).timeout(_tempoLimite);
    } on FirebaseException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    } on TimeoutException {
      throw const ErroApp(
        'O servidor demorou para responder. Verifique sua conexão.',
      );
    }
  }

  /// Consulta única dos dados do usuário.
  Future<Usuario?> buscar(String uid) async {
    try {
      final doc = await _doc(uid).get();
      return doc.exists ? Usuario.fromFirestore(doc) : null;
    } on FirebaseException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    }
  }

  /// Dados do usuário em tempo real. Emite `null` se o documento não existir.
  Stream<Usuario?> stream(String uid) {
    return _doc(uid).snapshots().map(
          (doc) => doc.exists ? Usuario.fromFirestore(doc) : null,
        );
  }

  /// Atualiza os campos editáveis (e-mail, UID e data não mudam).
  Future<void> atualizar(
    String uid, {
    String? nome,
    String? telefone,
    String? cep,
  }) async {
    final dados = <String, dynamic>{
      'nome': ?nome,
      'telefone': ?telefone,
      'cep': ?cep,
    };
    if (dados.isEmpty) return;

    try {
      await _doc(uid).update(dados).timeout(_tempoLimite);
    } on FirebaseException catch (e) {
      throw ErroApp(mensagemDeErro(e));
    } on TimeoutException {
      throw const ErroApp(
        'O servidor demorou para responder. Verifique sua conexão.',
      );
    }
  }

  /// Traduz os códigos do Cloud Firestore para mensagens claras.
  String mensagemDeErro(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Você não tem permissão para acessar estes dados.';
      case 'unauthenticated':
        return 'Sua sessão expirou. Entre novamente.';
      case 'not-found':
        return 'Os dados do usuário não foram encontrados.';
      case 'unavailable':
      case 'deadline-exceeded':
        return 'Sem conexão com o servidor. Verifique sua internet.';
      default:
        return 'Erro ao acessar os dados (${e.code}). Tente novamente.';
    }
  }
}


