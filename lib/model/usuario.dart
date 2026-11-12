import 'package:cloud_firestore/cloud_firestore.dart';

/// Dados do usuário armazenados na coleção `usuarios` do Cloud Firestore.
///
/// O ID do documento é o UID gerado pelo Firebase Authentication.
/// A senha nunca faz parte deste modelo: ela fica apenas no Authentication.
class Usuario {
  final String uid;
  final String nome;

  /// Somente dígitos (DDD + número), ex.: `11999999999`.
  final String telefone;

  /// Somente dígitos, ex.: `01001000`.
  final String cep;
  final String email;

  /// `null` enquanto o servidor ainda não confirmou o horário do cadastro.
  final DateTime? dataCadastro;

  const Usuario({
    required this.uid,
    required this.nome,
    required this.telefone,
    required this.cep,
    required this.email,
    this.dataCadastro,
  });

  /// Converte para o formato salvo no Firestore.
  ///
  /// Sem [dataCadastro], usa o horário do servidor (gravado como Timestamp).
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'telefone': telefone,
      'cep': cep,
      'email': email,
      'dataCadastro': dataCadastro == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(dataCadastro!),
    };
  }

  /// Cria um [Usuario] a partir de um mapa vindo do Firestore.
  factory Usuario.fromMap(String id, Map<String, dynamic> dados) {
    final data = dados['dataCadastro'];

    return Usuario(
      uid: (dados['uid'] as String?) ?? id,
      nome: (dados['nome'] as String?) ?? '',
      telefone: (dados['telefone'] as String?) ?? '',
      cep: (dados['cep'] as String?) ?? '',
      email: (dados['email'] as String?) ?? '',
      dataCadastro: data is Timestamp ? data.toDate() : null,
    );
  }

  /// Cria um [Usuario] a partir de um documento do Firestore.
  factory Usuario.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Usuario.fromMap(doc.id, doc.data() ?? const {});
  }

  Usuario copyWith({String? nome, String? telefone, String? cep}) {
    return Usuario(
      uid: uid,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      cep: cep ?? this.cep,
      email: email,
      dataCadastro: dataCadastro,
    );
  }

  /// Telefone formatado: `(11) 99999-9999` ou `(11) 3333-4444`.
  String get telefoneFormatado {
    final d = telefone;
    if (d.length == 11) {
      return '(${d.substring(0, 2)}) ${d.substring(2, 7)}-${d.substring(7)}';
    }
    if (d.length == 10) {
      return '(${d.substring(0, 2)}) ${d.substring(2, 6)}-${d.substring(6)}';
    }
    return d;
  }

  /// CEP formatado: `01001-000`.
  String get cepFormatado =>
      cep.length == 8 ? '${cep.substring(0, 5)}-${cep.substring(5)}' : cep;
}
