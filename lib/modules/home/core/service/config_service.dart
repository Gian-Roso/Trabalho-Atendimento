import 'package:Baquadrix/modules/home/core/domain/model/config_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigService {
  static const String _configKey = 'app_config';

  Future<ConfigModel> carregarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString(_configKey);
    
    if (configJson != null) {

      final map = <String, dynamic>{};
      configJson.split('&').forEach((pair) {
        final parts = pair.split('=');
        if (parts.length == 2) {
          final key = parts[0];
          final value = parts[1];
          
          if (key == 'notificacoesAtivas' || key == 'somAtivo' || key == 'vibracaoAtiva') {
            map[key] = value == 'true';
          } else if (key == 'minutosAntesNotificacao') {
            map[key] = int.parse(value);
          } else {
            map[key] = value;
          }
        }
      });
      
      return ConfigModel.fromMap(map);
    }
    
    return ConfigModel();
  }

  Future<void> salvarConfig(ConfigModel config) async {
    final prefs = await SharedPreferences.getInstance();
    final map = config.toMap();
    
    final configString = map.entries.map((e) => '${e.key}=${e.value}').join('&');
    await prefs.setString(_configKey, configString);
  }

  Future<void> resetarConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configKey);
  }
}