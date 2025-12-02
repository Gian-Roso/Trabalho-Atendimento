import 'package:Baquadrix/modules/home/core/service/config_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final ConfigService _configService = ConfigService();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    // ÍCONE CORRIGIDO
    const androidSettings = AndroidInitializationSettings('ic_notification');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> agendarNotificacaoAtendimento({
    required int id,
    required String titulo,
    required String corpo,
    required DateTime dataHora,
  }) async {
    final config = await _configService.carregarConfig();

    if (!config.notificacoesAtivas) {
      return;
    }

    final dataNotificacao = dataHora.subtract(
      Duration(minutes: config.minutosAntesNotificacao),
    );

    if (dataNotificacao.isBefore(DateTime.now())) {
      return;
    }

    String somNotificacao = 'notification_sound';
    switch (config.toqueNotificacao) {
      case 'alarme':
        somNotificacao = 'alarme_sound';
        break;
      case 'sino':
        somNotificacao = 'sino_sound';
        break;
      default:
        somNotificacao = 'notification_sound';
    }

    await _notifications.zonedSchedule(
      id,
      titulo,
      corpo,
      tz.TZDateTime.from(dataNotificacao, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'atendimento_channel',
          'Atendimentos',
          channelDescription: 'Notificações de atendimentos agendados',
          importance: Importance.max,
          priority: Priority.high,

          // ÍCONE CORRIGIDO
          icon: 'ic_notification',

          sound: config.somAtivo
              ? RawResourceAndroidNotificationSound(somNotificacao)
              : null,
          playSound: config.somAtivo,
          enableVibration: config.vibracaoAtiva,
        ),
        iOS: DarwinNotificationDetails(
          sound: config.somAtivo ? '$somNotificacao.aiff' : null,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'atendimento_$id',
    );
  }

  Future<void> cancelarNotificacao(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelarTodas() async {
    await _notifications.cancelAll();
  }

  Future<void> testarNotificacao() async {
    final config = await _configService.carregarConfig();

    String somNotificacao = 'notification_sound';
    switch (config.toqueNotificacao) {
      case 'alarme':
        somNotificacao = 'alarme_sound';
        break;
      case 'sino':
        somNotificacao = 'sino_sound';
        break;
    }

    await _notifications.show(
      999,
      'Teste de Notificação',
      'Esta é uma notificação de teste do Quadrix',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'teste_channel',
          'Testes',
          importance: Importance.max,
          priority: Priority.high,

          // ÍCONE CORRIGIDO
          icon: 'ic_notification',

          sound: config.somAtivo
              ? RawResourceAndroidNotificationSound(somNotificacao)
              : null,
          playSound: config.somAtivo,
          enableVibration: config.vibracaoAtiva,
        ),
      ),
    );
  }
}
