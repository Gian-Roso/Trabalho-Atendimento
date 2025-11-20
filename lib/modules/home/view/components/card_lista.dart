import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

class CardLista extends StatelessWidget {
  final AtendimentoModel atendimentoCard;
 CardLista({super.key,required this.atendimentoCard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(padding: EdgeInsetsGeometry.all(9.5), child: Card(
        elevation: 1.3,
        child:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(atendimentoCard.nome), 
                  Row(
                    spacing: 14,
                    children: [
                      Chip(label: Text('status')),
                      ElevatedButton(onPressed: null, child: Icon(Icons.kebab_dining_rounded)),
                    ],
                  )
                ],
              ),
              Text("Descicao"),
              Text("cliente"),
              Text(atendimentoCard.data.toString()),
            ],
          ),
        ),
      ),),
    );
  }
}