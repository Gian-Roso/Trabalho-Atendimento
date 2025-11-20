import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trabfinal/core/di/injection.dart';
import 'package:trabfinal/modules/home/controller/cadastro_controller.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';
import 'package:trabfinal/modules/home/state/cadastro_state.dart';

class CadastrarAtendimentoView extends StatelessWidget {
  final controller = getIt<CadastroController>();

  CadastrarAtendimentoView({super.key});

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: controller,
      child: BlocBuilder<CadastroController, CadastroState>(
        builder: (context, state) {
          Future<void> selecionarImagem() async {
            final picker = ImagePicker();
            final img = await picker.pickImage(source: ImageSource.gallery);
            if (img != null) {
              controller.atualizarImagem(img.path);
            }
          }

          Future<void> selecionarHora() async {
            final hora = await dateTimePicker(
              context: context
            );
            if (hora != null) {
              controller.atualizarHora(DateTime(
                hora.year,
                hora.month,
                hora.day,
                hora.hour,
                hora.minute,
              ));
            }
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF3F3F3),
            appBar: AppBar(
              title: const Text(
                "Novo Atendimento",
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
                  // Imagem
                  InkWell(
                    onTap: selecionarImagem,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Foto do início do serviço",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(3),
                            image: state.imagemSelecionada != null
                                ? DecorationImage(
                                    image:
                                        FileImage(File(state.imagemSelecionada!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: state.imagemSelecionada == null
                              ? const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 40)
                              : null,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Nome
                  TextField(
                    controller: nomeController,
                    onChanged: (value) => controller.atualizarNome(value),
                    decoration: _input("Nome do Cliente"),
                  ),
                  const SizedBox(height: 16),

                  // Descrição
                  TextField(
                    controller: descricaoController,
                    maxLines: 3,
                    onChanged: (value) => controller.atualizarDescricao(value),
                    decoration: _input("Descrição"),
                  ),
                  const SizedBox(height: 16),

                  _inputCampoBotao(
                    label: "Hora do Serviço",
                    value: state.horaSelecionada != null
                        ? "${state.horaSelecionada!.hour.toString().padLeft(2, '0')}:${state.horaSelecionada!.minute.toString().padLeft(2, '0')}"
                        : "Selecionar",
                    onTap: selecionarHora,
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<int>(
                    decoration: _input("Status"),
                    initialValue:  state.statusSelecionado,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("Pendente")),
                      DropdownMenuItem(value: 1, child: Text("Aguardo")),
                      DropdownMenuItem(value: 2, child: Text("Concluído")),
                      DropdownMenuItem(value: 3, child: Text("Inativo")),
                    ],
                    onChanged: (value) =>
                        controller.atualizarStatus(value ?? 1),
                  ),
                  const SizedBox(height: 30),

                  // Botão salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await controller.postCadastro(AtendimentoModel(
                          foto: state.imagemSelecionada,
                          nome: state.nome,
                          descricao: state.descricao,
                          data: state.horaSelecionada!,
                          status: state.statusSelecionado,
                        ));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Salvar Atendimento",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      );

  Widget _inputCampoBotao(
          {required String label,
          required String value,
          required Function() onTap}) =>
      InkWell(
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
      Future<DateTime?> dateTimePicker({
        required BuildContext context,
        DateTime? initialDate,
        DateTime? firstDate,
        DateTime? lastDate,
      }) async {
        initialDate ??= DateTime.now();
        firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
        lastDate ??= firstDate.add(const Duration(days: 365 * 200));

        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        if (selectedDate == null) return null;

        if (!context.mounted) return selectedDate;

        final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
        );

        return selectedTime == null
            ? selectedDate
            : DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
      }

}
