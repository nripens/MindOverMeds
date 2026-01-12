import 'package:drift/drift.dart';

// Table for Medicines (Schedule)
class Medicines extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  
  // Schedule Flags
  BoolColumn get takeMorning => boolean().withDefault(const Constant(false))();
  BoolColumn get takeAfternoon => boolean().withDefault(const Constant(false))();
  BoolColumn get takeEvening => boolean().withDefault(const Constant(false))();
  
  // Specific Times (nullable, e.g. "08:00 AM")
  TextColumn get morningTime => text().nullable()();
  TextColumn get afternoonTime => text().nullable()();
  TextColumn get eveningTime => text().nullable()();
  
  // Duration (0 = infinite)
  IntColumn get duration => integer().withDefault(const Constant(0))();
}

// Table for History Logs (Tracks actual intake)
class MedicineLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get medicineId => integer().references(Medicines, #id)();
  DateTimeColumn get takenAt => dateTime()(); // The actual timestamp
  TextColumn get slot => text()(); // "morning", "afternoon", "evening"
  BoolColumn get isTaken => boolean().withDefault(const Constant(true))();
}
