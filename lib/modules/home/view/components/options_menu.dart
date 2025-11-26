import 'package:flutter/material.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/view/pages/cadastrar_atendimento_view.dart';

class OptionsMenu extends StatelessWidget {
  final void Function(int value)? onSelected;
  final Future<void> Function(int value) deleteF;
  final void Function(AtendimentoModel atendimento, int value) editF;
  final void Function(AtendimentoModel atendimento, int value) inativF;
  final void Function(int value) detalharF;
  final AtendimentoModel atendimento;

  const OptionsMenu({
    super.key,
    this.onSelected,
    required this.deleteF,
    required this.editF,
    required this.inativF,
    required this.detalharF,
    required this.atendimento,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (onSelected != null) {
          onSelected!(value);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            if (atendimento.id != null) {
              detalharF(atendimento.id!);
            }
          },
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
          onTap: () async {
            await Future.delayed(Duration.zero);
            if (context.mounted) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CadastrarAtendimentoView(
                    atendimentoParaEditar: atendimento, 
                  ),
                ),
              );
            }
          },
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
          onTap: () {
            if (atendimento.id != null) {
              final atendimentoInativo = atendimento.copyWith(status: 2); // Status 2 = Inativo
              inativF(atendimentoInativo, atendimento.id!);
            }
          },
          child: Row(
            children: const [
              Icon(Icons.block, size: 18),
              SizedBox(width: 8),
              Text("Inativar"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          onTap: () async {
            // Deletar
            if (atendimento.id != null) {
              await deleteF(atendimento.id!);
            }
          },
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
    );
  }
}