import '../data/local/database.dart';

abstract class MedicineRepository {
  Stream<List<Medicine>> watchMedicines();
  Future<void> addMedicine({
    required String name,
    required bool morning,
    required bool afternoon,
    required bool evening,
    String? morningTime,
    String? afternoonTime,
    String? eveningTime,
    required int duration,
  });
  Future<void> deleteMedicine(Medicine medicine);
  
  // History Logging
  Stream<List<MedicineLog>> watchLogsForDate(DateTime date);
  Future<void> logIntake(int medicineId, DateTime date, String slot, bool isTaken);
}
