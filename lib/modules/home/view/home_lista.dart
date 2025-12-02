import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/state/lista_state.dart';
import 'package:trabfinal/modules/home/view/components/card_lista.dart';
import 'package:trabfinal/modules/home/view/components/dialog_filtros.dart';
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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1A1A),
            centerTitle: true,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Baguadrix",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "sua agenda digital",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: controller,
                          child: const DialogFiltros(),
                        ),
                      );
                    },
                    tooltip: 'Filtros',
                  ),
                  if (state.temFiltrosAtivos)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              if (state.temFiltrosAtivos)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  color: Colors.grey[200],
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (state.filtroStatus != null)
                        _chipFiltroAtivo(
                          context,
                          _nomeStatus(state.filtroStatus!),
                          () => controller.aplicarFiltroStatus(null),
                        ),
                      if (state.filtroNome != null)
                        _chipFiltroAtivo(
                          context,
                          'Nome: ${state.filtroNome}',
                          () => controller.aplicarFiltroNome(null),
                        ),
                      if (state.filtroDataInicio != null ||
                          state.filtroDataFim != null)
                        _chipFiltroAtivo(
                          context,
                          _textoFiltroData(
                            state.filtroDataInicio,
                            state.filtroDataFim,
                          ),
                          () => controller.limparFiltroData(),
                        ),
                      ActionChip(
                        label: const Text(
                          'Limpar tudo',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        onPressed: () => controller.limparTodosFiltros(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: atendimentos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              state.temFiltrosAtivos
                                  ? 'Nenhum atendimento encontrado\ncom os filtros aplicados'
                                  : 'Nenhum atendimento cadastrado',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            if (state.temFiltrosAtivos) ...[
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    controller.limparTodosFiltros(),
                                child: Text('Limpar Filtros'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => controller.carregarAtendimentos(),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final atendimento = atendimentos[index];
                            return CardLista(
                              atendimentoCard: atendimento,
                            );
                          },
                          itemCount: atendimentos.length,
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CadastrarAtendimentoView(),
                ),
              );
              controller.carregarAtendimentos();
            },
            backgroundColor: const Color(0xFF1A1A1A),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Novo',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _chipFiltroAtivo(
    BuildContext context,
    String label,
    VoidCallback onRemove,
  ) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onRemove,
      backgroundColor: Colors.blue[100],
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  String _nomeStatus(int status) {
    switch (status) {
      case 0:
        return 'Pendentes';
      case 1:
        return 'Aguardo';
      case 2:
        return 'Concluídos';
      case 3:
        return 'Inativos';
      default:
        return 'Status: $status';
    }
  }

  String _textoFiltroData(DateTime? inicio, DateTime? fim) {
    if (inicio != null && fim != null) {
      return 'De ${inicio.day}/${inicio.month} até ${fim.day}/${fim.month}';
    } else if (inicio != null) {
      return 'A partir de ${inicio.day}/${inicio.month}/${inicio.year}';
    } else if (fim != null) {
      return 'Até ${fim.day}/${fim.month}/${fim.year}';
    }
    return 'Data';
  }
}