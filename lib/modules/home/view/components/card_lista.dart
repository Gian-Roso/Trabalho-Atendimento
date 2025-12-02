import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'status_chip.dart';
import 'options_menu.dart';

class CardLista extends StatelessWidget {
  final AtendimentoModel atendimentoCard;

  const CardLista({
    super.key,
    required this.atendimentoCard,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ListaController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(9.5),
        child: Card(
          elevation: 1.3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 12,
              right: 12,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        atendimentoCard.nome,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        StatusChip(status: atendimentoCard.status),
                        OptionsMenu(
                          atendimento: atendimentoCard,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  atendimentoCard.descricao ?? "Sem descrição",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // ✅ Nome do Cliente
                if (atendimentoCard.nomeCliente != null) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.black54),
                      SizedBox(width: 4),
                      Text(
                        "Cliente: ${atendimentoCard.nomeCliente}",
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
                
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.black45),
                    SizedBox(width: 4),
                    Text(
                      "${atendimentoCard.data.day.toString().padLeft(2, '0')}/${atendimentoCard.data.month.toString().padLeft(2, '0')}/${atendimentoCard.data.year}",
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(width: 20),
                    Icon(Icons.access_time, size: 14, color: Colors.black45),
                    SizedBox(width: 4),
                    Text(
                      "${atendimentoCard.data.hour.toString().padLeft(2, '0')}:${atendimentoCard.data.minute.toString().padLeft(2, '0')}",
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}