import 'package:baquadrix/modules/home/controller/lista_controller.dart';
import 'package:baquadrix/modules/home/state/lista_state.dart';
import 'package:baquadrix/modules/home/view/components/card_lista.dart';
import 'package:baquadrix/modules/home/view/components/dialog_filtros.dart';
import 'package:baquadrix/modules/home/view/configuration/configuracoes_view.dart';
import 'package:baquadrix/modules/home/view/pages/cadastrar_atendimento_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLista extends StatelessWidget {
  const HomeLista({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListaController, ListaState>(
      builder: (context, state) {
        if (state is! ListaCarregada) {
          return const Center(child: CircularProgressIndicator());
        }

        final controller = context.read<ListaController>();
        final modoSelecao = state.itensSelecionados.isNotEmpty;
        final quantidadeSelecionada = state.itensSelecionados.length;

        return Scaffold(
          appBar: modoSelecao
              ? _buildSelectionAppBar(context, quantidadeSelecionada)
              : _buildNormalAppBar(context, state),
          body: state.atendimentosFiltrados.isEmpty
              ? _buildEmptyState(state.temFiltrosAtivos)
              : ListView.builder(
                  itemCount: state.atendimentosFiltrados.length,
                  itemBuilder: (context, index) {
                    final atendimento = state.atendimentosFiltrados[index];
                    return CardLista(atendimento: atendimento);
                  },
                ),
          floatingActionButton: !modoSelecao
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CadastrarAtendimentoView(),
                      ),
                    );
                    controller.getAtendimentos();
                  },
                  backgroundColor: const Color(0xFF1A1A1A),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Novo',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildNormalAppBar(
    BuildContext context,
    ListaCarregada state,
  ) {
    return AppBar(
      title: const Text(
        'Baguadrix',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      actions: [
        // Indicador de filtros ativos
        if (state.temFiltrosAtivos)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_alt, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                const Text(
                  'Filtros ativos',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),

        // Botão de filtros
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<ListaController>(),
                child: const DialogFiltros(),
              ),
            );
          },
        ),

        // Botão de configurações
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ConfiguracoesView(),
              ),
            );
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(
    BuildContext context,
    int quantidade,
  ) {
    final controller = context.read<ListaController>();

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => controller.limparSelecao(),
      ),
      title: Text(
        '$quantidade selecionado(s)',
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      actions: [

        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.white),
          tooltip: 'Selecionar todos',
          onPressed: () => controller.selecionarTodos(),
        ),

        IconButton(
          icon: const Icon(Icons.check_circle, color: Colors.white),
          tooltip: 'Concluir selecionados',
          onPressed: () async {
            final confirma = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Concluir Atendimentos'),
                content: Text(
                  'Deseja concluir $quantidade atendimento(s) selecionado(s)?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Concluir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            if (confirma == true) {
              await controller.concluirSelecionados();
            }
          },
        ),

        IconButton(
          icon: const Icon(Icons.block, color: Colors.white),
          tooltip: 'Inativar selecionados',
          onPressed: () async {
            final confirma = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Inativar Atendimentos'),
                content: Text(
                  'Deseja inativar $quantidade atendimento(s) selecionado(s)?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Inativar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            if (confirma == true) {
              await controller.inativarSelecionados();
            }
          },
        ),

        IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          tooltip: 'Deletar selecionados',
          onPressed: () async {
            final confirma = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Excluir Atendimentos'),
                content: Text(
                  'Deseja excluir permanentemente $quantidade atendimento(s) selecionado(s)?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );

            if (confirma == true) {
              await controller.deletarSelecionados();
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool temFiltros) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            temFiltros ? Icons.search_off : Icons.event_note,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            temFiltros
                ? 'Nenhum atendimento encontrado'
                : 'Nenhum atendimento cadastrado',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            temFiltros
                ? 'Tente ajustar os filtros'
                : 'Toque em + para adicionar',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}