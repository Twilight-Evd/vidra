// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoSettingsCollection on Isar {
  IsarCollection<VideoSettings> get videoSettings => this.collection();
}

const VideoSettingsSchema = CollectionSchema(
  name: r'VideoSettings',
  id: -2846096280015047827,
  properties: {
    r'introDuration': PropertySchema(
      id: 0,
      name: r'introDuration',
      type: IsarType.long,
    ),
    r'outroDuration': PropertySchema(
      id: 1,
      name: r'outroDuration',
      type: IsarType.long,
    ),
    r'sourceId': PropertySchema(
      id: 2,
      name: r'sourceId',
      type: IsarType.string,
    ),
    r'videoId': PropertySchema(
      id: 3,
      name: r'videoId',
      type: IsarType.long,
    )
  },
  estimateSize: _videoSettingsEstimateSize,
  serialize: _videoSettingsSerialize,
  deserialize: _videoSettingsDeserialize,
  deserializeProp: _videoSettingsDeserializeProp,
  idName: r'id',
  indexes: {
    r'sourceId_videoId': IndexSchema(
      id: 3251879204972429168,
      name: r'sourceId_videoId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'sourceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'videoId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _videoSettingsGetId,
  getLinks: _videoSettingsGetLinks,
  attach: _videoSettingsAttach,
  version: '3.1.0+1',
);

int _videoSettingsEstimateSize(
  VideoSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.sourceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _videoSettingsSerialize(
  VideoSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.introDuration);
  writer.writeLong(offsets[1], object.outroDuration);
  writer.writeString(offsets[2], object.sourceId);
  writer.writeLong(offsets[3], object.videoId);
}

VideoSettings _videoSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoSettings();
  object.id = id;
  object.introDuration = reader.readLong(offsets[0]);
  object.outroDuration = reader.readLong(offsets[1]);
  object.sourceId = reader.readStringOrNull(offsets[2]);
  object.videoId = reader.readLong(offsets[3]);
  return object;
}

P _videoSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoSettingsGetId(VideoSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoSettingsGetLinks(VideoSettings object) {
  return [];
}

void _videoSettingsAttach(
    IsarCollection<dynamic> col, Id id, VideoSettings object) {
  object.id = id;
}

extension VideoSettingsByIndex on IsarCollection<VideoSettings> {
  Future<VideoSettings?> getBySourceIdVideoId(String? sourceId, int videoId) {
    return getByIndex(r'sourceId_videoId', [sourceId, videoId]);
  }

  VideoSettings? getBySourceIdVideoIdSync(String? sourceId, int videoId) {
    return getByIndexSync(r'sourceId_videoId', [sourceId, videoId]);
  }

  Future<bool> deleteBySourceIdVideoId(String? sourceId, int videoId) {
    return deleteByIndex(r'sourceId_videoId', [sourceId, videoId]);
  }

  bool deleteBySourceIdVideoIdSync(String? sourceId, int videoId) {
    return deleteByIndexSync(r'sourceId_videoId', [sourceId, videoId]);
  }

  Future<List<VideoSettings?>> getAllBySourceIdVideoId(
      List<String?> sourceIdValues, List<int> videoIdValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i]]);
    }

    return getAllByIndex(r'sourceId_videoId', values);
  }

  List<VideoSettings?> getAllBySourceIdVideoIdSync(
      List<String?> sourceIdValues, List<int> videoIdValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i]]);
    }

    return getAllByIndexSync(r'sourceId_videoId', values);
  }

  Future<int> deleteAllBySourceIdVideoId(
      List<String?> sourceIdValues, List<int> videoIdValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i]]);
    }

    return deleteAllByIndex(r'sourceId_videoId', values);
  }

  int deleteAllBySourceIdVideoIdSync(
      List<String?> sourceIdValues, List<int> videoIdValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i]]);
    }

    return deleteAllByIndexSync(r'sourceId_videoId', values);
  }

  Future<Id> putBySourceIdVideoId(VideoSettings object) {
    return putByIndex(r'sourceId_videoId', object);
  }

  Id putBySourceIdVideoIdSync(VideoSettings object, {bool saveLinks = true}) {
    return putByIndexSync(r'sourceId_videoId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySourceIdVideoId(List<VideoSettings> objects) {
    return putAllByIndex(r'sourceId_videoId', objects);
  }

  List<Id> putAllBySourceIdVideoIdSync(List<VideoSettings> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sourceId_videoId', objects,
        saveLinks: saveLinks);
  }
}

extension VideoSettingsQueryWhereSort
    on QueryBuilder<VideoSettings, VideoSettings, QWhere> {
  QueryBuilder<VideoSettings, VideoSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VideoSettingsQueryWhere
    on QueryBuilder<VideoSettings, VideoSettings, QWhereClause> {
  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause> idBetween(
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

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdIsNullAnyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [null],
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdIsNotNullAnyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdEqualToAnyVideoId(String? sourceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [sourceId],
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdNotEqualToAnyVideoId(String? sourceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdVideoIdEqualTo(String? sourceId, int videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [sourceId, videoId],
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdEqualToVideoIdNotEqualTo(String? sourceId, int videoId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId],
              upper: [sourceId, videoId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId, videoId],
              includeLower: false,
              upper: [sourceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId, videoId],
              includeLower: false,
              upper: [sourceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId',
              lower: [sourceId],
              upper: [sourceId, videoId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdEqualToVideoIdGreaterThan(
    String? sourceId,
    int videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId',
        lower: [sourceId, videoId],
        includeLower: include,
        upper: [sourceId],
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdEqualToVideoIdLessThan(
    String? sourceId,
    int videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId',
        lower: [sourceId],
        upper: [sourceId, videoId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterWhereClause>
      sourceIdEqualToVideoIdBetween(
    String? sourceId,
    int lowerVideoId,
    int upperVideoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId',
        lower: [sourceId, lowerVideoId],
        includeLower: includeLower,
        upper: [sourceId, upperVideoId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VideoSettingsQueryFilter
    on QueryBuilder<VideoSettings, VideoSettings, QFilterCondition> {
  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
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

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      introDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'introDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      introDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'introDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      introDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'introDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      introDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'introDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      outroDurationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outroDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      outroDurationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outroDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      outroDurationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outroDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      outroDurationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outroDuration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      sourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      videoIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      videoIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      videoIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterFilterCondition>
      videoIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VideoSettingsQueryObject
    on QueryBuilder<VideoSettings, VideoSettings, QFilterCondition> {}

extension VideoSettingsQueryLinks
    on QueryBuilder<VideoSettings, VideoSettings, QFilterCondition> {}

extension VideoSettingsQuerySortBy
    on QueryBuilder<VideoSettings, VideoSettings, QSortBy> {
  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      sortByIntroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'introDuration', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      sortByIntroDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'introDuration', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      sortByOutroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outroDuration', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      sortByOutroDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outroDuration', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension VideoSettingsQuerySortThenBy
    on QueryBuilder<VideoSettings, VideoSettings, QSortThenBy> {
  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      thenByIntroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'introDuration', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      thenByIntroDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'introDuration', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      thenByOutroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outroDuration', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      thenByOutroDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outroDuration', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QAfterSortBy> thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension VideoSettingsQueryWhereDistinct
    on QueryBuilder<VideoSettings, VideoSettings, QDistinct> {
  QueryBuilder<VideoSettings, VideoSettings, QDistinct>
      distinctByIntroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'introDuration');
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QDistinct>
      distinctByOutroDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outroDuration');
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QDistinct> distinctBySourceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoSettings, VideoSettings, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }
}

extension VideoSettingsQueryProperty
    on QueryBuilder<VideoSettings, VideoSettings, QQueryProperty> {
  QueryBuilder<VideoSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoSettings, int, QQueryOperations> introDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'introDuration');
    });
  }

  QueryBuilder<VideoSettings, int, QQueryOperations> outroDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outroDuration');
    });
  }

  QueryBuilder<VideoSettings, String?, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<VideoSettings, int, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }
}
