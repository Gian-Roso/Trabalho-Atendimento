import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/state/lista_state.dart';
import 'package:trabfinal/modules/home/view/components/card_lista.dart';
import 'package:trabfinal/modules/home/view/pages/cadastrar_atendimento_view.dart';

class HomeLista extends StatelessWidget {
  const HomeLista({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListaController, ListaState>(
      builder: (context, state) {
        if (state is! ListaCarregada) {
          return Center(child: CircularProgressIndicator());
        }

        final controller = context.read<ListaController>();
        final atendimentos = state.atendimentosFiltrados;
        final itensSelecionados = state.itensSelecionados;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1A1A),
            centerTitle: true,
            title: itensSelecionados.isEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Quadrix",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        "sua agenda digital",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  )
                : Text(
                    "${itensSelecionados.length} selecionado(s)",
                    style: TextStyle(color: Colors.white),
                  ),
            actions: itensSelecionados.isEmpty
                ? [
                    // Botão de filtro
                    PopupMenuButton<int?>(
                      icon: Icon(Icons.filter_list, color: Colors.white),
                      onSelected: (filtro) {
                        controller.aplicarFiltro(filtro);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: null,
                          child: Row(
                            children: [
                              Icon(Icons.clear_all),
                              SizedBox(width: 8),
                              Text('Todos'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.pending, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('Pendentes'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.schedule, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Aguardo'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text('Concluídos'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(Icons.block, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Inativos'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]
                : [
                    // Botão de concluir selecionados
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await controller.concluirSelecionados(itensSelecionados);
                      },
                      tooltip: 'Concluir selecionados',
                    ),
                    // Botão de deletar selecionados
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirma = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmar Exclusão'),
                            content: Text(
                                'Deseja excluir ${itensSelecionados.length} atendimento(s)?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Excluir',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirma == true) {
                          await controller.deletarSelecionados(itensSelecionados);
                        }
                      },
                      tooltip: 'Excluir selecionados',
                    ),
                    // Botão de cancelar seleção
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        controller.limparSelecao();
                      },
                      tooltip: 'Cancelar',
                    ),
                  ],
          ),
          body: atendimentos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        state.filtroStatus == null
                            ? 'Nenhum atendimento cadastrado'
                            : 'Nenhum atendimento encontrado',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => controller.carregarAtendimentos(),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final atendimento = atendimentos[index];
                      final isSelected =
                          itensSelecionados.contains(atendimento.id);

                      return GestureDetector(
                        onLongPress: () {
                          if (atendimento.id != null) {
                            controller.toggleSelecao(atendimento.id!);
                          }
                        },
                        onTap: itensSelecionados.isEmpty
                            ? null
                            : () {
                                if (atendimento.id != null) {
                                  controller.toggleSelecao(atendimento.id!);
                                }
                              },
                        child: Container(
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
                                )
                              : null,
                          child: CardLista(
                            atendimentoCard: atendimento,
                          ),
                        ),
                      );
                    },
                    itemCount: atendimentos.length,
                  ),
                ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF1A1A1A),
            unselectedItemColor: Colors.white70,
            selectedItemColor: Colors.white,
            currentIndex: 0,
            onTap: (index) async {
              if (index == 1) {
                // Adicionar
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastrarAtendimentoView(),
                  ),
                );
                controller.carregarAtendimentos();
              } else if (index == 2 && itensSelecionados.isNotEmpty) {
                // Concluir selecionados
                await controller.concluirSelecionados(itensSelecionados);
              } else if (index == 3) {
                // Ativar modo seleção
                if (itensSelecionados.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Pressione e segure nos cards para selecionar'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.filter_alt), label: "Filtrar"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: "Adicionar"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check), label: "Concluir"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.select_all), label: "Selecionar"),
            ],
          ),
        );
      },
    );
  }
}