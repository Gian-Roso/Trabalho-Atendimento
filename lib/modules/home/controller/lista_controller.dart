import 'package:Baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:Baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:Baquadrix/modules/home/state/lista_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListaController extends Cubit<ListaState> {
  final AtendimentoUsecase atendimentoUsecase;

  ListaController(this.atendimentoUsecase) : super(ListaInicial()) {
    carregarAtendimentos();
  }

  Future<void> carregarAtendimentos() async {
    emit(ListaCarregando());
    try {
      final atendimentos = await atendimentoUsecase.getAtendimentos();
      emit(ListaCarregada(atendimentos: atendimentos));
    } catch (e) {
      emit(ListaErro('Erro ao carregar atendimentos: $e'));
    }
  }

  Future<void> deletarAtendimento(int id) async {
    try {
      await atendimentoUsecase.deleteAtendimento(id);
      await carregarAtendimentos();
      emit(ListaOperacaoSucesso('Atendimento excluído com sucesso!'));
      await carregarAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao deletar: $e'));
      await carregarAtendimentos();
    }
  }

  Future<void> atualizarAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    try {
      await atendimentoUsecase.putAtendimento(atendimento, atendimento.id!);
      await carregarAtendimentos();
      emit(ListaOperacaoSucesso('Atendimento atualizado!'));
      await carregarAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao atualizar: $e'));
      await carregarAtendimentos();
    }
  }
  Future<void> concluirAtendimentoComFoto(
    AtendimentoModel atendimento,
    String fotoFinalizacao,
  ) async {
    if (atendimento.id == null) return;
    
    final atendimentoConcluido = atendimento.copyWith(
      status: 2,
      fotoFinalizacao: fotoFinalizacao,
    );
    await atualizarAtendimento(atendimentoConcluido);
  }

  Future<void> inativarAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    final atendimentoInativo = atendimento.copyWith(status: 3);
    await atualizarAtendimento(atendimentoInativo);
  }
  
  void aplicarFiltroStatus(int? status) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(filtroStatus: status));
    }
  }
  void aplicarFiltroNome(String? nome) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      if (nome == null || nome.isEmpty) {
        emit(estadoAtual.copyWith(limparFiltroNome: true));
      } else {
        emit(estadoAtual.copyWith(filtroNome: nome));
      }
    }
  }
  void aplicarFiltroData({
    DateTime? dataInicio,
    DateTime? dataFim,
    String tipoData = 'servico', 
  }) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(
        filtroDataInicio: dataInicio,
        filtroDataFim: dataFim,
        tipoFiltroData: tipoData,
      ));
    }
  }
  void limparTodosFiltros() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(ListaCarregada(
        atendimentos: estadoAtual.atendimentos,
      ));
    }
  }

  void limparFiltroData() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(limparFiltroData: true));
    }
  }
}