

import 'package:Baquadrix/modules/home/core/domain/model/atendimento_model.dart';

abstract class CadastroState {
  final DateTime? horaSelecionada;
  final int statusSelecionado;
  final String? imagemSelecionada;
  final String? imagemFinalizacao; 
  final String nome;
  final String nomeCliente; 
  final String descricao;

  CadastroState({
    this.horaSelecionada,
    this.statusSelecionado = 0,
    this.imagemSelecionada,
    this.imagemFinalizacao, 
    this.nome = "",
    this.nomeCliente = "", 
    this.descricao = "",
  });

  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? imagemFinalizacao, 
    String? nome,
    String? nomeCliente, 
    String? descricao,
  });
}

class CadastroNovo extends CadastroState {
  CadastroNovo({
    super.horaSelecionada,
    super.statusSelecionado,
    super.imagemSelecionada,
    super.imagemFinalizacao, 
    super.nome,
    super.nomeCliente, 
    super.descricao,
  });

  @override
  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? imagemFinalizacao, 
    String? nome,
    String? nomeCliente, 
    String? descricao,
  }) {
    return CadastroNovo(
      horaSelecionada: horaSelecionada ?? this.horaSelecionada,
      statusSelecionado: statusSelecionado ?? this.statusSelecionado,
      imagemSelecionada: imagemSelecionada ?? this.imagemSelecionada,
      imagemFinalizacao: imagemFinalizacao ?? this.imagemFinalizacao, 
      nome: nome ?? this.nome,
      nomeCliente: nomeCliente ?? this.nomeCliente, 
      descricao: descricao ?? this.descricao,
    );
  }
}

class CadastroAtualizar extends CadastroState {
  final AtendimentoModel cadastro;

  CadastroAtualizar(this.cadastro)
      : super(
          horaSelecionada: cadastro.data,
          statusSelecionado: cadastro.status,
          imagemSelecionada: cadastro.foto,
          imagemFinalizacao: cadastro.fotoFinalizacao, 
          nome: cadastro.nome,
          nomeCliente: cadastro.nomeCliente ?? "", 
          descricao: cadastro.descricao ?? "",
        );

  @override
  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? imagemFinalizacao, 
    String? nome,
    String? nomeCliente, 
    String? descricao,
  }) {
    return CadastroAtualizar(
      cadastro.copyWith(
        data: horaSelecionada ?? cadastro.data,
        status: statusSelecionado ?? cadastro.status,
        foto: imagemSelecionada ?? cadastro.foto,
        fotoFinalizacao: imagemFinalizacao ?? cadastro.fotoFinalizacao, 
        nome: nome ?? cadastro.nome,
        nomeCliente: nomeCliente ?? cadastro.nomeCliente, 
        descricao: descricao ?? cadastro.descricao,
      ),
    );
  }
}