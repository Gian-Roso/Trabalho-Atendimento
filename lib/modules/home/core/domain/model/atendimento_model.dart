class AtendimentoModel {
  final int? id;
  final String nome;
  final String? nomeCliente; 
  final DateTime data;
  final DateTime? criadoEm;
  final String? descricao;
  final int status;
  final String? foto;
  final String? fotoFinalizacao; 

  AtendimentoModel({
    this.id,
    required this.nome,
    this.nomeCliente, 
    required this.data,
    this.criadoEm,
    this.descricao,
    required this.status,
    this.foto,
    this.fotoFinalizacao, 
  });

  AtendimentoModel copyWith({
    int? id,
    String? nome,
    String? nomeCliente, 
    DateTime? data,
    DateTime? criadoEm,
    String? descricao,
    int? status,
    String? foto,
    String? fotoFinalizacao, 
  }) {
    return AtendimentoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      nomeCliente: nomeCliente ?? this.nomeCliente, 
      data: data ?? this.data,
      criadoEm: criadoEm ?? this.criadoEm,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      foto: foto ?? this.foto,
      fotoFinalizacao: fotoFinalizacao ?? this.fotoFinalizacao, 
    );
  }

  Map<String, dynamic> toMap({bool incluirCriadoEm = true}) {
    final map = {
      'id': id,
      'nome': nome,
      'nome_cliente': nomeCliente, 
      'data': data.toIso8601String(),
      'descricao': descricao,
      'status': status,
      'foto': foto,
      'foto_finalizacao': fotoFinalizacao, 
    };
    
    if (incluirCriadoEm && criadoEm != null) {
      map['criado_em'] = criadoEm!.toIso8601String();
    }
    
    return map;
  }

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'],
      nome: map['nome'],
      nomeCliente: map['nome_cliente'], 
      data: DateTime.parse(map['data']),
      criadoEm: map['criado_em'] != null ? DateTime.parse(map['criado_em']) : null,
      descricao: map['descricao'],
      status: map['status'],
      foto: map['foto'],
      fotoFinalizacao: map['foto_finalizacao'], 
    );
  }
}