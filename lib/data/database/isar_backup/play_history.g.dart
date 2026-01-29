// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_history.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVideoHistoryCollection on Isar {
  IsarCollection<VideoHistory> get videoHistorys => this.collection();
}

const VideoHistorySchema = CollectionSchema(
  name: r'VideoHistory',
  id: 1082140833610298097,
  properties: {
    r'actor': PropertySchema(
      id: 0,
      name: r'actor',
      type: IsarType.string,
    ),
    r'blurb': PropertySchema(
      id: 1,
      name: r'blurb',
      type: IsarType.string,
    ),
    r'coverUrl': PropertySchema(
      id: 2,
      name: r'coverUrl',
      type: IsarType.string,
    ),
    r'hits': PropertySchema(
      id: 3,
      name: r'hits',
      type: IsarType.long,
    ),
    r'lastEpisodeIndex': PropertySchema(
      id: 4,
      name: r'lastEpisodeIndex',
      type: IsarType.long,
    ),
    r'lastEpisodeTitle': PropertySchema(
      id: 5,
      name: r'lastEpisodeTitle',
      type: IsarType.string,
    ),
    r'rating': PropertySchema(
      id: 6,
      name: r'rating',
      type: IsarType.string,
    ),
    r'region': PropertySchema(
      id: 7,
      name: r'region',
      type: IsarType.string,
    ),
    r'remarks': PropertySchema(
      id: 8,
      name: r'remarks',
      type: IsarType.string,
    ),
    r'sourceId': PropertySchema(
      id: 9,
      name: r'sourceId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 10,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(
      id: 12,
      name: r'version',
      type: IsarType.string,
    ),
    r'videoId': PropertySchema(
      id: 13,
      name: r'videoId',
      type: IsarType.long,
    ),
    r'videoTitle': PropertySchema(
      id: 14,
      name: r'videoTitle',
      type: IsarType.string,
    ),
    r'year': PropertySchema(
      id: 15,
      name: r'year',
      type: IsarType.string,
    )
  },
  estimateSize: _videoHistoryEstimateSize,
  serialize: _videoHistorySerialize,
  deserialize: _videoHistoryDeserialize,
  deserializeProp: _videoHistoryDeserializeProp,
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
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _videoHistoryGetId,
  getLinks: _videoHistoryGetLinks,
  attach: _videoHistoryAttach,
  version: '3.1.0+1',
);

int _videoHistoryEstimateSize(
  VideoHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.blurb;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.coverUrl.length * 3;
  {
    final value = object.lastEpisodeTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rating;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.region;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remarks;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  {
    final value = object.version;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.videoTitle.length * 3;
  {
    final value = object.year;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _videoHistorySerialize(
  VideoHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actor);
  writer.writeString(offsets[1], object.blurb);
  writer.writeString(offsets[2], object.coverUrl);
  writer.writeLong(offsets[3], object.hits);
  writer.writeLong(offsets[4], object.lastEpisodeIndex);
  writer.writeString(offsets[5], object.lastEpisodeTitle);
  writer.writeString(offsets[6], object.rating);
  writer.writeString(offsets[7], object.region);
  writer.writeString(offsets[8], object.remarks);
  writer.writeString(offsets[9], object.sourceId);
  writer.writeString(offsets[10], object.type);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeString(offsets[12], object.version);
  writer.writeLong(offsets[13], object.videoId);
  writer.writeString(offsets[14], object.videoTitle);
  writer.writeString(offsets[15], object.year);
}

VideoHistory _videoHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VideoHistory();
  object.actor = reader.readStringOrNull(offsets[0]);
  object.blurb = reader.readStringOrNull(offsets[1]);
  object.coverUrl = reader.readString(offsets[2]);
  object.hits = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.lastEpisodeIndex = reader.readLong(offsets[4]);
  object.lastEpisodeTitle = reader.readStringOrNull(offsets[5]);
  object.rating = reader.readStringOrNull(offsets[6]);
  object.region = reader.readStringOrNull(offsets[7]);
  object.remarks = reader.readStringOrNull(offsets[8]);
  object.sourceId = reader.readStringOrNull(offsets[9]);
  object.type = reader.readString(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.version = reader.readStringOrNull(offsets[12]);
  object.videoId = reader.readLong(offsets[13]);
  object.videoTitle = reader.readString(offsets[14]);
  object.year = reader.readStringOrNull(offsets[15]);
  return object;
}

P _videoHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _videoHistoryGetId(VideoHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _videoHistoryGetLinks(VideoHistory object) {
  return [];
}

void _videoHistoryAttach(
    IsarCollection<dynamic> col, Id id, VideoHistory object) {
  object.id = id;
}

extension VideoHistoryByIndex on IsarCollection<VideoHistory> {
  Future<VideoHistory?> getBySourceIdVideoId(String? sourceId, int videoId) {
    return getByIndex(r'sourceId_videoId', [sourceId, videoId]);
  }

  VideoHistory? getBySourceIdVideoIdSync(String? sourceId, int videoId) {
    return getByIndexSync(r'sourceId_videoId', [sourceId, videoId]);
  }

  Future<bool> deleteBySourceIdVideoId(String? sourceId, int videoId) {
    return deleteByIndex(r'sourceId_videoId', [sourceId, videoId]);
  }

  bool deleteBySourceIdVideoIdSync(String? sourceId, int videoId) {
    return deleteByIndexSync(r'sourceId_videoId', [sourceId, videoId]);
  }

  Future<List<VideoHistory?>> getAllBySourceIdVideoId(
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

  List<VideoHistory?> getAllBySourceIdVideoIdSync(
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

  Future<Id> putBySourceIdVideoId(VideoHistory object) {
    return putByIndex(r'sourceId_videoId', object);
  }

  Id putBySourceIdVideoIdSync(VideoHistory object, {bool saveLinks = true}) {
    return putByIndexSync(r'sourceId_videoId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySourceIdVideoId(List<VideoHistory> objects) {
    return putAllByIndex(r'sourceId_videoId', objects);
  }

  List<Id> putAllBySourceIdVideoIdSync(List<VideoHistory> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sourceId_videoId', objects,
        saveLinks: saveLinks);
  }
}

extension VideoHistoryQueryWhereSort
    on QueryBuilder<VideoHistory, VideoHistory, QWhere> {
  QueryBuilder<VideoHistory, VideoHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension VideoHistoryQueryWhere
    on QueryBuilder<VideoHistory, VideoHistory, QWhereClause> {
  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> idBetween(
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
      sourceIdIsNullAnyVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [null],
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
      sourceIdEqualToAnyVideoId(String? sourceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [sourceId],
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
      sourceIdVideoIdEqualTo(String? sourceId, int videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId',
        value: [sourceId, videoId],
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> updatedAtEqualTo(
      DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterWhereClause> updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension VideoHistoryQueryFilter
    on QueryBuilder<VideoHistory, VideoHistory, QFilterCondition> {
  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actor',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actor',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> actorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actor',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      actorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actor',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'blurb',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'blurb',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'blurb',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'blurb',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> blurbMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'blurb',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'blurb',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      blurbIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'blurb',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'coverUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'coverUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'coverUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'coverUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      coverUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'coverUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> hitsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hits',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      hitsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hits',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> hitsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hits',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      hitsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hits',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> hitsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hits',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> hitsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hits',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEpisodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEpisodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEpisodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEpisodeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastEpisodeTitle',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastEpisodeTitle',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEpisodeTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastEpisodeTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastEpisodeTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEpisodeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      lastEpisodeTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastEpisodeTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rating',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> ratingEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> ratingBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rating',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> ratingMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rating',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rating',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      ratingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rating',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'region',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> regionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> regionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'region',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'region',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> regionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'region',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      regionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'region',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remarks',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remarks',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remarks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remarks',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remarks',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remarks',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      remarksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remarks',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      sourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'version',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'version',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'version',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'version',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'version',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'version',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
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

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'videoTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'videoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'videoTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      videoTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'videoTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'year',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      yearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'year',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      yearGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'year',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      yearStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'year',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition> yearMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'year',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      yearIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'year',
        value: '',
      ));
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterFilterCondition>
      yearIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'year',
        value: '',
      ));
    });
  }
}

extension VideoHistoryQueryObject
    on QueryBuilder<VideoHistory, VideoHistory, QFilterCondition> {}

extension VideoHistoryQueryLinks
    on QueryBuilder<VideoHistory, VideoHistory, QFilterCondition> {}

extension VideoHistoryQuerySortBy
    on QueryBuilder<VideoHistory, VideoHistory, QSortBy> {
  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByActor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByActorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByBlurb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blurb', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByBlurbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blurb', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByHits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hits', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByHitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hits', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      sortByLastEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeIndex', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      sortByLastEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeIndex', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      sortByLastEpisodeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeTitle', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      sortByLastEpisodeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeTitle', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRemarks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remarks', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByRemarksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remarks', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByVideoTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoTitle', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      sortByVideoTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoTitle', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> sortByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension VideoHistoryQuerySortThenBy
    on QueryBuilder<VideoHistory, VideoHistory, QSortThenBy> {
  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByActor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByActorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actor', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByBlurb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blurb', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByBlurbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'blurb', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByCoverUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByCoverUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'coverUrl', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByHits() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hits', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByHitsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hits', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      thenByLastEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeIndex', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      thenByLastEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeIndex', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      thenByLastEpisodeTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeTitle', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      thenByLastEpisodeTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEpisodeTitle', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRegion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRegionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'region', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRemarks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remarks', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByRemarksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remarks', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByVideoTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoTitle', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy>
      thenByVideoTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoTitle', Sort.desc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.asc);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QAfterSortBy> thenByYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'year', Sort.desc);
    });
  }
}

extension VideoHistoryQueryWhereDistinct
    on QueryBuilder<VideoHistory, VideoHistory, QDistinct> {
  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByActor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByBlurb(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'blurb', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByCoverUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'coverUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByHits() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hits');
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct>
      distinctByLastEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEpisodeIndex');
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct>
      distinctByLastEpisodeTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEpisodeTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByRating(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByRegion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'region', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByRemarks(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remarks', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctBySourceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByVersion(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByVideoTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VideoHistory, VideoHistory, QDistinct> distinctByYear(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'year', caseSensitive: caseSensitive);
    });
  }
}

extension VideoHistoryQueryProperty
    on QueryBuilder<VideoHistory, VideoHistory, QQueryProperty> {
  QueryBuilder<VideoHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> actorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actor');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> blurbProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'blurb');
    });
  }

  QueryBuilder<VideoHistory, String, QQueryOperations> coverUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coverUrl');
    });
  }

  QueryBuilder<VideoHistory, int?, QQueryOperations> hitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hits');
    });
  }

  QueryBuilder<VideoHistory, int, QQueryOperations> lastEpisodeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEpisodeIndex');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations>
      lastEpisodeTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEpisodeTitle');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> regionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'region');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> remarksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remarks');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<VideoHistory, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<VideoHistory, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<VideoHistory, int, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }

  QueryBuilder<VideoHistory, String, QQueryOperations> videoTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoTitle');
    });
  }

  QueryBuilder<VideoHistory, String?, QQueryOperations> yearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'year');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetEpisodeHistoryCollection on Isar {
  IsarCollection<EpisodeHistory> get episodeHistorys => this.collection();
}

const EpisodeHistorySchema = CollectionSchema(
  name: r'EpisodeHistory',
  id: -2267724701014039047,
  properties: {
    r'durationMillis': PropertySchema(
      id: 0,
      name: r'durationMillis',
      type: IsarType.long,
    ),
    r'episodeIndex': PropertySchema(
      id: 1,
      name: r'episodeIndex',
      type: IsarType.long,
    ),
    r'positionMillis': PropertySchema(
      id: 2,
      name: r'positionMillis',
      type: IsarType.long,
    ),
    r'sourceId': PropertySchema(
      id: 3,
      name: r'sourceId',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'videoId': PropertySchema(
      id: 5,
      name: r'videoId',
      type: IsarType.long,
    )
  },
  estimateSize: _episodeHistoryEstimateSize,
  serialize: _episodeHistorySerialize,
  deserialize: _episodeHistoryDeserialize,
  deserializeProp: _episodeHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'sourceId_videoId_episodeIndex': IndexSchema(
      id: -9116497671683262617,
      name: r'sourceId_videoId_episodeIndex',
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
        ),
        IndexPropertySchema(
          name: r'episodeIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _episodeHistoryGetId,
  getLinks: _episodeHistoryGetLinks,
  attach: _episodeHistoryAttach,
  version: '3.1.0+1',
);

int _episodeHistoryEstimateSize(
  EpisodeHistory object,
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

void _episodeHistorySerialize(
  EpisodeHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationMillis);
  writer.writeLong(offsets[1], object.episodeIndex);
  writer.writeLong(offsets[2], object.positionMillis);
  writer.writeString(offsets[3], object.sourceId);
  writer.writeDateTime(offsets[4], object.updatedAt);
  writer.writeLong(offsets[5], object.videoId);
}

EpisodeHistory _episodeHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = EpisodeHistory();
  object.durationMillis = reader.readLong(offsets[0]);
  object.episodeIndex = reader.readLong(offsets[1]);
  object.id = id;
  object.positionMillis = reader.readLong(offsets[2]);
  object.sourceId = reader.readStringOrNull(offsets[3]);
  object.updatedAt = reader.readDateTime(offsets[4]);
  object.videoId = reader.readLong(offsets[5]);
  return object;
}

P _episodeHistoryDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _episodeHistoryGetId(EpisodeHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _episodeHistoryGetLinks(EpisodeHistory object) {
  return [];
}

void _episodeHistoryAttach(
    IsarCollection<dynamic> col, Id id, EpisodeHistory object) {
  object.id = id;
}

extension EpisodeHistoryByIndex on IsarCollection<EpisodeHistory> {
  Future<EpisodeHistory?> getBySourceIdVideoIdEpisodeIndex(
      String? sourceId, int videoId, int episodeIndex) {
    return getByIndex(
        r'sourceId_videoId_episodeIndex', [sourceId, videoId, episodeIndex]);
  }

  EpisodeHistory? getBySourceIdVideoIdEpisodeIndexSync(
      String? sourceId, int videoId, int episodeIndex) {
    return getByIndexSync(
        r'sourceId_videoId_episodeIndex', [sourceId, videoId, episodeIndex]);
  }

  Future<bool> deleteBySourceIdVideoIdEpisodeIndex(
      String? sourceId, int videoId, int episodeIndex) {
    return deleteByIndex(
        r'sourceId_videoId_episodeIndex', [sourceId, videoId, episodeIndex]);
  }

  bool deleteBySourceIdVideoIdEpisodeIndexSync(
      String? sourceId, int videoId, int episodeIndex) {
    return deleteByIndexSync(
        r'sourceId_videoId_episodeIndex', [sourceId, videoId, episodeIndex]);
  }

  Future<List<EpisodeHistory?>> getAllBySourceIdVideoIdEpisodeIndex(
      List<String?> sourceIdValues,
      List<int> videoIdValues,
      List<int> episodeIndexValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len && episodeIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i], episodeIndexValues[i]]);
    }

    return getAllByIndex(r'sourceId_videoId_episodeIndex', values);
  }

  List<EpisodeHistory?> getAllBySourceIdVideoIdEpisodeIndexSync(
      List<String?> sourceIdValues,
      List<int> videoIdValues,
      List<int> episodeIndexValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len && episodeIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i], episodeIndexValues[i]]);
    }

    return getAllByIndexSync(r'sourceId_videoId_episodeIndex', values);
  }

  Future<int> deleteAllBySourceIdVideoIdEpisodeIndex(
      List<String?> sourceIdValues,
      List<int> videoIdValues,
      List<int> episodeIndexValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len && episodeIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i], episodeIndexValues[i]]);
    }

    return deleteAllByIndex(r'sourceId_videoId_episodeIndex', values);
  }

  int deleteAllBySourceIdVideoIdEpisodeIndexSync(List<String?> sourceIdValues,
      List<int> videoIdValues, List<int> episodeIndexValues) {
    final len = sourceIdValues.length;
    assert(videoIdValues.length == len && episodeIndexValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([sourceIdValues[i], videoIdValues[i], episodeIndexValues[i]]);
    }

    return deleteAllByIndexSync(r'sourceId_videoId_episodeIndex', values);
  }

  Future<Id> putBySourceIdVideoIdEpisodeIndex(EpisodeHistory object) {
    return putByIndex(r'sourceId_videoId_episodeIndex', object);
  }

  Id putBySourceIdVideoIdEpisodeIndexSync(EpisodeHistory object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'sourceId_videoId_episodeIndex', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySourceIdVideoIdEpisodeIndex(
      List<EpisodeHistory> objects) {
    return putAllByIndex(r'sourceId_videoId_episodeIndex', objects);
  }

  List<Id> putAllBySourceIdVideoIdEpisodeIndexSync(List<EpisodeHistory> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'sourceId_videoId_episodeIndex', objects,
        saveLinks: saveLinks);
  }
}

extension EpisodeHistoryQueryWhereSort
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QWhere> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension EpisodeHistoryQueryWhere
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QWhereClause> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause> idBetween(
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdIsNullAnyVideoIdEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId_episodeIndex',
        value: [null],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdIsNotNullAnyVideoIdEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdEqualToAnyVideoIdEpisodeIndex(String? sourceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId_episodeIndex',
        value: [sourceId],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdNotEqualToAnyVideoIdEpisodeIndex(String? sourceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEqualToAnyEpisodeIndex(String? sourceId, int videoId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId_episodeIndex',
        value: [sourceId, videoId],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdEqualToVideoIdNotEqualToAnyEpisodeIndex(
          String? sourceId, int videoId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId],
              upper: [sourceId, videoId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId],
              includeLower: false,
              upper: [sourceId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId],
              includeLower: false,
              upper: [sourceId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId],
              upper: [sourceId, videoId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdEqualToVideoIdGreaterThanAnyEpisodeIndex(
    String? sourceId,
    int videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId, videoId],
        includeLower: include,
        upper: [sourceId],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdEqualToVideoIdLessThanAnyEpisodeIndex(
    String? sourceId,
    int videoId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId],
        upper: [sourceId, videoId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdEqualToVideoIdBetweenAnyEpisodeIndex(
    String? sourceId,
    int lowerVideoId,
    int upperVideoId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId, lowerVideoId],
        includeLower: includeLower,
        upper: [sourceId, upperVideoId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEpisodeIndexEqualTo(
          String? sourceId, int videoId, int episodeIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId_videoId_episodeIndex',
        value: [sourceId, videoId, episodeIndex],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEqualToEpisodeIndexNotEqualTo(
          String? sourceId, int videoId, int episodeIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId],
              upper: [sourceId, videoId, episodeIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId, episodeIndex],
              includeLower: false,
              upper: [sourceId, videoId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId, episodeIndex],
              includeLower: false,
              upper: [sourceId, videoId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId_videoId_episodeIndex',
              lower: [sourceId, videoId],
              upper: [sourceId, videoId, episodeIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEqualToEpisodeIndexGreaterThan(
    String? sourceId,
    int videoId,
    int episodeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId, videoId, episodeIndex],
        includeLower: include,
        upper: [sourceId, videoId],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEqualToEpisodeIndexLessThan(
    String? sourceId,
    int videoId,
    int episodeIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId, videoId],
        upper: [sourceId, videoId, episodeIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      sourceIdVideoIdEqualToEpisodeIndexBetween(
    String? sourceId,
    int videoId,
    int lowerEpisodeIndex,
    int upperEpisodeIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId_videoId_episodeIndex',
        lower: [sourceId, videoId, lowerEpisodeIndex],
        includeLower: includeLower,
        upper: [sourceId, videoId, upperEpisodeIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension EpisodeHistoryQueryFilter
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QFilterCondition> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      durationMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      durationMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      durationMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      durationMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      episodeIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      episodeIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      episodeIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'episodeIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      episodeIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'episodeIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition> idBetween(
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      positionMillisEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      positionMillisGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      positionMillisLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionMillis',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      positionMillisBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionMillis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      sourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
      videoIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'videoId',
        value: value,
      ));
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterFilterCondition>
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

extension EpisodeHistoryQueryObject
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QFilterCondition> {}

extension EpisodeHistoryQueryLinks
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QFilterCondition> {}

extension EpisodeHistoryQuerySortBy
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QSortBy> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByDurationMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMillis', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByDurationMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMillis', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByPositionMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMillis', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByPositionMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMillis', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> sortByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      sortByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension EpisodeHistoryQuerySortThenBy
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QSortThenBy> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByDurationMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMillis', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByDurationMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMillis', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByEpisodeIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'episodeIndex', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByPositionMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMillis', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByPositionMillisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'positionMillis', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy> thenByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.asc);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QAfterSortBy>
      thenByVideoIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'videoId', Sort.desc);
    });
  }
}

extension EpisodeHistoryQueryWhereDistinct
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct> {
  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct>
      distinctByDurationMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMillis');
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct>
      distinctByEpisodeIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'episodeIndex');
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct>
      distinctByPositionMillis() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'positionMillis');
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct> distinctBySourceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<EpisodeHistory, EpisodeHistory, QDistinct> distinctByVideoId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'videoId');
    });
  }
}

extension EpisodeHistoryQueryProperty
    on QueryBuilder<EpisodeHistory, EpisodeHistory, QQueryProperty> {
  QueryBuilder<EpisodeHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<EpisodeHistory, int, QQueryOperations> durationMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMillis');
    });
  }

  QueryBuilder<EpisodeHistory, int, QQueryOperations> episodeIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'episodeIndex');
    });
  }

  QueryBuilder<EpisodeHistory, int, QQueryOperations> positionMillisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'positionMillis');
    });
  }

  QueryBuilder<EpisodeHistory, String?, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<EpisodeHistory, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<EpisodeHistory, int, QQueryOperations> videoIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videoId');
    });
  }
}
