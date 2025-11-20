import 'package:flutter/material.dart';

class OptionsMenu extends StatelessWidget {
  final void Function(int value)? onSelected;

  const OptionsMenu({super.key, this.onSelected});

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
              Icon(Icons.block, size: 18),
              SizedBox(width: 8),
              Text("Inativar"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
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
