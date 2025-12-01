import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/core/di/injection.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/state/lista_state.dart';
import 'package:trabfinal/modules/home/view/home_lista.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ListaController>(),
      child: BlocConsumer<ListaController, ListaState>(
        listener: (context, state) {
          if (state is ListaOperacaoSucesso) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagem),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ListaErro) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.mensagem),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 16, 10, 19),
            body: Builder(
              builder: (context) {
                if (state is ListaCarregada) {
                  return HomeLista();
                } else if (state is ListaErro) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          state.mensagem,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ListaController>().carregarAtendimentos();
                          },
                          child: Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        },
      ),
    );
  }
}