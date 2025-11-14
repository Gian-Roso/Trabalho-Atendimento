import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trabfinal/core/di/injection.dart';
import 'package:trabfinal/modules/home/controller/home_controller.dart';
import 'package:trabfinal/modules/home/state/home_state.dart';
import 'package:trabfinal/modules/home/core/domain/model/atendimento_model.dart';

class HomeView extends StatelessWidget {
  final controller = getIt<HomeController>();

  HomeView({super.key});

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.red.shade100;
      case 'finalizado':
        return Colors.green.shade100;
      case 'em andamento':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return Colors.red.shade700;
      case 'finalizado':
        return Colors.green.shade700;
      case 'em andamento':
        return Colors.orange.shade700;
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => controller,
      child: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text(
                'Atendimentos',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              elevation: 0,
            ),
            body: Builder(
              builder: (context) {
                if (state is HomeCarregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is HomeCarregado) {
                  final atendimentos = state.atendimentos;

                  if (atendimentos.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum atendimento encontrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: atendimentos.length,
                    itemBuilder: (context, index) {
                      final atendimento = atendimentos[index];
                      return _buildAtendimentoCard(
                        context,
                        atendimento,
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('Erro ao carregar atendimentos.'),
                );
              },
            ),
            bottomNavigationBar: _buildBottomBar(context),
          );
        },
      ),
    );
  }

  Widget _buildAtendimentoCard(BuildContext context, AtendimentoModel atendimento) {
  String getStatusLabel(int status) {
    switch (status) {
      case 0:
        return 'Pendente';
      case 1:
        return 'Em andamento';
      case 2:
        return 'Finalizado';
      default:
        return 'Desconhecido';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.red.shade100;
      case 1:
        return Colors.orange.shade100;
      case 2:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color getStatusTextColor(int status) {
    switch (status) {
      case 0:
        return Colors.red.shade700;
      case 1:
        return Colors.orange.shade700;
      case 2:
        return Colors.green.shade700;
      default:
        return Colors.black54;
    }
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      contentPadding: const EdgeInsets.all(12),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: atendimento.foto != null && atendimento.foto!.isNotEmpty
            ? NetworkImage(atendimento.foto!)
            : const AssetImage('assets/images/default_avatar.png')
                as ImageProvider,
      ),
      title: Text(
        atendimento.nome,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            atendimento.descricao ?? 'Sem descrição',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${atendimento.data.day.toString().padLeft(2, '0')}/${atendimento.data.month.toString().padLeft(2, '0')}/${atendimento.data.year}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              if (atendimento.criadoEm != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${atendimento.criadoEm!.hour.toString().padLeft(2, '0')}:${atendimento.criadoEm!.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: getStatusColor(atendimento.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              getStatusLabel(atendimento.status),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: getStatusTextColor(atendimento.status),
              ),
            ),
          ),
          _buildPopupMenu(context, atendimento),
        ],
      ),
    ),
  );
}

Widget buildStatusBadge(int status) {
  String getStatusLabel(int status) {
    switch (status) {
      case 0:
        return 'Pendente';
      case 1:
        return 'Em andamento';
      case 2:
        return 'Finalizado';
      default:
        return 'Desconhecido';
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.red.shade100;
      case 1:
        return Colors.orange.shade100;
      case 2:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  Color getStatusTextColor(int status) {
    switch (status) {
      case 0:
        return Colors.red.shade700;
      case 1:
        return Colors.orange.shade700;
      case 2:
        return Colors.green.shade700;
      default:
        return Colors.black54;
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: getStatusColor(status),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      getStatusLabel(status),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: getStatusTextColor(status),
      ),
    ),
  );
}

Widget _buildPopupMenu(BuildContext context, AtendimentoModel atendimento) {
  return PopupMenuButton<String>(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    onSelected: (value) async {
      final controller = BlocProvider.of<HomeController>(context);

      switch (value) {
        case 'Ver Detalhes':
          controller.getAtendimento(atendimento.id!);
          break;
        case 'Alterar':
          // TODO: abrir tela de edição de atendimento
          break;
        case 'Inativar':
          // TODO: implementar inativação lógica
          break;
        case 'Excluir':
          await controller.deleteAtendimento(atendimento.id!);
          break;
      }
    },
    itemBuilder: (context) => const [
      PopupMenuItem(value: 'Ver Detalhes', child: Text('Ver Detalhes')),
      PopupMenuItem(value: 'Alterar', child: Text('Alterar')),
      PopupMenuItem(value: 'Inativar', child: Text('Inativar')),
      PopupMenuItem(
        value: 'Excluir',
        child: Text(
          'Excluir',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
    icon: const Icon(Icons.more_vert, color: Colors.black54),
  );
}

Widget _buildBottomBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: const BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            // TODO: ação para listagem
          },
          icon: const Icon(Icons.list, color: Colors.white),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: abrir tela de criação de atendimento
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Adicionar Atendimento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: abrir calendário
          },
          icon: const Icon(Icons.calendar_today, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // TODO: ação de exclusão em massa, se necessário
          },
          icon: const Icon(Icons.delete, color: Colors.white),
        ),
      ],
    ),
  );
}

}
