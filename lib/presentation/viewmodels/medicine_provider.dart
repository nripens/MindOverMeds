import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/repositories/medicine_repository_impl.dart';
import '../../domain/medicine_repository.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository Provider
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return MedicineRepositoryImpl(db);
});

// Medicines Stream Provider
final medicinesProvider = StreamProvider<List<Medicine>>((ref) {
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchMedicines();
});

final logsForDateProvider = StreamProvider.family<List<MedicineLog>, DateTime>((ref, date) {
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchLogsForDate(date);
});
