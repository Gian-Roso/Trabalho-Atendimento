import 'package:Baquadrix/modules/home/core/domain/contract/repository/atendimento_repository.dart';
import 'package:Baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:Baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AtendimentoUsecase)
class AtendimentoUsecaseImpl implements AtendimentoUsecase {
  final AtendimentoRepository repository; 

  AtendimentoUsecaseImpl({
    required this.repository, 
  });

  @override
  Future<List<AtendimentoModel>> getAtendimentos() async {
    return await repository.getAtendimentos();
  }

  @override
  Future<AtendimentoModel> getAtendimento(int id) async {
    return await repository.getAtendimento(id);
  }

  @override
  Future<AtendimentoModel> postAtendimento(AtendimentoModel atendimentoModel) async {
    return await repository.postAtendimento(atendimentoModel); 
  }

  @override
  Future<AtendimentoModel> putAtendimento(AtendimentoModel atendimentoModel, int id) async {
    return await repository.putAtendimento(atendimentoModel, id);
  }

  @override
  Future<void> deleteAtendimento(int id) async {
    return await repository.deleteAtendimento(id);
  }
}