import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

abstract class CadastroState {
  final DateTime? horaSelecionada;
  final int statusSelecionado;
  final String? imagemSelecionada;
  final String nome;
  final String descricao;

  CadastroState({
    this.horaSelecionada,
    this.statusSelecionado = 0,
    this.imagemSelecionada,
    this.nome = "",
    this.descricao = "",
  });

  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? nome,
    String? descricao,
  });
}

class CadastroNovo extends CadastroState {
  CadastroNovo({
    DateTime? horaSelecionada,
    int statusSelecionado = 0,
    String? imagemSelecionada,
    String nome = "",
    String descricao = "",
  }) : super(
          horaSelecionada: horaSelecionada,
          statusSelecionado: statusSelecionado,
          imagemSelecionada: imagemSelecionada,
          nome: nome,
          descricao: descricao,
        );

  @override
  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? nome,
    String? descricao,
  }) {
    return CadastroNovo(
      horaSelecionada: horaSelecionada ?? this.horaSelecionada,
      statusSelecionado: statusSelecionado ?? this.statusSelecionado,
      imagemSelecionada: imagemSelecionada ?? this.imagemSelecionada,
      nome: nome ?? this.nome,
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
          nome: cadastro.nome,
          descricao: cadastro.descricao ?? "",
        );

  @override
  CadastroState copyWith({
    DateTime? horaSelecionada,
    int? statusSelecionado,
    String? imagemSelecionada,
    String? nome,
    String? descricao,
  }) {
    return CadastroAtualizar(
      cadastro.copyWith(
        data: horaSelecionada ?? cadastro.data,
        status: statusSelecionado ?? cadastro.status,
        foto: imagemSelecionada ?? cadastro.foto,
        nome: nome ?? cadastro.nome,
        descricao: descricao ?? cadastro.descricao,
      ),
    );
  }
}
