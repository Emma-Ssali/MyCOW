// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeding_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBreedingRecordCollection on Isar {
  IsarCollection<BreedingRecord> get breedingRecords => this.collection();
}

const BreedingRecordSchema = CollectionSchema(
  name: r'BreedingRecord',
  id: -3054617548344924986,
  properties: {
    r'actualCalvingDate': PropertySchema(
      id: 0,
      name: r'actualCalvingDate',
      type: IsarType.dateTime,
    ),
    r'artificialInsemination': PropertySchema(
      id: 1,
      name: r'artificialInsemination',
      type: IsarType.bool,
    ),
    r'bullUsed': PropertySchema(
      id: 2,
      name: r'bullUsed',
      type: IsarType.string,
    ),
    r'calvesBorn': PropertySchema(
      id: 3,
      name: r'calvesBorn',
      type: IsarType.long,
    ),
    r'cowId': PropertySchema(
      id: 4,
      name: r'cowId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 6,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'expectedCalvingDate': PropertySchema(
      id: 7,
      name: r'expectedCalvingDate',
      type: IsarType.dateTime,
    ),
    r'farmId': PropertySchema(
      id: 8,
      name: r'farmId',
      type: IsarType.string,
    ),
    r'heatDate': PropertySchema(
      id: 9,
      name: r'heatDate',
      type: IsarType.dateTime,
    ),
    r'notes': PropertySchema(
      id: 10,
      name: r'notes',
      type: IsarType.string,
    ),
    r'pregnancyStatus': PropertySchema(
      id: 11,
      name: r'pregnancyStatus',
      type: IsarType.byte,
      enumMap: _BreedingRecordpregnancyStatusEnumValueMap,
    ),
    r'serviceDate': PropertySchema(
      id: 12,
      name: r'serviceDate',
      type: IsarType.dateTime,
    ),
    r'syncStatus': PropertySchema(
      id: 13,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _BreedingRecordsyncStatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _breedingRecordEstimateSize,
  serialize: _breedingRecordSerialize,
  deserialize: _breedingRecordDeserialize,
  deserializeProp: _breedingRecordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _breedingRecordGetId,
  getLinks: _breedingRecordGetLinks,
  attach: _breedingRecordAttach,
  version: '3.1.0+1',
);

int _breedingRecordEstimateSize(
  BreedingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bullUsed;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _breedingRecordSerialize(
  BreedingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.actualCalvingDate);
  writer.writeBool(offsets[1], object.artificialInsemination);
  writer.writeString(offsets[2], object.bullUsed);
  writer.writeLong(offsets[3], object.calvesBorn);
  writer.writeLong(offsets[4], object.cowId);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeString(offsets[6], object.createdBy);
  writer.writeDateTime(offsets[7], object.expectedCalvingDate);
  writer.writeString(offsets[8], object.farmId);
  writer.writeDateTime(offsets[9], object.heatDate);
  writer.writeString(offsets[10], object.notes);
  writer.writeByte(offsets[11], object.pregnancyStatus.index);
  writer.writeDateTime(offsets[12], object.serviceDate);
  writer.writeByte(offsets[13], object.syncStatus.index);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

BreedingRecord _breedingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BreedingRecord();
  object.actualCalvingDate = reader.readDateTimeOrNull(offsets[0]);
  object.artificialInsemination = reader.readBool(offsets[1]);
  object.bullUsed = reader.readStringOrNull(offsets[2]);
  object.calvesBorn = reader.readLongOrNull(offsets[3]);
  object.cowId = reader.readLong(offsets[4]);
  object.createdAt = reader.readDateTime(offsets[5]);
  object.createdBy = reader.readStringOrNull(offsets[6]);
  object.expectedCalvingDate = reader.readDateTimeOrNull(offsets[7]);
  object.farmId = reader.readStringOrNull(offsets[8]);
  object.heatDate = reader.readDateTimeOrNull(offsets[9]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[10]);
  object.pregnancyStatus = _BreedingRecordpregnancyStatusValueEnumMap[
          reader.readByteOrNull(offsets[11])] ??
      PregnancyStatus.unknown;
  object.serviceDate = reader.readDateTimeOrNull(offsets[12]);
  object.syncStatus = _BreedingRecordsyncStatusValueEnumMap[
          reader.readByteOrNull(offsets[13])] ??
      BreedingSyncStatus.pending;
  object.updatedAt = reader.readDateTime(offsets[14]);
  return object;
}

P _breedingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (_BreedingRecordpregnancyStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          PregnancyStatus.unknown) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (_BreedingRecordsyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BreedingSyncStatus.pending) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BreedingRecordpregnancyStatusEnumValueMap = {
  'unknown': 0,
  'confirmed': 1,
  'notPregnant': 2,
  'delivered': 3,
};
const _BreedingRecordpregnancyStatusValueEnumMap = {
  0: PregnancyStatus.unknown,
  1: PregnancyStatus.confirmed,
  2: PregnancyStatus.notPregnant,
  3: PregnancyStatus.delivered,
};
const _BreedingRecordsyncStatusEnumValueMap = {
  'pending': 0,
  'synced': 1,
  'failed': 2,
};
const _BreedingRecordsyncStatusValueEnumMap = {
  0: BreedingSyncStatus.pending,
  1: BreedingSyncStatus.synced,
  2: BreedingSyncStatus.failed,
};

Id _breedingRecordGetId(BreedingRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _breedingRecordGetLinks(BreedingRecord object) {
  return [];
}

void _breedingRecordAttach(
    IsarCollection<dynamic> col, Id id, BreedingRecord object) {
  object.id = id;
}

extension BreedingRecordQueryWhereSort
    on QueryBuilder<BreedingRecord, BreedingRecord, QWhere> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BreedingRecordQueryWhere
    on QueryBuilder<BreedingRecord, BreedingRecord, QWhereClause> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterWhereClause> idBetween(
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

extension BreedingRecordQueryFilter
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actualCalvingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actualCalvingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      actualCalvingDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualCalvingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      artificialInseminationEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artificialInsemination',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bullUsed',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bullUsed',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bullUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bullUsed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bullUsed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bullUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      bullUsedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bullUsed',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'calvesBorn',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'calvesBorn',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calvesBorn',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calvesBorn',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calvesBorn',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      calvesBornBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calvesBorn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      cowIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowId',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      cowIdLessThan(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      cowIdBetween(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'expectedCalvingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'expectedCalvingDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedCalvingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      expectedCalvingDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedCalvingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdEqualTo(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdBetween(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'farmId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      farmIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'heatDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'heatDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'heatDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'heatDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'heatDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      heatDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'heatDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesEqualTo(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesLessThan(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesBetween(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesEndsWith(
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      pregnancyStatusEqualTo(PregnancyStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pregnancyStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      pregnancyStatusGreaterThan(
    PregnancyStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pregnancyStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      pregnancyStatusLessThan(
    PregnancyStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pregnancyStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      pregnancyStatusBetween(
    PregnancyStatus lower,
    PregnancyStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pregnancyStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'serviceDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'serviceDate',
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'serviceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'serviceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'serviceDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      serviceDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'serviceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      syncStatusEqualTo(BreedingSyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      syncStatusGreaterThan(
    BreedingSyncStatus value, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      syncStatusLessThan(
    BreedingSyncStatus value, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      syncStatusBetween(
    BreedingSyncStatus lower,
    BreedingSyncStatus upper, {
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterFilterCondition>
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
}

extension BreedingRecordQueryObject
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {}

extension BreedingRecordQueryLinks
    on QueryBuilder<BreedingRecord, BreedingRecord, QFilterCondition> {}

extension BreedingRecordQuerySortBy
    on QueryBuilder<BreedingRecord, BreedingRecord, QSortBy> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByActualCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCalvingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByActualCalvingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCalvingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByArtificialInsemination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artificialInsemination', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByArtificialInseminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artificialInsemination', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByBullUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bullUsed', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByBullUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bullUsed', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByCalvesBorn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calvesBorn', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByCalvesBornDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calvesBorn', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByExpectedCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCalvingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByExpectedCalvingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCalvingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByHeatDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heatDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByHeatDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heatDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByPregnancyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregnancyStatus', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByPregnancyStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregnancyStatus', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BreedingRecordQuerySortThenBy
    on QueryBuilder<BreedingRecord, BreedingRecord, QSortThenBy> {
  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByActualCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCalvingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByActualCalvingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualCalvingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByArtificialInsemination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artificialInsemination', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByArtificialInseminationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artificialInsemination', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByBullUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bullUsed', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByBullUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bullUsed', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByCalvesBorn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calvesBorn', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByCalvesBornDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calvesBorn', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByExpectedCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCalvingDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByExpectedCalvingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedCalvingDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByHeatDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heatDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByHeatDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'heatDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByPregnancyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregnancyStatus', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByPregnancyStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pregnancyStatus', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceDate', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serviceDate', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BreedingRecordQueryWhereDistinct
    on QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> {
  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByActualCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualCalvingDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByArtificialInsemination() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artificialInsemination');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByBullUsed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bullUsed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByCalvesBorn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calvesBorn');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cowId');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByCreatedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByExpectedCalvingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedCalvingDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByFarmId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByHeatDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'heatDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByPregnancyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pregnancyStatus');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serviceDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<BreedingRecord, BreedingRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BreedingRecordQueryProperty
    on QueryBuilder<BreedingRecord, BreedingRecord, QQueryProperty> {
  QueryBuilder<BreedingRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BreedingRecord, DateTime?, QQueryOperations>
      actualCalvingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualCalvingDate');
    });
  }

  QueryBuilder<BreedingRecord, bool, QQueryOperations>
      artificialInseminationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artificialInsemination');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> bullUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bullUsed');
    });
  }

  QueryBuilder<BreedingRecord, int?, QQueryOperations> calvesBornProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calvesBorn');
    });
  }

  QueryBuilder<BreedingRecord, int, QQueryOperations> cowIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cowId');
    });
  }

  QueryBuilder<BreedingRecord, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<BreedingRecord, DateTime?, QQueryOperations>
      expectedCalvingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedCalvingDate');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> farmIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmId');
    });
  }

  QueryBuilder<BreedingRecord, DateTime?, QQueryOperations> heatDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'heatDate');
    });
  }

  QueryBuilder<BreedingRecord, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<BreedingRecord, PregnancyStatus, QQueryOperations>
      pregnancyStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pregnancyStatus');
    });
  }

  QueryBuilder<BreedingRecord, DateTime?, QQueryOperations>
      serviceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serviceDate');
    });
  }

  QueryBuilder<BreedingRecord, BreedingSyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<BreedingRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
