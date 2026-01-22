import '../data/local/database.dart';

class BpStatisticsService {
  
  Map<String, double> calculateWeeklyAverages(List<BloodPressureLog> logs) {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final twoWeeksAgo = now.subtract(const Duration(days: 14));

    final currentWeekLogs = logs.where((l) => l.loggedAt.isAfter(oneWeekAgo)).toList();
    final previousWeekLogs = logs.where((l) => l.loggedAt.isAfter(twoWeeksAgo) && l.loggedAt.isBefore(oneWeekAgo)).toList();

    return {
      'currentSys': _average(currentWeekLogs.map((e) => e.systolic)),
      'currentDia': _average(currentWeekLogs.map((e) => e.diastolic)),
      'prevSys': _average(previousWeekLogs.map((e) => e.systolic)),
      'prevDia': _average(previousWeekLogs.map((e) => e.diastolic)),
    };
  }

  double _average(Iterable<int> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
