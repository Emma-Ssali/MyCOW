// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHealthRecordCollection on Isar {
  IsarCollection<HealthRecord> get healthRecords => this.collection();
}

const HealthRecordSchema = CollectionSchema(
  name: r'HealthRecord',
  id: -2306919757135349190,
  properties: {
    r'costUgx': PropertySchema(
      id: 0,
      name: r'costUgx',
      type: IsarType.double,
    ),
    r'cowId': PropertySchema(
      id: 1,
      name: r'cowId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 3,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 4,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'farmId': PropertySchema(
      id: 5,
      name: r'farmId',
      type: IsarType.string,
    ),
    r'medication': PropertySchema(
      id: 6,
      name: r'medication',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 8,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _HealthRecordsyncStatusEnumValueMap,
    ),
    r'type': PropertySchema(
      id: 9,
      name: r'type',
      type: IsarType.byte,
      enumMap: _HealthRecordtypeEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'veterinarian': PropertySchema(
      id: 11,
      name: r'veterinarian',
      type: IsarType.string,
    )
  },
  estimateSize: _healthRecordEstimateSize,
  serialize: _healthRecordSerialize,
  deserialize: _healthRecordDeserialize,
  deserializeProp: _healthRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _healthRecordGetId,
  getLinks: _healthRecordGetLinks,
  attach: _healthRecordAttach,
  version: '3.1.0+1',
);

int _healthRecordEstimateSize(
  HealthRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.createdBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.farmId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.medication;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.veterinarian;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _healthRecordSerialize(
  HealthRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.costUgx);
  writer.writeLong(offsets[1], object.cowId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.createdBy);
  writer.writeDateTime(offsets[4], object.date);
  writer.writeString(offsets[5], object.farmId);
  writer.writeString(offsets[6], object.medication);
  writer.writeString(offsets[7], object.notes);
  writer.writeByte(offsets[8], object.syncStatus.index);
  writer.writeByte(offsets[9], object.type.index);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeString(offsets[11], object.veterinarian);
}

HealthRecord _healthRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HealthRecord();
  object.costUgx = reader.readDoubleOrNull(offsets[0]);
  object.cowId = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.createdBy = reader.readStringOrNull(offsets[3]);
  object.date = reader.readDateTime(offsets[4]);
  object.farmId = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.medication = reader.readStringOrNull(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.syncStatus =
      _HealthRecordsyncStatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          HealthSyncStatus.pending;
  object.type =
      _HealthRecordtypeValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          HealthRecordType.vaccination;
  object.updatedAt = reader.readDateTime(offsets[10]);
  object.veterinarian = reader.readStringOrNull(offsets[11]);
  return object;
}

P _healthRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (_HealthRecordsyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          HealthSyncStatus.pending) as P;
    case 9:
      return (_HealthRecordtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          HealthRecordType.vaccination) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HealthRecordsyncStatusEnumValueMap = {
  'pending': 0,
  'synced': 1,
  'failed': 2,
};
const _HealthRecordsyncStatusValueEnumMap = {
  0: HealthSyncStatus.pending,
  1: HealthSyncStatus.synced,
  2: HealthSyncStatus.failed,
};
const _HealthRecordtypeEnumValueMap = {
  'vaccination': 0,
  'treatment': 1,
  'deworming': 2,
  'vetVisit': 3,
  'disease': 4,
  'other': 5,
};
const _HealthRecordtypeValueEnumMap = {
  0: HealthRecordType.vaccination,
  1: HealthRecordType.treatment,
  2: HealthRecordType.deworming,
  3: HealthRecordType.vetVisit,
  4: HealthRecordType.disease,
  5: HealthRecordType.other,
};

Id _healthRecordGetId(HealthRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _healthRecordGetLinks(HealthRecord object) {
  return [];
}

void _healthRecordAttach(
    IsarCollection<dynamic> col, Id id, HealthRecord object) {
  object.id = id;
}

extension HealthRecordQueryWhereSort
    on QueryBuilder<HealthRecord, HealthRecord, QWhere> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HealthRecordQueryWhere
    on QueryBuilder<HealthRecord, HealthRecord, QWhereClause> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HealthRecordQueryFilter
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'costUgx',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'costUgx',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'costUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'costUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'costUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      costUgxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'costUgx',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> cowIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowId',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      cowIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cowId',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> cowIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cowId',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> cowIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cowId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> farmIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> farmIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'farmId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> farmIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'farmId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      farmIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'medication',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'medication',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medication',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medication',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medication',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medication',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      medicationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medication',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      syncStatusEqualTo(HealthSyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      syncStatusGreaterThan(
    HealthSyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      syncStatusLessThan(
    HealthSyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      syncStatusBetween(
    HealthSyncStatus lower,
    HealthSyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> typeEqualTo(
      HealthRecordType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      typeGreaterThan(
    HealthRecordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> typeLessThan(
    HealthRecordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition> typeBetween(
    HealthRecordType lower,
    HealthRecordType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'veterinarian',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'veterinarian',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'veterinarian',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'veterinarian',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'veterinarian',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'veterinarian',
        value: '',
      ));
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterFilterCondition>
      veterinarianIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'veterinarian',
        value: '',
      ));
    });
  }
}

extension HealthRecordQueryObject
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {}

extension HealthRecordQueryLinks
    on QueryBuilder<HealthRecord, HealthRecord, QFilterCondition> {}

extension HealthRecordQuerySortBy
    on QueryBuilder<HealthRecord, HealthRecord, QSortBy> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCostUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costUgx', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCostUgxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costUgx', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByMedication() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medication', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortByMedicationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medication', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> sortByVeterinarian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veterinarian', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      sortByVeterinarianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veterinarian', Sort.desc);
    });
  }
}

extension HealthRecordQuerySortThenBy
    on QueryBuilder<HealthRecord, HealthRecord, QSortThenBy> {
  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCostUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costUgx', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCostUgxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costUgx', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByMedication() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medication', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenByMedicationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medication', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy> thenByVeterinarian() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veterinarian', Sort.asc);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QAfterSortBy>
      thenByVeterinarianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'veterinarian', Sort.desc);
    });
  }
}

extension HealthRecordQueryWhereDistinct
    on QueryBuilder<HealthRecord, HealthRecord, QDistinct> {
  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCostUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'costUgx');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cowId');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByCreatedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByFarmId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByMedication(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medication', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<HealthRecord, HealthRecord, QDistinct> distinctByVeterinarian(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'veterinarian', caseSensitive: caseSensitive);
    });
  }
}

extension HealthRecordQueryProperty
    on QueryBuilder<HealthRecord, HealthRecord, QQueryProperty> {
  QueryBuilder<HealthRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HealthRecord, double?, QQueryOperations> costUgxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'costUgx');
    });
  }

  QueryBuilder<HealthRecord, int, QQueryOperations> cowIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cowId');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> farmIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmId');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> medicationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medication');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<HealthRecord, HealthSyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<HealthRecord, HealthRecordType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<HealthRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<HealthRecord, String?, QQueryOperations> veterinarianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'veterinarian');
    });
  }
}
