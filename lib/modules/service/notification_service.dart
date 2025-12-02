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

  Future<void> initialize() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    // Android
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS
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
      onDidReceiveNotificationResponse: (details) {
        // Ação ao clicar na notificação
        print('Notificação clicada: ${details.payload}');
      },
    );

    // Solicitar permissões
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // ✅ Agendar notificação para um atendimento
  Future<void> agendarNotificacaoAtendimento({
    required int id,
    required String titulo,
    required String corpo,
    required DateTime dataHora,
    int minutosAntes = 30, // Avisar 30min antes
  }) async {
    final dataNotificacao = dataHora.subtract(Duration(minutes: minutosAntes));

    // Só agenda se for no futuro
    if (dataNotificacao.isBefore(DateTime.now())) {
      print('Data já passou, não vai agendar');
      return;
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
          sound: RawResourceAndroidNotificationSound('notification_sound'), // ✅ Som personalizado
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'notification_sound.aiff', // ✅ Som personalizado iOS
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'atendimento_$id',
    );

    print('Notificação agendada para: $dataNotificacao');
  }

  // Cancelar notificação específica
  Future<void> cancelarNotificacao(int id) async {
    await _notifications.cancel(id);
  }

  // Cancelar todas
  Future<void> cancelarTodas() async {
    await _notifications.cancelAll();
  }

  // ✅ Notificação imediata (teste)
  Future<void> mostrarNotificacaoImediata({
    required String titulo,
    required String corpo,
  }) async {
    await _notifications.show(
      0,
      titulo,
      corpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'teste_channel',
          'Testes',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
      ),
    );
  }
}