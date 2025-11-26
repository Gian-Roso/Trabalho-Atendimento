import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trabfinal/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/state/lista_state.dart';

@injectable
class ListaController extends Cubit<ListaState> {
  final AtendimentoUsecase atendimentoUsecase;

  ListaController(this.atendimentoUsecase) : super(ListaInicial()) {
    carregarAtendimentos();
  }

  // ================= CARREGAR =================
  
  Future<void> carregarAtendimentos() async {
    emit(ListaCarregando());
    try {
      final atendimentos = await atendimentoUsecase.getAtendimentos();
      emit(ListaCarregada(atendimentos: atendimentos));
    } catch (e) {
      emit(ListaErro('Erro ao carregar atendimentos: $e'));
    }
  }

  // ================= DELETAR =================
  
  Future<void> deletarAtendimento(int id) async {
    try {
      await atendimentoUsecase.deleteAtendimento(id);
      await carregarAtendimentos();
      emit(ListaOperacaoSucesso('Atendimento excluído com sucesso!'));
      await carregarAtendimentos(); // Recarrega para voltar ao estado normal
    } catch (e) {
      emit(ListaErro('Erro ao deletar: $e'));
      await carregarAtendimentos();
    }
  }

  Future<void> deletarSelecionados(Set<int> ids) async {
    emit(ListaCarregando());
    try {
      for (final id in ids) {
        await atendimentoUsecase.deleteAtendimento(id);
      }
      await carregarAtendimentos();
      emit(ListaOperacaoSucesso('${ids.length} atendimento(s) excluído(s)!'));
      await carregarAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao deletar selecionados: $e'));
      await carregarAtendimentos();
    }
  }

  // ================= ATUALIZAR =================
  
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

  Future<void> concluirAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    final atendimentoConcluido = atendimento.copyWith(status: 2);
    await atualizarAtendimento(atendimentoConcluido);
  }

  Future<void> inativarAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    final atendimentoInativo = atendimento.copyWith(status: 3);
    await atualizarAtendimento(atendimentoInativo);
  }

  Future<void> concluirSelecionados(Set<int> ids) async {
    if (state is! ListaCarregada) return;
    
    emit(ListaCarregando());
    try {
      final estadoAtual = state as ListaCarregada;
      for (final id in ids) {
        final atendimento = estadoAtual.atendimentos.firstWhere((a) => a.id == id);
        await atendimentoUsecase.putAtendimento(
          atendimento.copyWith(status: 2),
          id,
        );
      }
      await carregarAtendimentos();
      emit(ListaOperacaoSucesso('${ids.length} atendimento(s) concluído(s)!'));
      await carregarAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao concluir selecionados: $e'));
      await carregarAtendimentos();
    }
  }

  // ================= FILTROS =================
  
  void aplicarFiltro(int? status) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(
        filtroStatus: status,
        itensSelecionados: {}, // Limpa seleção ao filtrar
      ));
    }
  }

  void limparFiltro() {
    aplicarFiltro(null);
  }

  // ================= SELEÇÃO =================
  
  void toggleSelecao(int id) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      final novaSelecao = Set<int>.from(estadoAtual.itensSelecionados);
      
      if (novaSelecao.contains(id)) {
        novaSelecao.remove(id);
      } else {
        novaSelecao.add(id);
      }
      
      emit(estadoAtual.copyWith(itensSelecionados: novaSelecao));
    }
  }

  void limparSelecao() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(itensSelecionados: {}));
    }
  }

  void selecionarTodos() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      final todosIds = estadoAtual.atendimentosFiltrados
          .where((a) => a.id != null)
          .map((a) => a.id!)
          .toSet();
      emit(estadoAtual.copyWith(itensSelecionados: todosIds));
    }
  }
}