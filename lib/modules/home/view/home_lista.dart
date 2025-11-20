import 'package:flutter/material.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/view/components/card_lista.dart';
import 'package:trabfinal/modules/home/view/pages/cadastrar_atendimento_view.dart';

class HomeLista extends StatelessWidget {
  final List<AtendimentoModel>? atendimento;
  final Future<void> Function(int value) deleteF;
  final void Function(AtendimentoModel atendimento,int value) editF;
  final void Function(AtendimentoModel atendimento, int value) inativF;
  final void Function(int value) detalharF;

  const HomeLista({super.key, this.atendimento, required this.reloadFunction, required this.deleteF, required this.editF, required this.inativF, required this.detalharF});
  final Function reloadFunction;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min, 
          children: const [
            Text(
              "Quadrix",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              "sua agenda digital",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),

      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return CardLista(
              atendimentoCard: AtendimentoModel(
                nome: atendimento![index].nome,
                data: atendimento![index].data,
                status: atendimento![index].status,
              ), deleteF: deleteF, editF: editF, inativF: inativF, detalharF: detalharF
              );
          },
          itemCount: atendimento!.length,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A1A),
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) async {
          if (index == 1) {
           await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastrarAtendimentoView(),
            ),
          );
          }
          await reloadFunction();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.filter_alt), label: "filtrar"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Adicionar"),
          BottomNavigationBarItem(icon: Icon(Icons.close), label: "Finalizar"),
          BottomNavigationBarItem(icon: Icon(Icons.delete), label: "deletar"),
        ],
      ),
    );
  }
}
