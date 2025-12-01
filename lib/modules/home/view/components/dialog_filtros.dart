import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/modules/home/controller/lista_controller.dart';
import 'package:trabfinal/modules/home/state/lista_state.dart';

class DialogFiltros extends StatefulWidget {
  const DialogFiltros({super.key});

  @override
  State<DialogFiltros> createState() => _DialogFiltrosState();
}

class _DialogFiltrosState extends State<DialogFiltros> {
  int? _statusSelecionado;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String _tipoData = 'servico';
  final TextEditingController _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<ListaController>();
    final state = controller.state;
    
    if (state is ListaCarregada) {
      _statusSelecionado = state.filtroStatus;
      _dataInicio = state.filtroDataInicio;
      _dataFim = state.filtroDataFim;
      _tipoData = state.tipoFiltroData;
      _nomeController.text = state.filtroNome ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData(bool isInicio) async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() {
        if (isInicio) {
          _dataInicio = data;
        } else {
          _dataFim = data;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtros Avançados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Buscar por Nome',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  hintText: 'Nome do serviço ou cliente',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _nomeController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() => _nomeController.clear());
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 20),
              const Text(
                'Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chipStatus(null, 'Todos'),
                  _chipStatus(0, 'Pendentes'),
                  _chipStatus(1, 'Aguardo'),
                  _chipStatus(2, 'Concluídos'),
                  _chipStatus(3, 'Inativos'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Filtrar por Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              // Tipo de data
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Data do Serviço'),
                      value: 'servico',
                      groupValue: _tipoData,
                      onChanged: (value) {
                        setState(() => _tipoData = value!);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Data de Criação'),
                      value: 'criacao',
                      groupValue: _tipoData,
                      onChanged: (value) {
                        setState(() => _tipoData = value!);
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _selecionarData(true),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _dataInicio != null
                                ? 'De: ${_dataInicio!.day.toString().padLeft(2, '0')}/${_dataInicio!.month.toString().padLeft(2, '0')}/${_dataInicio!.year}'
                                : 'Data Inicial',
                          ),
                        ],
                      ),
                      if (_dataInicio != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() => _dataInicio = null);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selecionarData(false),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _dataFim != null
                                ? 'Até: ${_dataFim!.day.toString().padLeft(2, '0')}/${_dataFim!.month.toString().padLeft(2, '0')}/${_dataFim!.year}'
                                : 'Data Final',
                          ),
                        ],
                      ),
                      if (_dataFim != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() => _dataFim = null);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _statusSelecionado = null;
                          _dataInicio = null;
                          _dataFim = null;
                          _tipoData = 'servico';
                          _nomeController.clear();
                        });
                        context.read<ListaController>().limparTodosFiltros();
                      },
                      child: const Text('Limpar Tudo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final controller = context.read<ListaController>();
                        controller.aplicarFiltroStatus(_statusSelecionado);
                        controller.aplicarFiltroNome(
                          _nomeController.text.isEmpty ? null : _nomeController.text,
                        );
                        controller.aplicarFiltroData(
                          dataInicio: _dataInicio,
                          dataFim: _dataFim,
                          tipoData: _tipoData,
                        );
                        
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Aplicar Filtros',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipStatus(int? valor, String label) {
    final selecionado = _statusSelecionado == valor;
    return FilterChip(
      label: Text(label),
      selected: selecionado,
      onSelected: (selected) {
        setState(() {
          _statusSelecionado = selected ? valor : null;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: _corStatus(valor),
      labelStyle: TextStyle(
        color: selecionado ? Colors.white : Colors.black,
        fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Color _corStatus(int? status) {
    if (status == null) return Colors.blue;
    switch (status) {
      case 0:
        return const Color.fromARGB(255, 147, 29, 158);
      case 1:
        return const Color.fromARGB(255, 63, 177, 162);
      case 2:
        return const Color.fromARGB(255, 80, 219, 98);
      case 3:
        return Colors.black;
      default:
        return Colors.orange;
    }
  }
}