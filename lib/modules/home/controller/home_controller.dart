import 'package:Baquadrix/modules/home/core/domain/contract/usecase/atendimento_usecase.dart';
import 'package:Baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:Baquadrix/modules/home/state/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeController extends Cubit<HomeState>{
  final AtendimentoUsecase atendimentoUsecase;
  
  HomeController(this.atendimentoUsecase) : super(HomeCarregando()){
    getAtendimentos();
  }
  
  Future<void> deleteAtendimento(int id) async { 
      emit(HomeCarregando());
      await atendimentoUsecase.deleteAtendimento(id);
      await getAtendimentos();
  }

  
  Future<void> getAtendimento(int id) async {  
      emit(HomeCarregando());
      final atendimento = await atendimentoUsecase.getAtendimento(id);
      emit(HomeCarregado([atendimento]));
  }      

  
  Future<void> getAtendimentos() async { 
      emit(HomeCarregando());
      final atendimentos = await atendimentoUsecase.getAtendimentos();
      emit(HomeCarregado(atendimentos));
  }

  
  Future<void> postAtendimento(AtendimentoModel atendimentoModel) async { 
      emit(HomeCarregando());
      await atendimentoUsecase.postAtendimento(atendimentoModel);
      await getAtendimentos();
  }

  
  Future<void> putAtendimento(AtendimentoModel atendimentoModel, int id) async {   
    emit(HomeCarregando());
    await atendimentoUsecase.putAtendimento(atendimentoModel, id);
    await getAtendimentos();
  }

}