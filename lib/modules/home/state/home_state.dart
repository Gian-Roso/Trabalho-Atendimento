import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

abstract class HomeState {}

class HomeCarregando extends HomeState {}

class HomeCarregado extends HomeState {
  final List<AtendimentoModel> atendimentos;
  HomeCarregado(this.atendimentos);
}
