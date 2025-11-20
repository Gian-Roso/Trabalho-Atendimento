import 'package:flutter/material.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'status_chip.dart';
import 'options_menu.dart';


class CardLista extends StatelessWidget {
  final AtendimentoModel atendimentoCard;
  CardLista({super.key, required this.atendimentoCard});

  @override
  Widget build(BuildContext context) {
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
                          onSelected: (value) {
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 6),
                Text(
                  "Descrição ou detalhes...",
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),

                SizedBox(height: 4),
                Text(
                  "Cliente: Fulano de Tal",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "${atendimentoCard.data.day}/${atendimentoCard.data.month}/${atendimentoCard.data.year}",
                      style: TextStyle(color: Colors.black45),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "${atendimentoCard.data.hour.toString().padLeft(2,'0')}:${atendimentoCard.data.minute.toString().padLeft(2,'0')}",
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
