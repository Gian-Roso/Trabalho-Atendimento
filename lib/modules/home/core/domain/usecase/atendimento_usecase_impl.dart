import 'package:injectable/injectable.dart';
import 'package:trabfinal/modules/home/core/domain/contract/repository/atendimento_repository.dart';
import 'package:trabfinal/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

@LazySingleton(as: AtendimentoUsecase)
class AtendimentoUsecaseImpl implements AtendimentoUsecase{
  final AtendimentoRepository atendimentoRepository;

  AtendimentoUsecaseImpl (this.atendimentoRepository);

  @override
  Future<void> deleteAtendimento(int id) async { 
      return await atendimentoRepository.deleteAtendimento(id);
  }

  @override
  Future<AtendimentoModel> getAtendimento(int id) async {  
    return await atendimentoRepository.getAtendimento(id);
  }      

  @override
  Future<List<AtendimentoModel>> getAtendimentos() async { 
      return await atendimentoRepository.getAtendimentos();
  }

  @override
  Future<void> postAtendimento(AtendimentoModel atendimentoModel) async { 
      return await atendimentoRepository.postAtendimento(atendimentoModel);
  }

  @override
  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {   
  return await atendimentoRepository.putAtendimento(atendimentoModel, id);
  }      
  @override
  Future<void> deleteVarios(List<int> ids) async {
  return await atendimentoRepository.deleteVarios(ids);
  }
}
