import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DialogConcluir extends StatefulWidget {
  const DialogConcluir({super.key});

  @override
  State<DialogConcluir> createState() => _DialogConcluirState();
}

class _DialogConcluirState extends State<DialogConcluir> {
  String? _fotoPath;
  bool _carregando = false;

  Future<void> _selecionarFoto() async {
    setState(() => _carregando = true);
    
    final picker = ImagePicker();
    final opcao = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, 'galeria'),
            ),
          ],
        ),
      ),
    );

    if (opcao != null) {
      final img = await picker.pickImage(
        source: opcao == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );
      
      if (img != null) {
        setState(() {
          _fotoPath = img.path;
        });
      }
    }
    
    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Concluir Atendimento'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Para concluir o atendimento, é necessário adicionar uma foto de finalização.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            if (_carregando)
              const CircularProgressIndicator()
            else if (_fotoPath != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_fotoPath!),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: _selecionarFoto,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Trocar foto'),
                  ),
                ],
              )
            else
              ElevatedButton.icon(
                onPressed: _selecionarFoto,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Adicionar Foto'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _fotoPath == null
              ? null
              : () => Navigator.pop(context, _fotoPath),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            'Concluir',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}