import 'categoria.dart';
import 'carta.dart';

class GameData {
  final Map<String, dynamic> meta;
  final List<Categoria> categorias;
  final List<Carta> cartas;
  final Map<String, dynamic> sugestoesUso;

  GameData({
    required this.meta,
    required this.categorias,
    required this.cartas,
    required this.sugestoesUso,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      meta: json['meta'] as Map<String, dynamic>,
      categorias: (json['categorias'] as List)
          .map((cat) => Categoria.fromJson(cat as Map<String, dynamic>))
          .toList(),
      cartas: (json['cartas'] as List)
          .map((carta) => Carta.fromJson(carta as Map<String, dynamic>))
          .toList(),
      sugestoesUso: json['sugestoes_uso'] as Map<String, dynamic>,
    );
  }
}
