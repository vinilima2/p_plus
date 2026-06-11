import 'package:p_plus/utils/constants.dart';

class CustomDateUtils {
  static DateTime? converterData(String? dateStr) {
    if (dateStr == null) return null;
    final parts = dateStr.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final mes = int.tryParse(parts[1]);
    final ano = int.tryParse(parts[2]);
    if (day == null || mes == null || ano == null) return null;
    return DateTime(ano, mes, day);
  }

  static String dataAtualString() {
    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    return '$dia/$mes/${now.year}';
  }

  static String formatarDataHora(DateTime dataHora) {

    final dia = dataHora.day.toString().padLeft(2, '0');
    final mes = dataHora.month.toString().padLeft(2, '0');
    final hora = dataHora.hour.toString().padLeft(2, '0');
    final minuto = dataHora.minute.toString().padLeft(2, '0');
    final semana = DIAS_DA_SEMANA[dataHora.weekday - 1];

    return '$dia/$mes/${dataHora.year} - $semana - $hora:$minuto';
  }
}
