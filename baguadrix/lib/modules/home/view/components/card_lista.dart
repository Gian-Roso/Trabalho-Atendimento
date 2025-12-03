import 'package:baquadrix/modules/home/controller/lista_controller.dart';
import 'package:baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:baquadrix/modules/home/state/lista_state.dart';
import 'package:baquadrix/modules/home/view/components/options_menu.dart';
import 'package:baquadrix/modules/home/view/components/status_chip.dart';
import 'package:baquadrix/modules/home/view/pages/detalhes_atendimento_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardLista extends StatelessWidget {
  final AtendimentoModel atendimento;

  const CardLista({
    super.key,
    required this.atendimento,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListaController, ListaState>(
      builder: (context, state) {
        final bool modoSelecao = state is ListaCarregada && 
                                 state.itensSelecionados.isNotEmpty;
        final bool estaSelecionado = state is ListaCarregada && 
                                     atendimento.id != null &&
                                     state.itensSelecionados.contains(atendimento.id);

        return GestureDetector(
          onLongPress: () {
            if (atendimento.id != null) {
              context.read<ListaController>().toggleSelecao(atendimento.id!);
            }
          },
          onTap: () {
            if (modoSelecao && atendimento.id != null) {
              context.read<ListaController>().toggleSelecao(atendimento.id!);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesAtendimentoView(
                    atendimento: atendimento,
                  ),
                ),
              );
            }
          },
          child: Card(
            color: estaSelecionado 
                ? Colors.blue.withOpacity(0.2) 
                : Colors.white,
            elevation: estaSelecionado ? 8 : 2,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: estaSelecionado 
                  ? const BorderSide(color: Colors.blue, width: 2)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  if (modoSelecao)
                    Checkbox(
                      value: estaSelecionado,
                      onChanged: (value) {
                        if (atendimento.id != null) {
                          context.read<ListaController>()
                              .toggleSelecao(atendimento.id!);
                        }
                      },
                    ),

                  // Informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          atendimento.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (atendimento.nomeCliente != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Cliente: ${atendimento.nomeCliente}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${atendimento.data.day.toString().padLeft(2, '0')}/${atendimento.data.month.toString().padLeft(2, '0')}/${atendimento.data.year}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${atendimento.data.hour.toString().padLeft(2, '0')}:${atendimento.data.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        StatusChip(status: atendimento.status),
                      ],
                    ),
                  ),

                  if (!modoSelecao)
                    OptionsMenu(atendimento: atendimento),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}