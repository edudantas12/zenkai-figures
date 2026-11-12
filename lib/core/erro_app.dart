/// Erro com mensagem pronta para ser exibida ao usuário.
///
/// Os controllers convertem exceções do Firebase em [ErroApp], assim as
/// views não precisam conhecer códigos de erro do Firebase.
class ErroApp implements Exception {
  final String mensagem;

  const ErroApp(this.mensagem);

  @override
  String toString() => mensagem;
}
