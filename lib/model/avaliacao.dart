
import 'figure.dart';

class Avaliacao {
  final Figure figura;
  final int nota;
  final String comentario;
  final DateTime data;

  const Avaliacao({
    required this.figura,
    required this.nota,
    required this.comentario,
    required this.data,
  });
}
