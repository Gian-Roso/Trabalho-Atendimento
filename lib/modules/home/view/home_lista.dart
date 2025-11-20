import 'package:flutter/material.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/view/components/card_lista.dart';
import 'package:trabfinal/modules/home/view/pages/cadastrar_atendimento_view.dart';

class HomeLista extends StatelessWidget {
  final List<AtendimentoModel>? atendimento;
  HomeLista({super.key, this.atendimento});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Atendimentos", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
      ),

      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return CardLista(
              atendimentoCard: AtendimentoModel(
                nome: 'Judas',
                data: DateTime.now(),
                status: 0,
              ),
            );
          },
          itemCount: 5,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A1A),
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
           Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastrarAtendimentoView(),
            ),
          );
          }
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
