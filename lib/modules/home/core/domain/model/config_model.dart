class ConfigModel {
  final bool notificacoesAtivas;
  final int minutosAntesNotificacao;
  final bool somAtivo;
  final bool vibracaoAtiva;
  final String toqueNotificacao; // 'padrao', 'alarme', 'sino'

  ConfigModel({
    this.notificacoesAtivas = true,
    this.minutosAntesNotificacao = 30,
    this.somAtivo = true,
    this.vibracaoAtiva = true,
    this.toqueNotificacao = 'padrao',
  });

  ConfigModel copyWith({
    bool? notificacoesAtivas,
    int? minutosAntesNotificacao,
    bool? somAtivo,
    bool? vibracaoAtiva,
    String? toqueNotificacao,
  }) {
    return ConfigModel(
      notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
      minutosAntesNotificacao: minutosAntesNotificacao ?? this.minutosAntesNotificacao,
      somAtivo: somAtivo ?? this.somAtivo,
      vibracaoAtiva: vibracaoAtiva ?? this.vibracaoAtiva,
      toqueNotificacao: toqueNotificacao ?? this.toqueNotificacao,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificacoesAtivas': notificacoesAtivas,
      'minutosAntesNotificacao': minutosAntesNotificacao,
      'somAtivo': somAtivo,
      'vibracaoAtiva': vibracaoAtiva,
      'toqueNotificacao': toqueNotificacao,
    };
  }

  factory ConfigModel.fromMap(Map<String, dynamic> map) {
    return ConfigModel(
      notificacoesAtivas: map['notificacoesAtivas'] ?? true,
      minutosAntesNotificacao: map['minutosAntesNotificacao'] ?? 30,
      somAtivo: map['somAtivo'] ?? true,
      vibracaoAtiva: map['vibracaoAtiva'] ?? true,
      toqueNotificacao: map['toqueNotificacao'] ?? 'padrao',
    );
  }
}