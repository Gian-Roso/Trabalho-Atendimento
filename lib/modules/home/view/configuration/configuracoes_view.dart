import 'package:Baquadrix/modules/home/core/domain/model/config_model.dart';
import 'package:Baquadrix/modules/home/core/service/config_service.dart';
import 'package:Baquadrix/modules/home/core/service/notification_service.dart';
import 'package:flutter/material.dart';

class ConfiguracoesView extends StatefulWidget {
  const ConfiguracoesView({super.key});

  @override
  State<ConfiguracoesView> createState() => _ConfiguracoesViewState();
}

class _ConfiguracoesViewState extends State<ConfiguracoesView> {
  final ConfigService _configService = ConfigService();
  final NotificationService _notificationService = NotificationService();
  
  ConfigModel _config = ConfigModel();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final config = await _configService.carregarConfig();
    setState(() {
      _config = config;
      _carregando = false;
    });
  }

  Future<void> _salvarConfiguracoes() async {
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

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          backgroundColor: const Color(0xFF1A1A1A),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _secaoTitulo('Notificações'),
          _cardConfig(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Ativar Notificações'),
                  subtitle: const Text('Receber alertas de atendimentos'),
                  value: _config.notificacoesAtivas,
                  onChanged: (valor) {
                    setState(() {
                      _config = _config.copyWith(notificacoesAtivas: valor);
                    });
                    _salvarConfiguracoes();
                  },
                ),
                const Divider(),

                ListTile(
                  title: const Text('Avisar com antecedência'),
                  subtitle: Text('${_config.minutosAntesNotificacao} minutos antes'),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: _config.notificacoesAtivas,
                  onTap: () => _mostrarSeletorTempo(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _secaoTitulo('Som e Vibração'),
          _cardConfig(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Som'),
                  subtitle: const Text('Tocar som ao receber notificação'),
                  value: _config.somAtivo,
                  onChanged: _config.notificacoesAtivas
                      ? (valor) {
                          setState(() {
                            _config = _config.copyWith(somAtivo: valor);
                          });
                          _salvarConfiguracoes();
                        }
                      : null,
                ),
                const Divider(),

                ListTile(
                  title: const Text('Toque de Notificação'),
                  subtitle: Text(_nomeToque(_config.toqueNotificacao)),
                  trailing: const Icon(Icons.chevron_right),
                  enabled: _config.notificacoesAtivas && _config.somAtivo,
                  onTap: () => _mostrarSeletorToque(),
                ),
                const Divider(),
                
                SwitchListTile(
                  title: const Text('Vibração'),
                  subtitle: const Text('Vibrar ao receber notificação'),
                  value: _config.vibracaoAtiva,
                  onChanged: _config.notificacoesAtivas
                      ? (valor) {
                          setState(() {
                            _config = _config.copyWith(vibracaoAtiva: valor);
                          });
                          _salvarConfiguracoes();
                        }
                      : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _secaoTitulo('Testar'),
          _cardConfig(
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.blue),
              title: const Text('Testar Notificação'),
              subtitle: const Text('Enviar notificação de teste'),
              trailing: ElevatedButton(
                onPressed: _config.notificacoesAtivas
                    ? () async {
                        await _notificationService.testarNotificacao();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notificação de teste enviada!'),
                            ),
                          );
                        }
                      }
                    : null,
                child: const Text('Testar'),
              ),
            ),
          ),

          const SizedBox(height: 24),

          _secaoTitulo('Avançado'),
          _cardConfig(
            child: ListTile(
              leading: const Icon(Icons.restore, color: Colors.orange),
              title: const Text('Restaurar Padrões'),
              subtitle: const Text('Voltar às configurações originais'),
              onTap: () => _confirmarResetar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _secaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _cardConfig({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  String _nomeToque(String toque) {
    switch (toque) {
      case 'alarme':
        return 'Alarme';
      case 'sino':
        return 'Sino';
      default:
        return 'Padrão';
    }
  }

  void _mostrarSeletorTempo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Avisar com Antecedência'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _opcaoTempo(5),
            _opcaoTempo(15),
            _opcaoTempo(30),
            _opcaoTempo(60),
            _opcaoTempo(120),
          ],
        ),
      ),
    );
  }

  Widget _opcaoTempo(int minutos) {
    final selecionado = _config.minutosAntesNotificacao == minutos;
    return RadioListTile<int>(
      title: Text(
        minutos >= 60
            ? '${minutos ~/ 60} ${minutos == 60 ? "hora" : "horas"}'
            : '$minutos minutos',
      ),
      value: minutos,
      groupValue: _config.minutosAntesNotificacao,
      selected: selecionado,
      onChanged: (valor) {
        setState(() {
          _config = _config.copyWith(minutosAntesNotificacao: valor);
        });
        _salvarConfiguracoes();
        Navigator.pop(context);
      },
    );
  }

  void _mostrarSeletorToque() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Toque de Notificação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _opcaoToque('padrao', 'Padrão'),
            _opcaoToque('alarme', 'Alarme'),
            _opcaoToque('sino', 'Sino'),
          ],
        ),
      ),
    );
  }

  Widget _opcaoToque(String valor, String nome) {
    final selecionado = _config.toqueNotificacao == valor;
    return RadioListTile<String>(
      title: Text(nome),
      value: valor,
      groupValue: _config.toqueNotificacao,
      selected: selecionado,
      onChanged: (novoValor) {
        setState(() {
          _config = _config.copyWith(toqueNotificacao: novoValor);
        });
        _salvarConfiguracoes();
        Navigator.pop(context);
      },
    );
  }

  void _confirmarResetar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Padrões'),
        content: const Text(
          'Deseja restaurar todas as configurações para os valores padrão?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _configService.resetarConfig();
              await _carregarConfiguracoes();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configurações restauradas!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Restaurar',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}