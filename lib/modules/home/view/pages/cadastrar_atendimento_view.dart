import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarAtendimentoView extends StatefulWidget {
  const CadastrarAtendimentoView({super.key});

  @override
  State<CadastrarAtendimentoView> createState() => _CadastrarAtendimentoViewState();
}

class _CadastrarAtendimentoViewState extends State<CadastrarAtendimentoView> {
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();

  TimeOfDay? horaSelecionada;
  int statusSelecionado = 0;
  File? imagemSelecionada;

  Future<void> selecionarImagem() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => imagemSelecionada = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text("Novo Atendimento"),
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
            // FOTO
            InkWell(
              onTap: selecionarImagem,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: imagemSelecionada != null ? FileImage(imagemSelecionada!) : null,
                child: imagemSelecionada == null ? const Icon(Icons.camera_alt, color: Colors.white70, size: 40) : null,
              ),
            ),
            const SizedBox(height: 20),

            // NOME
            TextField(
              controller: nomeController,
              decoration: _input("Nome do Cliente"),
            ),
            const SizedBox(height: 16),

            // DESCRIÇÃO
            TextField(
              controller: descricaoController,
              maxLines: 3,
              decoration: _input("Descrição"),
            ),
            const SizedBox(height: 16),

            // HORA
            _inputCampoBotao(
              label: "Hora do Serviço",
              value: horaSelecionada != null
                  ? "${horaSelecionada!.hour.toString().padLeft(2, '0')}:${horaSelecionada!.minute.toString().padLeft(2, '0')}"
                  : "Selecionar",
              onTap: () async {
                final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (hora != null) setState(() => horaSelecionada = hora);
              },
            ),
            const SizedBox(height: 16),

            // STATUS
            DropdownButtonFormField<int>(
              decoration: _input("Status"),
              value: statusSelecionado,
              items: const [
                DropdownMenuItem(value: 0, child: Text("Pendente")),
                DropdownMenuItem(value: 1, child: Text("Aguardo")),
                DropdownMenuItem(value: 2, child: Text("Concluído")),
                DropdownMenuItem(value: 3, child: Text("Inativo")),
              ],
              onChanged: (value) => setState(() => statusSelecionado = value!),
            ),
            const SizedBox(height: 30),

            // BOTÃO SALVAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Aqui você pode colocar a lógica de salvar
                },
                child: const Text(
                  "Salvar Atendimento",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _inputCampoBotao({required String label, required String value, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black38),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
