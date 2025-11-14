import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

abstract class AtendimentoRepository {
   Future<List<AtendimentoModel>> getAtendimentos();
   Future<AtendimentoModel> getAtendimento(int id);
   Future<void> postAtendimento(AtendimentoModel atendimentoModel);
   Future<void> deleteAtendimento(int id);
   Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id);

}