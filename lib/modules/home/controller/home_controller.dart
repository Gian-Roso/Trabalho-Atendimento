import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trabfinal/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/state/home_state.dart';

@injectable
class HomeController extends Cubit<HomeState> {
  final AtendimentoUsecase atendimentoUsecase;

  // filtros em memória (se quiser)
  List<AtendimentoModel> _all = [];

  HomeController(this.atendimentoUsecase) : super(HomeCarregando()) {
    getAtendimentos();
  }

  // =========================================================
  // LISTAGEM
  // =========================================================
  Future<void> getAtendimentos() async {
    emit(HomeCarregando());
    final atendimentos = await atendimentoUsecase.getAtendimentos();
    _all = atendimentos;
    emit(HomeCarregado(atendimentos));
  }

  Future<void> getAtendimento(int id) async {
    emit(HomeCarregando());
    final atendimento = await atendimentoUsecase.getAtendimento(id);
    emit(HomeCarregado([atendimento]));
  }

  // =========================================================
  // CRIAR
  // =========================================================
  Future<void> postAtendimento(AtendimentoModel atendimentoModel) async {
    emit(HomeCarregando());
    await atendimentoUsecase.postAtendimento(atendimentoModel);
    await getAtendimentos();
  }

  // =========================================================
  // ATUALIZAR  (CORRIGIDO)
  // =========================================================
  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
    emit(HomeCarregando());
    await atendimentoUsecase.putAtendimento(atendimentoModel, id);
    await getAtendimentos(); 
  }

  // =========================================================
  // DELETAR 1
  // =========================================================
  Future<void> deleteAtendimento(int id) async {
    emit(HomeCarregando());
    await atendimentoUsecase.deleteAtendimento(id);
    await getAtendimentos();
  }

  // =========================================================
  // DELETAR VÁRIOS
  // =========================================================
  Future<void> deleteVarios(List<int> ids) async {
    emit(HomeCarregando());
    await atendimentoUsecase.deleteVarios(ids);
    await getAtendimentos();
  }

  // =========================================================
  // FILTROS EM MEMÓRIA
  // =========================================================

  void filtrarPorNome(String nome) {
    final resultado =
        _all.where((a) => a.nome.toLowerCase().contains(nome.toLowerCase())).toList();

    emit(HomeCarregado(resultado));
  }

  void filtrarPorStatus(int status) {
    final resultado = _all.where((a) => a.status == status).toList();
    emit(HomeCarregado(resultado));
  }

  void filtrarPorData(DateTime data) {
    final resultado = _all.where((a) =>
        a.data.year == data.year &&
        a.data.month == data.month &&
        a.data.day == data.day).toList();

    emit(HomeCarregado(resultado));
  }

  void limparFiltros() {
    emit(HomeCarregado(_all));
  }
}
