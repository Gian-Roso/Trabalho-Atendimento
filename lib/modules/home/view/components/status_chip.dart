import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final int status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _statusIcon(status),
          const SizedBox(width: 5),
          Text(
            _statusText(status),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: _statusColor(status),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _statusText(int status) {
    switch (status) {
      case 0: return "pendente";
      case 1: return "aguardo";
      case 2: return "Concluído";
      case 3: return "inativo";
      default: return "indefinido";
    }
  }
  Icon _statusIcon(int status) {
    switch (status) {
      case 0: return const Icon(Icons.schedule, size: 14, color: Colors.white);
      case 1: return const Icon(Icons.hourglass_empty, size: 14, color: Colors.white);
      case 2: return const Icon(Icons.check_circle, size: 14, color: Colors.white);
      case 3: return const Icon(Icons.block, size: 14, color: Colors.white);
      default: return const Icon(Icons.help_outline, size: 14, color: Colors.white);
    }
  }

  Color _statusColor(int status) {
    switch (status) {
      case 0: return const Color.fromARGB(255, 245, 45, 62);
      case 1: return const Color.fromARGB(255, 63, 177, 162);
      case 2: return const Color.fromARGB(255, 80, 219, 98);
      case 3: return Colors.black;
      default: return const Color.fromARGB(255, 255, 208, 0);
    }
  }
}
