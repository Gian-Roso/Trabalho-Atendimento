import 'package:baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:baquadrix/modules/home/core/service/notification_service.dart';
import 'package:baquadrix/modules/home/state/lista_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListaController extends Cubit<ListaState> {
  final AtendimentoUsecase atendimentoUsecase;
  final NotificationService _notificationService = NotificationService();

  ListaController(this.atendimentoUsecase) : super(ListaInicial()) {
    getAtendimentos();
  }

  Future<void> getAtendimentos() async {
    emit(ListaCarregando());
    try {
      final atendimentos = await atendimentoUsecase.getAtendimentos();
      emit(ListaCarregada(atendimentos: atendimentos));
    } catch (e) {
      emit(ListaErro('Erro ao carregar atendimentos: $e'));
    }
  }

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

  Future<void> deletarSelecionados() async {
    if (state is! ListaCarregada) return;
    
    final estadoAtual = state as ListaCarregada;
    final ids = estadoAtual.itensSelecionados;
    
    if (ids.isEmpty) return;

    try {
      for (final id in ids) {
        await atendimentoUsecase.deleteAtendimento(id);
        await _notificationService.cancelarNotificacao(id);
      }
      
      emit(ListaOperacaoSucesso('${ids.length} atendimento(s) excluído(s)!'));
      await getAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao deletar selecionados: $e'));
      await getAtendimentos();
    }
  }

  Future<void> concluirSelecionados() async {
    if (state is! ListaCarregada) return;
    
    final estadoAtual = state as ListaCarregada;
    final ids = estadoAtual.itensSelecionados;
    
    if (ids.isEmpty) return;

    try {
      final atendimentos = estadoAtual.atendimentos
          .where((a) => ids.contains(a.id))
          .toList();

      for (final atendimento in atendimentos) {
        if (atendimento.id != null) {
          final atendimentoConcluido = atendimento.copyWith(status: 2);
          await atendimentoUsecase.putAtendimento(
            atendimentoConcluido,
            atendimento.id!,
          );
          await _notificationService.cancelarNotificacao(atendimento.id!);
        }
      }
      
      emit(ListaOperacaoSucesso('${ids.length} atendimento(s) concluído(s)!'));
      await getAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao concluir selecionados: $e'));
      await getAtendimentos();
    }
  }

  Future<void> inativarSelecionados() async {
    if (state is! ListaCarregada) return;
    
    final estadoAtual = state as ListaCarregada;
    final ids = estadoAtual.itensSelecionados;
    
    if (ids.isEmpty) return;

    try {
      final atendimentos = estadoAtual.atendimentos
          .where((a) => ids.contains(a.id))
          .toList();

      for (final atendimento in atendimentos) {
        if (atendimento.id != null) {
          final atendimentoInativo = atendimento.copyWith(status: 3);
          await atendimentoUsecase.putAtendimento(
            atendimentoInativo,
            atendimento.id!,
          );
          await _notificationService.cancelarNotificacao(atendimento.id!);
        }
      }
      
      emit(ListaOperacaoSucesso('${ids.length} atendimento(s) inativado(s)!'));
      await getAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao inativar selecionados: $e'));
      await getAtendimentos();
    }
  }

  Future<void> deletarAtendimento(int id) async {
    try {
      await atendimentoUsecase.deleteAtendimento(id);
      await _notificationService.cancelarNotificacao(id);
      emit(ListaOperacaoSucesso('Atendimento excluído com sucesso!'));
      await getAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao deletar: $e'));
      await getAtendimentos();
    }
  }

  Future<void> atualizarAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    try {
      await atendimentoUsecase.putAtendimento(atendimento, atendimento.id!);
      emit(ListaOperacaoSucesso('Atendimento atualizado!'));
      await getAtendimentos();
    } catch (e) {
      emit(ListaErro('Erro ao atualizar: $e'));
      await getAtendimentos();
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
    
    await atendimentoUsecase.putAtendimento(
      atendimentoConcluido,
      atendimento.id!,
    );
    await _notificationService.cancelarNotificacao(atendimento.id!);
    
    emit(ListaOperacaoSucesso('Atendimento concluído!'));
    await getAtendimentos();
  }

  Future<void> inativarAtendimento(AtendimentoModel atendimento) async {
    if (atendimento.id == null) return;
    
    final atendimentoInativo = atendimento.copyWith(status: 3);
    await atendimentoUsecase.putAtendimento(
      atendimentoInativo,
      atendimento.id!,
    );
    await _notificationService.cancelarNotificacao(atendimento.id!);
    
    emit(ListaOperacaoSucesso('Atendimento inativado!'));
    await getAtendimentos();
  }

  void aplicarFiltroStatus(int? status) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(
        filtroStatus: status,
        itensSelecionados: {}, 
      ));
    }
  }

  void aplicarFiltroNome(String? nome) {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      if (nome == null || nome.isEmpty) {
        emit(estadoAtual.copyWith(
          limparFiltroNome: true,
          itensSelecionados: {},
        ));
      } else {
        emit(estadoAtual.copyWith(
          filtroNome: nome,
          itensSelecionados: {},
        ));
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
        itensSelecionados: {},
      ));
    }
  }

  void limparTodosFiltros() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(ListaCarregada(
        atendimentos: estadoAtual.atendimentos,
        itensSelecionados: {},
      ));
    }
  }

  void limparFiltroData() {
    if (state is ListaCarregada) {
      final estadoAtual = state as ListaCarregada;
      emit(estadoAtual.copyWith(
        limparFiltroData: true,
        itensSelecionados: {},
      ));
    }
  }
}