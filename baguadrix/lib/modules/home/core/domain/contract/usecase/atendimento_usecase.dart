
import 'package:baquadrix/modules/home/core/domain/model/atendimento_model.dart';

abstract class AtendimentoUsecase {
  Future<List<AtendimentoModel>> getAtendimentos();
  Future<AtendimentoModel> getAtendimento(int id);
  Future<AtendimentoModel> postAtendimento(AtendimentoModel atendimentoModel); 
  Future<AtendimentoModel> putAtendimento(AtendimentoModel atendimentoModel, int id);
  Future<void> deleteAtendimento(int id);
}