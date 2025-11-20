import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/core/di/injection.dart';
import 'package:trabfinal/modules/home/controller/home_controller.dart';
import 'package:trabfinal/modules/home/state/home_state.dart';
import 'package:trabfinal/modules/home/view/home_lista.dart';

class HomeView extends StatelessWidget {
  final controller = getIt<HomeController>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => controller,
      child: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 16, 10, 19),
            body: Builder(
              builder: (context) {
                return state is HomeCarregado ?
                HomeLista(atendimento:state.atendimentos, reloadFunction: () async {
                  controller.getAtendimentos();
                }, deleteF: controller.deleteAtendimento, editF: controller.putAtendimento, inativF: controller.putAtendimento, detalharF: controller.getAtendimento,) :
                Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          );
        },
      ),
    );
  }
}
