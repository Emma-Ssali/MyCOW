// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milk_production.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMilkProductionCollection on Isar {
  IsarCollection<MilkProduction> get milkProductions => this.collection();
}

const MilkProductionSchema = CollectionSchema(
  name: r'MilkProduction',
  id: 6617833595272517654,
  properties: {
    r'cowId': PropertySchema(
      id: 0,
      name: r'cowId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 2,
      name: r'createdBy',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'eveningLitres': PropertySchema(
      id: 4,
      name: r'eveningLitres',
      type: IsarType.double,
    ),
    r'farmId': PropertySchema(
      id: 5,
      name: r'farmId',
      type: IsarType.string,
    ),
    r'morningLitres': PropertySchema(
      id: 6,
      name: r'morningLitres',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 7,
      name: r'notes',
      type: IsarType.string,
    ),
    r'pricePerLitreUgx': PropertySchema(
      id: 8,
      name: r'pricePerLitreUgx',
      type: IsarType.double,
    ),
    r'syncStatus': PropertySchema(
      id: 9,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _MilkProductionsyncStatusEnumValueMap,
    ),
    r'totalLitres': PropertySchema(
      id: 10,
      name: r'totalLitres',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _milkProductionEstimateSize,
  serialize: _milkProductionSerialize,
  deserialize: _milkProductionDeserialize,
  deserializeProp: _milkProductionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _milkProductionGetId,
  getLinks: _milkProductionGetLinks,
  attach: _milkProductionAttach,
  version: '3.1.0+1',
);

int _milkProductionEstimateSize(
  MilkProduction object,
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
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _milkProductionSerialize(
  MilkProduction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.cowId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.createdBy);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeDouble(offsets[4], object.eveningLitres);
  writer.writeString(offsets[5], object.farmId);
  writer.writeDouble(offsets[6], object.morningLitres);
  writer.writeString(offsets[7], object.notes);
  writer.writeDouble(offsets[8], object.pricePerLitreUgx);
  writer.writeByte(offsets[9], object.syncStatus.index);
  writer.writeDouble(offsets[10], object.totalLitres);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

MilkProduction _milkProductionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MilkProduction();
  object.cowId = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.createdBy = reader.readStringOrNull(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.eveningLitres = reader.readDouble(offsets[4]);
  object.farmId = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.morningLitres = reader.readDouble(offsets[6]);
  object.notes = reader.readStringOrNull(offsets[7]);
  object.pricePerLitreUgx = reader.readDoubleOrNull(offsets[8]);
  object.syncStatus = _MilkProductionsyncStatusValueEnumMap[
          reader.readByteOrNull(offsets[9])] ??
      MilkSyncStatus.pending;
  object.totalLitres = reader.readDouble(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  return object;
}

P _milkProductionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (_MilkProductionsyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MilkSyncStatus.pending) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MilkProductionsyncStatusEnumValueMap = {
  'pending': 0,
  'synced': 1,
  'failed': 2,
};
const _MilkProductionsyncStatusValueEnumMap = {
  0: MilkSyncStatus.pending,
  1: MilkSyncStatus.synced,
  2: MilkSyncStatus.failed,
};

Id _milkProductionGetId(MilkProduction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _milkProductionGetLinks(MilkProduction object) {
  return [];
}

void _milkProductionAttach(
    IsarCollection<dynamic> col, Id id, MilkProduction object) {
  object.id = id;
}

extension MilkProductionQueryWhereSort
    on QueryBuilder<MilkProduction, MilkProduction, QWhere> {
  QueryBuilder<MilkProduction, MilkProduction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MilkProductionQueryWhere
    on QueryBuilder<MilkProduction, MilkProduction, QWhereClause> {
  QueryBuilder<MilkProduction, MilkProduction, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterWhereClause> idBetween(
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

extension MilkProductionQueryFilter
    on QueryBuilder<MilkProduction, MilkProduction, QFilterCondition> {
  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      cowIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowId',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdBy',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      createdByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdBy',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      dateLessThan(
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      dateBetween(
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      eveningLitresEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eveningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      eveningLitresGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eveningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      eveningLitresLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eveningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      eveningLitresBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eveningLitres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'farmId',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'farmId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'farmId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      farmIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'farmId',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      morningLitresEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'morningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      morningLitresGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'morningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      morningLitresLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'morningLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      morningLitresBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'morningLitres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pricePerLitreUgx',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pricePerLitreUgx',
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pricePerLitreUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pricePerLitreUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pricePerLitreUgx',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      pricePerLitreUgxBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pricePerLitreUgx',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      syncStatusEqualTo(MilkSyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      syncStatusGreaterThan(
    MilkSyncStatus value, {
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      syncStatusLessThan(
    MilkSyncStatus value, {
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      syncStatusBetween(
    MilkSyncStatus lower,
    MilkSyncStatus upper, {
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      totalLitresEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      totalLitresGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      totalLitresLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalLitres',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      totalLitresBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalLitres',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

  QueryBuilder<MilkProduction, MilkProduction, QAfterFilterCondition>
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

extension MilkProductionQueryObject
    on QueryBuilder<MilkProduction, MilkProduction, QFilterCondition> {}

extension MilkProductionQueryLinks
    on QueryBuilder<MilkProduction, MilkProduction, QFilterCondition> {}

extension MilkProductionQuerySortBy
    on QueryBuilder<MilkProduction, MilkProduction, QSortBy> {
  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByEveningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByEveningLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByMorningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByMorningLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByPricePerLitreUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLitreUgx', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByPricePerLitreUgxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLitreUgx', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByTotalLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MilkProductionQuerySortThenBy
    on QueryBuilder<MilkProduction, MilkProduction, QSortThenBy> {
  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByCowIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowId', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByEveningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByEveningLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eveningLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByFarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByFarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'farmId', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByMorningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByMorningLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'morningLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByPricePerLitreUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLitreUgx', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByPricePerLitreUgxDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pricePerLitreUgx', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByTotalLitresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalLitres', Sort.desc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MilkProductionQueryWhereDistinct
    on QueryBuilder<MilkProduction, MilkProduction, QDistinct> {
  QueryBuilder<MilkProduction, MilkProduction, QDistinct> distinctByCowId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cowId');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct> distinctByCreatedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByEveningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eveningLitres');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct> distinctByFarmId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'farmId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByMorningLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'morningLitres');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByPricePerLitreUgx() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pricePerLitreUgx');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByTotalLitres() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalLitres');
    });
  }

  QueryBuilder<MilkProduction, MilkProduction, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MilkProductionQueryProperty
    on QueryBuilder<MilkProduction, MilkProduction, QQueryProperty> {
  QueryBuilder<MilkProduction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MilkProduction, int, QQueryOperations> cowIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cowId');
    });
  }

  QueryBuilder<MilkProduction, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MilkProduction, String?, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<MilkProduction, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<MilkProduction, double, QQueryOperations>
      eveningLitresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eveningLitres');
    });
  }

  QueryBuilder<MilkProduction, String?, QQueryOperations> farmIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'farmId');
    });
  }

  QueryBuilder<MilkProduction, double, QQueryOperations>
      morningLitresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'morningLitres');
    });
  }

  QueryBuilder<MilkProduction, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<MilkProduction, double?, QQueryOperations>
      pricePerLitreUgxProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pricePerLitreUgx');
    });
  }

  QueryBuilder<MilkProduction, MilkSyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<MilkProduction, double, QQueryOperations> totalLitresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalLitres');
    });
  }

  QueryBuilder<MilkProduction, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
