import 'dart:io';
import 'package:Baquadrix/modules/home/core/domain/model/atendimento_model.dart';
import 'package:Baquadrix/modules/home/view/components/status_chip.dart';
import 'package:flutter/material.dart';

class DetalhesAtendimentoView extends StatelessWidget {
  final AtendimentoModel atendimento;

  const DetalhesAtendimentoView({
    super.key,
    required this.atendimento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text(
          "Detalhes do Atendimento",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          atendimento.nome,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      StatusChip(status: atendimento.status),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 20),
                      const SizedBox(width: 1),

                      const Text(
                        "Cliente:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          atendimento.nomeCliente ?? "Sem nome",
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (atendimento.foto != null) ...[
                    const Row(
                      children: [
                        Icon(Icons.photo, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Foto do Serviço",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(atendimento.foto!),
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const Row(
                    children: [
                      Icon(Icons.description, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Descrição",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    atendimento.descricao ?? "Sem descrição",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  
                  const Row(
                    children: [
                      Icon(Icons.event, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Data e Hora do Serviço",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(
                        "${atendimento.data.day.toString().padLeft(2, '0')}/${atendimento.data.month.toString().padLeft(2, '0')}/${atendimento.data.year}",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Icon(Icons.access_time, size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(
                        "${atendimento.data.hour.toString().padLeft(2, '0')}:${atendimento.data.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  if (atendimento.data.isBefore(DateTime.now()) &&
                      atendimento.status == 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.warning_amber,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Atendimento atrasado!",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Informações do Sistema",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _infoRow("ID do Atendimento:", "#${atendimento.id}"),
                  const SizedBox(height: 8),
                  _infoRow(
                    "Criado em:",
                    atendimento.criadoEm != null
                        ? "${atendimento.criadoEm!.day.toString().padLeft(2, '0')}/${atendimento.criadoEm!.month.toString().padLeft(2, '0')}/${atendimento.criadoEm!.year} às ${atendimento.criadoEm!.hour.toString().padLeft(2, '0')}:${atendimento.criadoEm!.minute.toString().padLeft(2, '0')}"
                        : "N/A",
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Status Atual:"),
                      StatusChip(status: atendimento.status),
                    ],
                  ),
                  if (atendimento.fotoFinalizacao != null) ...[
                    const SizedBox(height: 20),

                    const Row(
                      children: [
                        Icon(Icons.photo, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Foto do Serviço Finalizado",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(atendimento.fotoFinalizacao!),
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}