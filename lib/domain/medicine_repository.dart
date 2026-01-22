import '../data/local/database.dart';

abstract class MedicineRepository {
  Stream<List<Medicine>> watchMedicines();
  Future<int> addMedicine({
    required String name,
    required bool morning,
    required bool afternoon,
    required bool evening,
    String? morningTime,
    String? afternoonTime,
    String? eveningTime,
    required int duration,
    int frequencyType = 0,
    String? selectedDays,
  });
  Future<void> updateMedicine(Medicine medicine);
  Future<void> deleteMedicine(Medicine medicine);
  
  // History Logging
  Stream<List<MedicineLog>> watchLogsForDate(DateTime date);
  Future<void> logIntake(int medicineId, DateTime date, String slot, bool isTaken);
  
  // Blood Pressure Logging
  Stream<List<BloodPressureLog>> watchBpLogs();
  Future<void> addBpLog(int systolic, int diastolic, int? pulse, DateTime date, String slot, String context);
  Future<void> updateBpLog(BloodPressureLog log);
  Future<void> deleteBpLog(BloodPressureLog log);
}
