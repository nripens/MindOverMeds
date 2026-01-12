// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takeMorningMeta = const VerificationMeta(
    'takeMorning',
  );
  @override
  late final GeneratedColumn<bool> takeMorning = GeneratedColumn<bool>(
    'take_morning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("take_morning" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _takeAfternoonMeta = const VerificationMeta(
    'takeAfternoon',
  );
  @override
  late final GeneratedColumn<bool> takeAfternoon = GeneratedColumn<bool>(
    'take_afternoon',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("take_afternoon" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _takeEveningMeta = const VerificationMeta(
    'takeEvening',
  );
  @override
  late final GeneratedColumn<bool> takeEvening = GeneratedColumn<bool>(
    'take_evening',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("take_evening" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _morningTimeMeta = const VerificationMeta(
    'morningTime',
  );
  @override
  late final GeneratedColumn<String> morningTime = GeneratedColumn<String>(
    'morning_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _afternoonTimeMeta = const VerificationMeta(
    'afternoonTime',
  );
  @override
  late final GeneratedColumn<String> afternoonTime = GeneratedColumn<String>(
    'afternoon_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eveningTimeMeta = const VerificationMeta(
    'eveningTime',
  );
  @override
  late final GeneratedColumn<String> eveningTime = GeneratedColumn<String>(
    'evening_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    takeMorning,
    takeAfternoon,
    takeEvening,
    morningTime,
    afternoonTime,
    eveningTime,
    duration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medicine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('take_morning')) {
      context.handle(
        _takeMorningMeta,
        takeMorning.isAcceptableOrUnknown(
          data['take_morning']!,
          _takeMorningMeta,
        ),
      );
    }
    if (data.containsKey('take_afternoon')) {
      context.handle(
        _takeAfternoonMeta,
        takeAfternoon.isAcceptableOrUnknown(
          data['take_afternoon']!,
          _takeAfternoonMeta,
        ),
      );
    }
    if (data.containsKey('take_evening')) {
      context.handle(
        _takeEveningMeta,
        takeEvening.isAcceptableOrUnknown(
          data['take_evening']!,
          _takeEveningMeta,
        ),
      );
    }
    if (data.containsKey('morning_time')) {
      context.handle(
        _morningTimeMeta,
        morningTime.isAcceptableOrUnknown(
          data['morning_time']!,
          _morningTimeMeta,
        ),
      );
    }
    if (data.containsKey('afternoon_time')) {
      context.handle(
        _afternoonTimeMeta,
        afternoonTime.isAcceptableOrUnknown(
          data['afternoon_time']!,
          _afternoonTimeMeta,
        ),
      );
    }
    if (data.containsKey('evening_time')) {
      context.handle(
        _eveningTimeMeta,
        eveningTime.isAcceptableOrUnknown(
          data['evening_time']!,
          _eveningTimeMeta,
        ),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      takeMorning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}take_morning'],
      )!,
      takeAfternoon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}take_afternoon'],
      )!,
      takeEvening: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}take_evening'],
      )!,
      morningTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}morning_time'],
      ),
      afternoonTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}afternoon_time'],
      ),
      eveningTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evening_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      )!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final int id;
  final String name;
  final bool takeMorning;
  final bool takeAfternoon;
  final bool takeEvening;
  final String? morningTime;
  final String? afternoonTime;
  final String? eveningTime;
  final int duration;
  const Medicine({
    required this.id,
    required this.name,
    required this.takeMorning,
    required this.takeAfternoon,
    required this.takeEvening,
    this.morningTime,
    this.afternoonTime,
    this.eveningTime,
    required this.duration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['take_morning'] = Variable<bool>(takeMorning);
    map['take_afternoon'] = Variable<bool>(takeAfternoon);
    map['take_evening'] = Variable<bool>(takeEvening);
    if (!nullToAbsent || morningTime != null) {
      map['morning_time'] = Variable<String>(morningTime);
    }
    if (!nullToAbsent || afternoonTime != null) {
      map['afternoon_time'] = Variable<String>(afternoonTime);
    }
    if (!nullToAbsent || eveningTime != null) {
      map['evening_time'] = Variable<String>(eveningTime);
    }
    map['duration'] = Variable<int>(duration);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      name: Value(name),
      takeMorning: Value(takeMorning),
      takeAfternoon: Value(takeAfternoon),
      takeEvening: Value(takeEvening),
      morningTime: morningTime == null && nullToAbsent
          ? const Value.absent()
          : Value(morningTime),
      afternoonTime: afternoonTime == null && nullToAbsent
          ? const Value.absent()
          : Value(afternoonTime),
      eveningTime: eveningTime == null && nullToAbsent
          ? const Value.absent()
          : Value(eveningTime),
      duration: Value(duration),
    );
  }

  factory Medicine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      takeMorning: serializer.fromJson<bool>(json['takeMorning']),
      takeAfternoon: serializer.fromJson<bool>(json['takeAfternoon']),
      takeEvening: serializer.fromJson<bool>(json['takeEvening']),
      morningTime: serializer.fromJson<String?>(json['morningTime']),
      afternoonTime: serializer.fromJson<String?>(json['afternoonTime']),
      eveningTime: serializer.fromJson<String?>(json['eveningTime']),
      duration: serializer.fromJson<int>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'takeMorning': serializer.toJson<bool>(takeMorning),
      'takeAfternoon': serializer.toJson<bool>(takeAfternoon),
      'takeEvening': serializer.toJson<bool>(takeEvening),
      'morningTime': serializer.toJson<String?>(morningTime),
      'afternoonTime': serializer.toJson<String?>(afternoonTime),
      'eveningTime': serializer.toJson<String?>(eveningTime),
      'duration': serializer.toJson<int>(duration),
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    bool? takeMorning,
    bool? takeAfternoon,
    bool? takeEvening,
    Value<String?> morningTime = const Value.absent(),
    Value<String?> afternoonTime = const Value.absent(),
    Value<String?> eveningTime = const Value.absent(),
    int? duration,
  }) => Medicine(
    id: id ?? this.id,
    name: name ?? this.name,
    takeMorning: takeMorning ?? this.takeMorning,
    takeAfternoon: takeAfternoon ?? this.takeAfternoon,
    takeEvening: takeEvening ?? this.takeEvening,
    morningTime: morningTime.present ? morningTime.value : this.morningTime,
    afternoonTime: afternoonTime.present
        ? afternoonTime.value
        : this.afternoonTime,
    eveningTime: eveningTime.present ? eveningTime.value : this.eveningTime,
    duration: duration ?? this.duration,
  );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      takeMorning: data.takeMorning.present
          ? data.takeMorning.value
          : this.takeMorning,
      takeAfternoon: data.takeAfternoon.present
          ? data.takeAfternoon.value
          : this.takeAfternoon,
      takeEvening: data.takeEvening.present
          ? data.takeEvening.value
          : this.takeEvening,
      morningTime: data.morningTime.present
          ? data.morningTime.value
          : this.morningTime,
      afternoonTime: data.afternoonTime.present
          ? data.afternoonTime.value
          : this.afternoonTime,
      eveningTime: data.eveningTime.present
          ? data.eveningTime.value
          : this.eveningTime,
      duration: data.duration.present ? data.duration.value : this.duration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('takeMorning: $takeMorning, ')
          ..write('takeAfternoon: $takeAfternoon, ')
          ..write('takeEvening: $takeEvening, ')
          ..write('morningTime: $morningTime, ')
          ..write('afternoonTime: $afternoonTime, ')
          ..write('eveningTime: $eveningTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    takeMorning,
    takeAfternoon,
    takeEvening,
    morningTime,
    afternoonTime,
    eveningTime,
    duration,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.name == this.name &&
          other.takeMorning == this.takeMorning &&
          other.takeAfternoon == this.takeAfternoon &&
          other.takeEvening == this.takeEvening &&
          other.morningTime == this.morningTime &&
          other.afternoonTime == this.afternoonTime &&
          other.eveningTime == this.eveningTime &&
          other.duration == this.duration);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> takeMorning;
  final Value<bool> takeAfternoon;
  final Value<bool> takeEvening;
  final Value<String?> morningTime;
  final Value<String?> afternoonTime;
  final Value<String?> eveningTime;
  final Value<int> duration;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.takeMorning = const Value.absent(),
    this.takeAfternoon = const Value.absent(),
    this.takeEvening = const Value.absent(),
    this.morningTime = const Value.absent(),
    this.afternoonTime = const Value.absent(),
    this.eveningTime = const Value.absent(),
    this.duration = const Value.absent(),
  });
  MedicinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.takeMorning = const Value.absent(),
    this.takeAfternoon = const Value.absent(),
    this.takeEvening = const Value.absent(),
    this.morningTime = const Value.absent(),
    this.afternoonTime = const Value.absent(),
    this.eveningTime = const Value.absent(),
    this.duration = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Medicine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? takeMorning,
    Expression<bool>? takeAfternoon,
    Expression<bool>? takeEvening,
    Expression<String>? morningTime,
    Expression<String>? afternoonTime,
    Expression<String>? eveningTime,
    Expression<int>? duration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (takeMorning != null) 'take_morning': takeMorning,
      if (takeAfternoon != null) 'take_afternoon': takeAfternoon,
      if (takeEvening != null) 'take_evening': takeEvening,
      if (morningTime != null) 'morning_time': morningTime,
      if (afternoonTime != null) 'afternoon_time': afternoonTime,
      if (eveningTime != null) 'evening_time': eveningTime,
      if (duration != null) 'duration': duration,
    });
  }

  MedicinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? takeMorning,
    Value<bool>? takeAfternoon,
    Value<bool>? takeEvening,
    Value<String?>? morningTime,
    Value<String?>? afternoonTime,
    Value<String?>? eveningTime,
    Value<int>? duration,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      takeMorning: takeMorning ?? this.takeMorning,
      takeAfternoon: takeAfternoon ?? this.takeAfternoon,
      takeEvening: takeEvening ?? this.takeEvening,
      morningTime: morningTime ?? this.morningTime,
      afternoonTime: afternoonTime ?? this.afternoonTime,
      eveningTime: eveningTime ?? this.eveningTime,
      duration: duration ?? this.duration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (takeMorning.present) {
      map['take_morning'] = Variable<bool>(takeMorning.value);
    }
    if (takeAfternoon.present) {
      map['take_afternoon'] = Variable<bool>(takeAfternoon.value);
    }
    if (takeEvening.present) {
      map['take_evening'] = Variable<bool>(takeEvening.value);
    }
    if (morningTime.present) {
      map['morning_time'] = Variable<String>(morningTime.value);
    }
    if (afternoonTime.present) {
      map['afternoon_time'] = Variable<String>(afternoonTime.value);
    }
    if (eveningTime.present) {
      map['evening_time'] = Variable<String>(eveningTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('takeMorning: $takeMorning, ')
          ..write('takeAfternoon: $takeAfternoon, ')
          ..write('takeEvening: $takeEvening, ')
          ..write('morningTime: $morningTime, ')
          ..write('afternoonTime: $afternoonTime, ')
          ..write('eveningTime: $eveningTime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }
}

class $MedicineLogsTable extends MedicineLogs
    with TableInfo<$MedicineLogsTable, MedicineLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicineLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id)',
    ),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<String> slot = GeneratedColumn<String>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTakenMeta = const VerificationMeta(
    'isTaken',
  );
  @override
  late final GeneratedColumn<bool> isTaken = GeneratedColumn<bool>(
    'is_taken',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_taken" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineId,
    takenAt,
    slot,
    isTaken,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicine_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicineLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('is_taken')) {
      context.handle(
        _isTakenMeta,
        isTaken.isAcceptableOrUnknown(data['is_taken']!, _isTakenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicineLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicineLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medicine_id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slot'],
      )!,
      isTaken: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_taken'],
      )!,
    );
  }

  @override
  $MedicineLogsTable createAlias(String alias) {
    return $MedicineLogsTable(attachedDatabase, alias);
  }
}

class MedicineLog extends DataClass implements Insertable<MedicineLog> {
  final int id;
  final int medicineId;
  final DateTime takenAt;
  final String slot;
  final bool isTaken;
  const MedicineLog({
    required this.id,
    required this.medicineId,
    required this.takenAt,
    required this.slot,
    required this.isTaken,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['slot'] = Variable<String>(slot);
    map['is_taken'] = Variable<bool>(isTaken);
    return map;
  }

  MedicineLogsCompanion toCompanion(bool nullToAbsent) {
    return MedicineLogsCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      takenAt: Value(takenAt),
      slot: Value(slot),
      isTaken: Value(isTaken),
    );
  }

  factory MedicineLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicineLog(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      slot: serializer.fromJson<String>(json['slot']),
      isTaken: serializer.fromJson<bool>(json['isTaken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'slot': serializer.toJson<String>(slot),
      'isTaken': serializer.toJson<bool>(isTaken),
    };
  }

  MedicineLog copyWith({
    int? id,
    int? medicineId,
    DateTime? takenAt,
    String? slot,
    bool? isTaken,
  }) => MedicineLog(
    id: id ?? this.id,
    medicineId: medicineId ?? this.medicineId,
    takenAt: takenAt ?? this.takenAt,
    slot: slot ?? this.slot,
    isTaken: isTaken ?? this.isTaken,
  );
  MedicineLog copyWithCompanion(MedicineLogsCompanion data) {
    return MedicineLog(
      id: data.id.present ? data.id.value : this.id,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      slot: data.slot.present ? data.slot.value : this.slot,
      isTaken: data.isTaken.present ? data.isTaken.value : this.isTaken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicineLog(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('takenAt: $takenAt, ')
          ..write('slot: $slot, ')
          ..write('isTaken: $isTaken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, medicineId, takenAt, slot, isTaken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicineLog &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.takenAt == this.takenAt &&
          other.slot == this.slot &&
          other.isTaken == this.isTaken);
}

class MedicineLogsCompanion extends UpdateCompanion<MedicineLog> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<DateTime> takenAt;
  final Value<String> slot;
  final Value<bool> isTaken;
  const MedicineLogsCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.slot = const Value.absent(),
    this.isTaken = const Value.absent(),
  });
  MedicineLogsCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required DateTime takenAt,
    required String slot,
    this.isTaken = const Value.absent(),
  }) : medicineId = Value(medicineId),
       takenAt = Value(takenAt),
       slot = Value(slot);
  static Insertable<MedicineLog> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<DateTime>? takenAt,
    Expression<String>? slot,
    Expression<bool>? isTaken,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (takenAt != null) 'taken_at': takenAt,
      if (slot != null) 'slot': slot,
      if (isTaken != null) 'is_taken': isTaken,
    });
  }

  MedicineLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? medicineId,
    Value<DateTime>? takenAt,
    Value<String>? slot,
    Value<bool>? isTaken,
  }) {
    return MedicineLogsCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      takenAt: takenAt ?? this.takenAt,
      slot: slot ?? this.slot,
      isTaken: isTaken ?? this.isTaken,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (slot.present) {
      map['slot'] = Variable<String>(slot.value);
    }
    if (isTaken.present) {
      map['is_taken'] = Variable<bool>(isTaken.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicineLogsCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('takenAt: $takenAt, ')
          ..write('slot: $slot, ')
          ..write('isTaken: $isTaken')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $MedicineLogsTable medicineLogs = $MedicineLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [medicines, medicineLogs];
}

typedef $$MedicinesTableCreateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> takeMorning,
      Value<bool> takeAfternoon,
      Value<bool> takeEvening,
      Value<String?> morningTime,
      Value<String?> afternoonTime,
      Value<String?> eveningTime,
      Value<int> duration,
    });
typedef $$MedicinesTableUpdateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> takeMorning,
      Value<bool> takeAfternoon,
      Value<bool> takeEvening,
      Value<String?> morningTime,
      Value<String?> afternoonTime,
      Value<String?> eveningTime,
      Value<int> duration,
    });

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MedicineLogsTable, List<MedicineLog>>
  _medicineLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.medicineLogs,
    aliasName: $_aliasNameGenerator(
      db.medicines.id,
      db.medicineLogs.medicineId,
    ),
  );

  $$MedicineLogsTableProcessedTableManager get medicineLogsRefs {
    final manager = $$MedicineLogsTableTableManager(
      $_db,
      $_db.medicineLogs,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_medicineLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get takeMorning => $composableBuilder(
    column: $table.takeMorning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get takeAfternoon => $composableBuilder(
    column: $table.takeAfternoon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get takeEvening => $composableBuilder(
    column: $table.takeEvening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get afternoonTime => $composableBuilder(
    column: $table.afternoonTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> medicineLogsRefs(
    Expression<bool> Function($$MedicineLogsTableFilterComposer f) f,
  ) {
    final $$MedicineLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicineLogs,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicineLogsTableFilterComposer(
            $db: $db,
            $table: $db.medicineLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get takeMorning => $composableBuilder(
    column: $table.takeMorning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get takeAfternoon => $composableBuilder(
    column: $table.takeAfternoon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get takeEvening => $composableBuilder(
    column: $table.takeEvening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get afternoonTime => $composableBuilder(
    column: $table.afternoonTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get takeMorning => $composableBuilder(
    column: $table.takeMorning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get takeAfternoon => $composableBuilder(
    column: $table.takeAfternoon,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get takeEvening => $composableBuilder(
    column: $table.takeEvening,
    builder: (column) => column,
  );

  GeneratedColumn<String> get morningTime => $composableBuilder(
    column: $table.morningTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get afternoonTime => $composableBuilder(
    column: $table.afternoonTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get eveningTime => $composableBuilder(
    column: $table.eveningTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  Expression<T> medicineLogsRefs<T extends Object>(
    Expression<T> Function($$MedicineLogsTableAnnotationComposer a) f,
  ) {
    final $$MedicineLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.medicineLogs,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicineLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.medicineLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTable,
          Medicine,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (Medicine, $$MedicinesTableReferences),
          Medicine,
          PrefetchHooks Function({bool medicineLogsRefs})
        > {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> takeMorning = const Value.absent(),
                Value<bool> takeAfternoon = const Value.absent(),
                Value<bool> takeEvening = const Value.absent(),
                Value<String?> morningTime = const Value.absent(),
                Value<String?> afternoonTime = const Value.absent(),
                Value<String?> eveningTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                name: name,
                takeMorning: takeMorning,
                takeAfternoon: takeAfternoon,
                takeEvening: takeEvening,
                morningTime: morningTime,
                afternoonTime: afternoonTime,
                eveningTime: eveningTime,
                duration: duration,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> takeMorning = const Value.absent(),
                Value<bool> takeAfternoon = const Value.absent(),
                Value<bool> takeEvening = const Value.absent(),
                Value<String?> morningTime = const Value.absent(),
                Value<String?> afternoonTime = const Value.absent(),
                Value<String?> eveningTime = const Value.absent(),
                Value<int> duration = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                name: name,
                takeMorning: takeMorning,
                takeAfternoon: takeAfternoon,
                takeEvening: takeEvening,
                morningTime: morningTime,
                afternoonTime: afternoonTime,
                eveningTime: eveningTime,
                duration: duration,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (medicineLogsRefs) db.medicineLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (medicineLogsRefs)
                    await $_getPrefetchedData<
                      Medicine,
                      $MedicinesTable,
                      MedicineLog
                    >(
                      currentTable: table,
                      referencedTable: $$MedicinesTableReferences
                          ._medicineLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MedicinesTableReferences(
                            db,
                            table,
                            p0,
                          ).medicineLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.medicineId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTable,
      Medicine,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (Medicine, $$MedicinesTableReferences),
      Medicine,
      PrefetchHooks Function({bool medicineLogsRefs})
    >;
typedef $$MedicineLogsTableCreateCompanionBuilder =
    MedicineLogsCompanion Function({
      Value<int> id,
      required int medicineId,
      required DateTime takenAt,
      required String slot,
      Value<bool> isTaken,
    });
typedef $$MedicineLogsTableUpdateCompanionBuilder =
    MedicineLogsCompanion Function({
      Value<int> id,
      Value<int> medicineId,
      Value<DateTime> takenAt,
      Value<String> slot,
      Value<bool> isTaken,
    });

final class $$MedicineLogsTableReferences
    extends BaseReferences<_$AppDatabase, $MedicineLogsTable, MedicineLog> {
  $$MedicineLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
        $_aliasNameGenerator(db.medicineLogs.medicineId, db.medicines.id),
      );

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MedicineLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTaken => $composableBuilder(
    column: $table.isTaken,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTaken => $composableBuilder(
    column: $table.isTaken,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicineLogsTable> {
  $$MedicineLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<bool> get isTaken =>
      $composableBuilder(column: $table.isTaken, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MedicineLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicineLogsTable,
          MedicineLog,
          $$MedicineLogsTableFilterComposer,
          $$MedicineLogsTableOrderingComposer,
          $$MedicineLogsTableAnnotationComposer,
          $$MedicineLogsTableCreateCompanionBuilder,
          $$MedicineLogsTableUpdateCompanionBuilder,
          (MedicineLog, $$MedicineLogsTableReferences),
          MedicineLog,
          PrefetchHooks Function({bool medicineId})
        > {
  $$MedicineLogsTableTableManager(_$AppDatabase db, $MedicineLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicineLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicineLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicineLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicineId = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<String> slot = const Value.absent(),
                Value<bool> isTaken = const Value.absent(),
              }) => MedicineLogsCompanion(
                id: id,
                medicineId: medicineId,
                takenAt: takenAt,
                slot: slot,
                isTaken: isTaken,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicineId,
                required DateTime takenAt,
                required String slot,
                Value<bool> isTaken = const Value.absent(),
              }) => MedicineLogsCompanion.insert(
                id: id,
                medicineId: medicineId,
                takenAt: takenAt,
                slot: slot,
                isTaken: isTaken,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicineLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicineId,
                                referencedTable: $$MedicineLogsTableReferences
                                    ._medicineIdTable(db),
                                referencedColumn: $$MedicineLogsTableReferences
                                    ._medicineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MedicineLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicineLogsTable,
      MedicineLog,
      $$MedicineLogsTableFilterComposer,
      $$MedicineLogsTableOrderingComposer,
      $$MedicineLogsTableAnnotationComposer,
      $$MedicineLogsTableCreateCompanionBuilder,
      $$MedicineLogsTableUpdateCompanionBuilder,
      (MedicineLog, $$MedicineLogsTableReferences),
      MedicineLog,
      PrefetchHooks Function({bool medicineId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$MedicineLogsTableTableManager get medicineLogs =>
      $$MedicineLogsTableTableManager(_db, _db.medicineLogs);
}
