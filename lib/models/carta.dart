class Carta {
  final String id;
  final String categoria;
  final String nivel;
  final String tipo;
  final String texto;
  final int? goles;
  final int? golesSePular;
  final int? golesPenalidade;
  final String? golesAfetados;
  final int? golesDistribuir;
  final String? restricao;
  final String? duracao;
  final String? efeito;

  Carta({
    required this.id,
    required this.categoria,
    required this.nivel,
    required this.tipo,
    required this.texto,
    this.goles,
    this.golesSePular,
    this.golesPenalidade,
    this.golesAfetados,
    this.golesDistribuir,
    this.restricao,
    this.duracao,
    this.efeito,
  });

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      id: json['id'] as String,
      categoria: json['categoria'] as String,
      nivel: json['nivel'] as String,
      tipo: json['tipo'] as String,
      texto: json['texto'] as String,
      goles: json['goles'] as int?,
      golesSePular: json['goles_se_pular'] as int?,
      golesPenalidade: json['goles_penalidade'] as int?,
      golesAfetados: json['goles_afetados'] as String?,
      golesDistribuir: json['goles_distribuir'] as int?,
      restricao: json['restricao'] as String?,
      duracao: json['duracao'] as String?,
      efeito: json['efeito'] as String?,
    );
  }

  String get nivelEmoji {
    switch (nivel) {
      case 'leve':
        return '🟢';
      case 'medio':
        return '🟡';
      case 'pesado':
        return '🔴';
      default:
        return '⚪';
    }
  }

  String get tipoEmoji {
    switch (tipo) {
      case 'eu_nunca':
        return '🤔';
      case 'verdade':
        return '🤐';
      case 'desafio':
        return '💪';
      case 'acao':
        return '⚡';
      case 'regra':
        return '📜';
      case 'voto':
        return '🗳️';
      default:
        return '🎯';
    }
  }
}
