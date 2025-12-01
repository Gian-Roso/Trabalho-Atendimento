import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

abstract class ListaState {}

class ListaInicial extends ListaState {}

class ListaCarregando extends ListaState {}

class ListaCarregada extends ListaState {
  final List<AtendimentoModel> atendimentos;
  final int? filtroStatus;
  final DateTime? filtroDataInicio; 
  final DateTime? filtroDataFim; 
  final String? filtroNome; 
  final String tipoFiltroData; 
  final Set<int> itensSelecionados;

  ListaCarregada({
    required this.atendimentos,
    this.filtroStatus,
    this.filtroDataInicio, 
    this.filtroDataFim, 
    this.filtroNome, 
    this.tipoFiltroData = 'servico', 
    this.itensSelecionados = const {},
  });

  ListaCarregada copyWith({
    List<AtendimentoModel>? atendimentos,
    int? filtroStatus,
    DateTime? filtroDataInicio,
    DateTime? filtroDataFim,
    String? filtroNome,
    String? tipoFiltroData, 
    Set<int>? itensSelecionados,
    bool limparFiltroData = false, 
    bool limparFiltroNome = false, 
  }) {
    return ListaCarregada(
      atendimentos: atendimentos ?? this.atendimentos,
      filtroStatus: filtroStatus,
      filtroDataInicio: limparFiltroData ? null : (filtroDataInicio ?? this.filtroDataInicio),
      filtroDataFim: limparFiltroData ? null : (filtroDataFim ?? this.filtroDataFim),
      filtroNome: limparFiltroNome ? null : (filtroNome ?? this.filtroNome),
      tipoFiltroData: tipoFiltroData ?? this.tipoFiltroData,
      itensSelecionados: itensSelecionados ?? this.itensSelecionados,
    );
  }

  List<AtendimentoModel> get atendimentosFiltrados {
    var resultado = atendimentos;
    if (filtroStatus != null) {
      resultado = resultado.where((a) => a.status == filtroStatus).toList();
    }
    if (filtroNome != null && filtroNome!.isNotEmpty) {
      resultado = resultado.where((a) {
        final nomeServico = a.nome.toLowerCase();
        final nomeClienteBusca = a.nomeCliente?.toLowerCase() ?? '';
        final termoBusca = filtroNome!.toLowerCase();
        return nomeServico.contains(termoBusca) || nomeClienteBusca.contains(termoBusca);
      }).toList();
    }
    if (filtroDataInicio != null || filtroDataFim != null) {
      resultado = resultado.where((a) {
        final dataParaComparar = tipoFiltroData == 'criacao' 
            ? a.criadoEm 
            : a.data;
        
        if (dataParaComparar == null) return false;

        final dataComparar = DateTime(
          dataParaComparar.year,
          dataParaComparar.month,
          dataParaComparar.day,
        );

        if (filtroDataInicio != null && filtroDataFim != null) {
          final inicio = DateTime(
            filtroDataInicio!.year,
            filtroDataInicio!.month,
            filtroDataInicio!.day,
          );
          final fim = DateTime(
            filtroDataFim!.year,
            filtroDataFim!.month,
            filtroDataFim!.day,
            23,
            59,
            59,
          );
          return dataComparar.isAfter(inicio.subtract(Duration(seconds: 1))) &&
                 dataComparar.isBefore(fim.add(Duration(seconds: 1)));
        } else if (filtroDataInicio != null) {
          final inicio = DateTime(
            filtroDataInicio!.year,
            filtroDataInicio!.month,
            filtroDataInicio!.day,
          );
          return dataComparar.isAfter(inicio.subtract(Duration(seconds: 1)));
        } else if (filtroDataFim != null) {
          final fim = DateTime(
            filtroDataFim!.year,
            filtroDataFim!.month,
            filtroDataFim!.day,
            23,
            59,
            59,
          );
          return dataComparar.isBefore(fim.add(Duration(seconds: 1)));
        }

        return true;
      }).toList();
    }

    return resultado;
  }

  bool get temFiltrosAtivos {
    return filtroStatus != null ||
           filtroNome != null ||
           filtroDataInicio != null ||
           filtroDataFim != null;
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