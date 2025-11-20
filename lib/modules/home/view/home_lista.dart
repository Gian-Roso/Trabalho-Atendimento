import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/view/components/card_lista.dart';

class HomeLista extends StatelessWidget {
  final List<AtendimentoModel>? atendimento;
  HomeLista({super.key, this.atendimento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atendimentos", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(202, 32, 31, 31),
      ),
      body: Center(child: ListView.builder(
        itemBuilder: (context, index) {return CardLista(atendimentoCard:AtendimentoModel(nome: 'Judas', data: DateTime.now(), status: 1),);}, 
        // itemCount: atendimento?.length,
        itemCount: 5,
      ),), 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black12,
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.filter), label: "teste"),
        BottomNavigationBarItem(icon: Icon(Icons.more), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.close), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.delete), label: ""),
      ]),
    );
  }
}