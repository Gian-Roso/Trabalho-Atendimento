import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trabfinal/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/state/cadastro_state.dart';

@injectable
class CadastroController extends Cubit<CadastroState> {
  final AtendimentoUsecase atendimentoUsecase;

  CadastroController(this.atendimentoUsecase) : super(CadastroNovo());

  // ================= Atualizações individuais =================

  void atualizarNome(String nome) {
    emit(state.copyWith(nome: nome));
  }

  void atualizarDescricao(String descricao) {
    emit(state.copyWith(descricao: descricao));
  }

  void atualizarImagem(String path) {
    emit(state.copyWith(imagemSelecionada: path));
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

  // ✅ NOVO: Método para limpar formulário
  void limparFormulario() {
    emit(CadastroNovo());
  }

  Future<AtendimentoModel> postCadastro(AtendimentoModel atendimentoModel) async {
  final atendimentoSalvo = await atendimentoUsecase.postAtendimento(atendimentoModel);
  emit(CadastroNovo());
  return atendimentoSalvo; 
  }

  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
    await atendimentoUsecase.putAtendimento(atendimentoModel, id);
    emit(CadastroNovo());
  }
}
