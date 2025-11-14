class AtendimentoModel {
  final int? id;
  final String nome;
  final DateTime data;
  final DateTime? criadoEm;
  final String? descricao;
  final int status;
  final String? foto;

  AtendimentoModel(
    {
      this.id, required this.nome,required this.data, this.criadoEm, this.descricao, required this.status, this.foto 
    }
  );
  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'data': data,
    'criado_em': criadoEm,
    'descricao': descricao,
    'status': status,
    'foto': foto,
  };

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'],
      nome: map['nome'],
      data: map['data'],
      criadoEm: map['criadoEm'],
      descricao: map['descricao'],
      status: map['status'],
      foto: map['foto'],
    );
  }
}

