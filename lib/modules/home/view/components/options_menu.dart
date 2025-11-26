import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/view/pages/cadastrar_atendimento_view.dart';
import 'package:trabfinal/modules/home/view/pages/detalhes_atendimento_view.dart';

class OptionsMenu extends StatelessWidget {
  final AtendimentoModel atendimento;

  const OptionsMenu({
    super.key,
    required this.atendimento,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ListaController>();

    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: const [
              Icon(Icons.visibility, size: 18),
              SizedBox(width: 8),
              Text("Ver Detalhes"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: const [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 8),
              Text("Alterar"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            children: const [
              Icon(Icons.check, size: 18, color: Colors.green),
              SizedBox(width: 8),
              Text("Concluir"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            children: const [
              Icon(Icons.block, size: 18),
              SizedBox(width: 8),
              Text("Inativar"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Row(
            children: const [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "Excluir",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case 1: // Ver detalhes
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetalhesAtendimentoView(
                  atendimento: atendimento,
                ),
              ),
            );
            break;

          case 2: // Editar
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CadastrarAtendimentoView(
                  atendimentoParaEditar: atendimento,
                ),
              ),
            );
            controller.carregarAtendimentos();
            break;

          case 3: // Concluir
            await controller.concluirAtendimento(atendimento);
            break;

          case 4: // Inativar
            await controller.inativarAtendimento(atendimento);
            break;

          case 5: // Excluir
            final confirma = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Confirmar Exclusão'),
                content: Text('Deseja excluir "${atendimento.nome}"?'),
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

            if (confirma == true && atendimento.id != null) {
              await controller.deletarAtendimento(atendimento.id!);
            }
            break;
        }
      },
    );
  }
}