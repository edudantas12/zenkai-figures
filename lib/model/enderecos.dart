
class Endereco {
  final String destinatario;
  final String cep;
  final String rua;
  final String numero;
  final String complemento;
  final String bairro;
  final String cidade;
  final String estado;
  bool principal;

  Endereco({
    required this.destinatario,
    required this.cep,
    required this.rua,
    required this.numero,
    this.complemento = '',
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.principal = false,
  });
}
