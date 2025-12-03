import 'package:baquadrix/modules/home/core/domain/model/config_model.dart';
import 'package:baquadrix/modules/home/core/service/config_service.dart';
import 'package:baquadrix/modules/home/core/service/notification_service.dart';
import 'package:flutter/material.dart';

class ConfiguracoesView extends StatefulWidget {
  const ConfiguracoesView({super.key});

  @override
  State<ConfiguracoesView> createState() => _ConfiguracoesViewState();
}

class _ConfiguracoesViewState extends State<ConfiguracoesView> {
  final ConfigService _configService = ConfigService();
  final NotificationService _notificationService = NotificationService();

  late ConfigModel _config;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarConfig();
  }

  Future<void> _carregarConfig() async {
    setState(() => _carregando = true);
    _config = await _configService.carregarConfig();
    setState(() => _carregando = false);
  }

  Future<void> _salvarConfig() async {
    await _configService.salvarConfig(_config);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações salvas!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _testarNotificacao() async {
    await _notificationService.testarNotificacao();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notificação de teste enviada!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarConfig,
          ),
        ],
      ),
      body: ListView(
        children: [

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'NOTIFICAÇÕES',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          SwitchListTile(
            title: const Text('Notificações Ativas'),
            subtitle: const Text('Receber lembretes de atendimentos'),
            value: _config.notificacoesAtivas,
            onChanged: (value) {
              setState(() {
                _config = _config.copyWith(notificacoesAtivas: value);
              });
            },
          ),

          ListTile(
            title: const Text('Notificar antes'),
            subtitle: Text('${_config.minutosAntesNotificacao} minutos antes'),
            trailing: const Icon(Icons.chevron_right),
            enabled: _config.notificacoesAtivas,
            onTap: () async {
              final minutos = await showDialog<int>(
                context: context,
                builder: (context) => _DialogMinutos(
                  minutosAtual: _config.minutosAntesNotificacao,
                ),
              );

              if (minutos != null) {
                setState(() {
                  _config = _config.copyWith(minutosAntesNotificacao: minutos);
                });
              }
            },
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'SOM E VIBRAÇÃO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          SwitchListTile(
            title: const Text('Som'),
            subtitle: const Text('Tocar som nas notificações'),
            value: _config.somAtivo,
            onChanged: _config.notificacoesAtivas
                ? (value) {
                    setState(() {
                      _config = _config.copyWith(somAtivo: value);
                    });
                  }
                : null,
          ),

          SwitchListTile(
            title: const Text('Vibração'),
            subtitle: const Text('Vibrar ao receber notificações'),
            value: _config.vibracaoAtiva,
            onChanged: _config.notificacoesAtivas
                ? (value) {
                    setState(() {
                      _config = _config.copyWith(vibracaoAtiva: value);
                    });
                  }
                : null,
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _config.notificacoesAtivas ? _testarNotificacao : null,
              icon: const Icon(Icons.notifications_active),
              label: const Text('Testar Notificação'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogMinutos extends StatelessWidget {
  final int minutosAtual;

  const _DialogMinutos({required this.minutosAtual});

  @override
  Widget build(BuildContext context) {
    final opcoes = [5, 10, 15, 30, 45, 60, 120];

    return AlertDialog(
      title: const Text('Notificar antes'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: opcoes.map((minutos) {
          return RadioListTile<int>(
            title: Text('$minutos minutos'),
            value: minutos,
            groupValue: minutosAtual,
            onChanged: (value) => Navigator.pop(context, value),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
