import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

abstract class ListaState {}

class ListaInicial extends ListaState {}

class ListaCarregando extends ListaState {}

class ListaCarregada extends ListaState {
  final List<AtendimentoModel> atendimentos;
  final int? filtroStatus;
  final Set<int> itensSelecionados;

  ListaCarregada({
    required this.atendimentos,
    this.filtroStatus,
    this.itensSelecionados = const {},
  });

  ListaCarregada copyWith({
    List<AtendimentoModel>? atendimentos,
    int? filtroStatus,
    Set<int>? itensSelecionados,
  }) {
    return ListaCarregada(
      atendimentos: atendimentos ?? this.atendimentos,
      filtroStatus: filtroStatus ?? this.filtroStatus,
      itensSelecionados: itensSelecionados ?? this.itensSelecionados,
    );
  }

  List<AtendimentoModel> get atendimentosFiltrados {
    if (filtroStatus == null) return atendimentos;
    return atendimentos.where((a) => a.status == filtroStatus).toList();
  }
}

class ListaErro extends ListaState {
  final String mensagem;
  ListaErro(this.mensagem);
}

class ListaOperacaoSucesso extends ListaState {
  final String mensagem;
  ListaOperacaoSucesso(this.mensagem);
}