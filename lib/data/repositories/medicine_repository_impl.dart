import 'package:drift/drift.dart';
import '../../domain/medicine_repository.dart';
import '../local/database.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final AppDatabase _db;

  MedicineRepositoryImpl(this._db);

  @override
  Stream<List<Medicine>> watchMedicines() {
    return _db.select(_db.medicines).watch();
  }

  @override
  Future<void> addMedicine({
    required String name,
    required bool morning,
    required bool afternoon,
    required bool evening,
    String? morningTime,
    String? afternoonTime,
    String? eveningTime,
    required int duration,
  }) async {
    await _db.into(_db.medicines).insert(
      MedicinesCompanion(
        name: Value(name),
        takeMorning: Value(morning),
        takeAfternoon: Value(afternoon),
        takeEvening: Value(evening),
        morningTime: Value(morningTime),
        afternoonTime: Value(afternoonTime),
        eveningTime: Value(eveningTime),
        duration: Value(duration),
      ),
    );
  }

  @override
  Future<void> deleteMedicine(Medicine medicine) async {
    await _db.medicines.deleteWhere((t) => t.id.equals(medicine.id));
  }

  @override
  Stream<List<MedicineLog>> watchLogsForDate(DateTime date) {
    // Filter logs where date matches (ignoring time)
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    
    return (_db.select(_db.medicineLogs)
      ..where((t) => t.takenAt.isBiggerOrEqualValue(start) & t.takenAt.isSmallerThanValue(end))
    ).watch();
  }

  @override
  Future<void> logIntake(int medicineId, DateTime date, String slot, bool isTaken) async {
    if (isTaken) {
      await _db.into(_db.medicineLogs).insert(
        MedicineLogsCompanion(
          medicineId: Value(medicineId),
          takenAt: Value(date),
          slot: Value(slot),
          isTaken: Value(true),
        ),
      );
    } else {
      // If unticking, remove the log
      // Need to find log by medicineId, approximate date, and slot
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      
      await (_db.delete(_db.medicineLogs)
        ..where((t) => 
          t.medicineId.equals(medicineId) & 
          t.slot.equals(slot) &
          t.takenAt.isBiggerOrEqualValue(start) &
          t.takenAt.isSmallerThanValue(end)
        )
      ).go();
    }
  }
}
