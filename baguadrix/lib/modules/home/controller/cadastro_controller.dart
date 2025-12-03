import 'package:baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:baquadrix/modules/home/core/service/notification_service.dart';
import 'package:baquadrix/modules/home/state/cadastro_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CadastroController extends Cubit<CadastroState> {
  final AtendimentoUsecase atendimentoUsecase;
  final NotificationService _notificationService = NotificationService();


  CadastroController(this.atendimentoUsecase) : super(CadastroNovo());

  void atualizarNome(String nome) {
    emit(state.copyWith(nome: nome));
  }

  void atualizarNomeCliente(String nomeCliente) { 
    emit(state.copyWith(nomeCliente: nomeCliente));
  }

  void atualizarDescricao(String descricao) {
    emit(state.copyWith(descricao: descricao));
  }

  void atualizarImagem(String path) {
    emit(state.copyWith(imagemSelecionada: path));
  }

  void atualizarImagemFinalizacao(String path) {
    emit(state.copyWith(imagemFinalizacao: path));
  }

  void atualizarHora(DateTime hora) {
    emit(state.copyWith(horaSelecionada: hora));
  }

  void atualizarStatus(int status) {
    emit(state.copyWith(statusSelecionado: status));
  }

  void carregarAtendimento(AtendimentoModel atendimento) {
    emit(CadastroAtualizar(atendimento));
  }

  void limparFormulario() {
    emit(CadastroNovo());
  }

  Future<AtendimentoModel> postCadastro(AtendimentoModel atendimentoModel) async {
  final atendimentoSalvo = await atendimentoUsecase.postAtendimento(atendimentoModel);

    if (atendimentoSalvo.id != null) {
      await _notificationService.agendarNotificacaoAtendimento(
        id: atendimentoSalvo.id!,
        titulo: 'Atendimento: ${atendimentoSalvo.nome}',
        corpo: atendimentoSalvo.nomeCliente != null
            ? 'Cliente: ${atendimentoSalvo.nomeCliente}'
            : 'Atendimento agendado',
        dataHora: atendimentoSalvo.data,
      );
    }
    
    emit(CadastroNovo());
    return atendimentoSalvo; 
  }

  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
  await atendimentoUsecase.putAtendimento(atendimentoModel, id);
  
  await _notificationService.cancelarNotificacao(id);
  await _notificationService.agendarNotificacaoAtendimento(
    id: id,
    titulo: 'Atendimento: ${atendimentoModel.nome}',
    corpo: atendimentoModel.nomeCliente != null
        ? 'Cliente: ${atendimentoModel.nomeCliente}'
        : 'Atendimento agendado',
    dataHora: atendimentoModel.data,
  );
  
  emit(CadastroNovo());
}
  
  
}