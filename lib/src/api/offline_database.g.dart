// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class _ChannelData extends DataClass implements Insertable<_ChannelData> {
  final String id;
  final String type;
  final String cid;
  final bool frozen;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final int memberCount;
  final Map<String, dynamic> extraData;
  final String createdBy;
  _ChannelData(
      {@required this.id,
      @required this.type,
      @required this.cid,
      @required this.frozen,
      this.lastMessageAt,
      @required this.createdAt,
      @required this.updatedAt,
      this.deletedAt,
      @required this.memberCount,
      this.extraData,
      this.createdBy});
  factory _ChannelData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return _ChannelData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      cid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}cid']),
      frozen:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}frozen']),
      lastMessageAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_message_at']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      deletedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}deleted_at']),
      memberCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}member_count']),
      extraData: $_ChannelTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
      createdBy: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_by']),
    );
  }
  factory _ChannelData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _ChannelData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      cid: serializer.fromJson<String>(json['cid']),
      frozen: serializer.fromJson<bool>(json['frozen']),
      lastMessageAt: serializer.fromJson<DateTime>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime>(json['deletedAt']),
      memberCount: serializer.fromJson<int>(json['memberCount']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'cid': serializer.toJson<String>(cid),
      'frozen': serializer.toJson<bool>(frozen),
      'lastMessageAt': serializer.toJson<DateTime>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime>(deletedAt),
      'memberCount': serializer.toJson<int>(memberCount),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
      'createdBy': serializer.toJson<String>(createdBy),
    };
  }

  @override
  _ChannelCompanion createCompanion(bool nullToAbsent) {
    return _ChannelCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      frozen:
          frozen == null && nullToAbsent ? const Value.absent() : Value(frozen),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      memberCount: memberCount == null && nullToAbsent
          ? const Value.absent()
          : Value(memberCount),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  _ChannelData copyWith(
          {String id,
          String type,
          String cid,
          bool frozen,
          DateTime lastMessageAt,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime deletedAt,
          int memberCount,
          Map<String, dynamic> extraData,
          String createdBy}) =>
      _ChannelData(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
        frozen: frozen ?? this.frozen,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        memberCount: memberCount ?? this.memberCount,
        extraData: extraData ?? this.extraData,
        createdBy: createdBy ?? this.createdBy,
      );
  @override
  String toString() {
    return (StringBuffer('_ChannelData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('frozen: $frozen, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('memberCount: $memberCount, ')
          ..write('extraData: $extraData, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          type.hashCode,
          $mrjc(
              cid.hashCode,
              $mrjc(
                  frozen.hashCode,
                  $mrjc(
                      lastMessageAt.hashCode,
                      $mrjc(
                          createdAt.hashCode,
                          $mrjc(
                              updatedAt.hashCode,
                              $mrjc(
                                  deletedAt.hashCode,
                                  $mrjc(
                                      memberCount.hashCode,
                                      $mrjc(extraData.hashCode,
                                          createdBy.hashCode)))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _ChannelData &&
          other.id == this.id &&
          other.type == this.type &&
          other.cid == this.cid &&
          other.frozen == this.frozen &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.memberCount == this.memberCount &&
          other.extraData == this.extraData &&
          other.createdBy == this.createdBy);
}

class _ChannelCompanion extends UpdateCompanion<_ChannelData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> cid;
  final Value<bool> frozen;
  final Value<DateTime> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> deletedAt;
  final Value<int> memberCount;
  final Value<Map<String, dynamic>> extraData;
  final Value<String> createdBy;
  const _ChannelCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.cid = const Value.absent(),
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  _ChannelCompanion.insert({
    @required String id,
    @required String type,
    @required String cid,
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    @required DateTime createdAt,
    @required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    @required int memberCount,
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        cid = Value(cid),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        memberCount = Value(memberCount);
  _ChannelCompanion copyWith(
      {Value<String> id,
      Value<String> type,
      Value<String> cid,
      Value<bool> frozen,
      Value<DateTime> lastMessageAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> deletedAt,
      Value<int> memberCount,
      Value<Map<String, dynamic>> extraData,
      Value<String> createdBy}) {
    return _ChannelCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      cid: cid ?? this.cid,
      frozen: frozen ?? this.frozen,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      memberCount: memberCount ?? this.memberCount,
      extraData: extraData ?? this.extraData,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

class $_ChannelTable extends _Channel
    with TableInfo<$_ChannelTable, _ChannelData> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ChannelTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _cidMeta = const VerificationMeta('cid');
  GeneratedTextColumn _cid;
  @override
  GeneratedTextColumn get cid => _cid ??= _constructCid();
  GeneratedTextColumn _constructCid() {
    return GeneratedTextColumn(
      'cid',
      $tableName,
      false,
    );
  }

  final VerificationMeta _frozenMeta = const VerificationMeta('frozen');
  GeneratedBoolColumn _frozen;
  @override
  GeneratedBoolColumn get frozen => _frozen ??= _constructFrozen();
  GeneratedBoolColumn _constructFrozen() {
    return GeneratedBoolColumn('frozen', $tableName, false,
        defaultValue: Constant(false));
  }

  final VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  GeneratedDateTimeColumn _lastMessageAt;
  @override
  GeneratedDateTimeColumn get lastMessageAt =>
      _lastMessageAt ??= _constructLastMessageAt();
  GeneratedDateTimeColumn _constructLastMessageAt() {
    return GeneratedDateTimeColumn(
      'last_message_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _deletedAtMeta = const VerificationMeta('deletedAt');
  GeneratedDateTimeColumn _deletedAt;
  @override
  GeneratedDateTimeColumn get deletedAt => _deletedAt ??= _constructDeletedAt();
  GeneratedDateTimeColumn _constructDeletedAt() {
    return GeneratedDateTimeColumn(
      'deleted_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _memberCountMeta =
      const VerificationMeta('memberCount');
  GeneratedIntColumn _memberCount;
  @override
  GeneratedIntColumn get memberCount =>
      _memberCount ??= _constructMemberCount();
  GeneratedIntColumn _constructMemberCount() {
    return GeneratedIntColumn(
      'member_count',
      $tableName,
      false,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdByMeta = const VerificationMeta('createdBy');
  GeneratedTextColumn _createdBy;
  @override
  GeneratedTextColumn get createdBy => _createdBy ??= _constructCreatedBy();
  GeneratedTextColumn _constructCreatedBy() {
    return GeneratedTextColumn(
      'created_by',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        cid,
        frozen,
        lastMessageAt,
        createdAt,
        updatedAt,
        deletedAt,
        memberCount,
        extraData,
        createdBy
      ];
  @override
  $_ChannelTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channel';
  @override
  final String actualTableName = 'channel';
  @override
  VerificationContext validateIntegrity(_ChannelCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (d.cid.present) {
      context.handle(_cidMeta, cid.isAcceptableValue(d.cid.value, _cidMeta));
    } else if (isInserting) {
      context.missing(_cidMeta);
    }
    if (d.frozen.present) {
      context.handle(
          _frozenMeta, frozen.isAcceptableValue(d.frozen.value, _frozenMeta));
    }
    if (d.lastMessageAt.present) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableValue(
              d.lastMessageAt.value, _lastMessageAtMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (d.deletedAt.present) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableValue(d.deletedAt.value, _deletedAtMeta));
    }
    if (d.memberCount.present) {
      context.handle(_memberCountMeta,
          memberCount.isAcceptableValue(d.memberCount.value, _memberCountMeta));
    } else if (isInserting) {
      context.missing(_memberCountMeta);
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    if (d.createdBy.present) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableValue(d.createdBy.value, _createdByMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cid};
  @override
  _ChannelData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _ChannelData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_ChannelCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.cid.present) {
      map['cid'] = Variable<String, StringType>(d.cid.value);
    }
    if (d.frozen.present) {
      map['frozen'] = Variable<bool, BoolType>(d.frozen.value);
    }
    if (d.lastMessageAt.present) {
      map['last_message_at'] =
          Variable<DateTime, DateTimeType>(d.lastMessageAt.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.deletedAt.present) {
      map['deleted_at'] = Variable<DateTime, DateTimeType>(d.deletedAt.value);
    }
    if (d.memberCount.present) {
      map['member_count'] = Variable<int, IntType>(d.memberCount.value);
    }
    if (d.extraData.present) {
      final converter = $_ChannelTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    if (d.createdBy.present) {
      map['created_by'] = Variable<String, StringType>(d.createdBy.value);
    }
    return map;
  }

  @override
  $_ChannelTable createAlias(String alias) {
    return $_ChannelTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _UserData extends DataClass implements Insertable<_UserData> {
  final String id;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastActive;
  final bool online;
  final bool banned;
  final Map<String, dynamic> extraData;
  _UserData(
      {@required this.id,
      this.role,
      @required this.createdAt,
      this.updatedAt,
      this.lastActive,
      this.online,
      this.banned,
      this.extraData});
  factory _UserData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return _UserData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      role: stringType.mapFromDatabaseResponse(data['${effectivePrefix}role']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      lastActive: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_active']),
      online:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}online']),
      banned:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}banned']),
      extraData: $_UserTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _UserData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _UserData(
      id: serializer.fromJson<String>(json['id']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastActive: serializer.fromJson<DateTime>(json['lastActive']),
      online: serializer.fromJson<bool>(json['online']),
      banned: serializer.fromJson<bool>(json['banned']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastActive': serializer.toJson<DateTime>(lastActive),
      'online': serializer.toJson<bool>(online),
      'banned': serializer.toJson<bool>(banned),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  @override
  _UserCompanion createCompanion(bool nullToAbsent) {
    return _UserCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      lastActive: lastActive == null && nullToAbsent
          ? const Value.absent()
          : Value(lastActive),
      online:
          online == null && nullToAbsent ? const Value.absent() : Value(online),
      banned:
          banned == null && nullToAbsent ? const Value.absent() : Value(banned),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  _UserData copyWith(
          {String id,
          String role,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime lastActive,
          bool online,
          bool banned,
          Map<String, dynamic> extraData}) =>
      _UserData(
        id: id ?? this.id,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        online: online ?? this.online,
        banned: banned ?? this.banned,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_UserData(')
          ..write('id: $id, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastActive: $lastActive, ')
          ..write('online: $online, ')
          ..write('banned: $banned, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          role.hashCode,
          $mrjc(
              createdAt.hashCode,
              $mrjc(
                  updatedAt.hashCode,
                  $mrjc(
                      lastActive.hashCode,
                      $mrjc(online.hashCode,
                          $mrjc(banned.hashCode, extraData.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _UserData &&
          other.id == this.id &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastActive == this.lastActive &&
          other.online == this.online &&
          other.banned == this.banned &&
          other.extraData == this.extraData);
}

class _UserCompanion extends UpdateCompanion<_UserData> {
  final Value<String> id;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastActive;
  final Value<bool> online;
  final Value<bool> banned;
  final Value<Map<String, dynamic>> extraData;
  const _UserCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _UserCompanion.insert({
    @required String id,
    this.role = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt);
  _UserCompanion copyWith(
      {Value<String> id,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> lastActive,
      Value<bool> online,
      Value<bool> banned,
      Value<Map<String, dynamic>> extraData}) {
    return _UserCompanion(
      id: id ?? this.id,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActive: lastActive ?? this.lastActive,
      online: online ?? this.online,
      banned: banned ?? this.banned,
      extraData: extraData ?? this.extraData,
    );
  }
}

class $_UserTable extends _User with TableInfo<$_UserTable, _UserData> {
  final GeneratedDatabase _db;
  final String _alias;
  $_UserTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _roleMeta = const VerificationMeta('role');
  GeneratedTextColumn _role;
  @override
  GeneratedTextColumn get role => _role ??= _constructRole();
  GeneratedTextColumn _constructRole() {
    return GeneratedTextColumn(
      'role',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _lastActiveMeta = const VerificationMeta('lastActive');
  GeneratedDateTimeColumn _lastActive;
  @override
  GeneratedDateTimeColumn get lastActive =>
      _lastActive ??= _constructLastActive();
  GeneratedDateTimeColumn _constructLastActive() {
    return GeneratedDateTimeColumn(
      'last_active',
      $tableName,
      true,
    );
  }

  final VerificationMeta _onlineMeta = const VerificationMeta('online');
  GeneratedBoolColumn _online;
  @override
  GeneratedBoolColumn get online => _online ??= _constructOnline();
  GeneratedBoolColumn _constructOnline() {
    return GeneratedBoolColumn(
      'online',
      $tableName,
      true,
    );
  }

  final VerificationMeta _bannedMeta = const VerificationMeta('banned');
  GeneratedBoolColumn _banned;
  @override
  GeneratedBoolColumn get banned => _banned ??= _constructBanned();
  GeneratedBoolColumn _constructBanned() {
    return GeneratedBoolColumn(
      'banned',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, role, createdAt, updatedAt, lastActive, online, banned, extraData];
  @override
  $_UserTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'user';
  @override
  final String actualTableName = 'user';
  @override
  VerificationContext validateIntegrity(_UserCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.role.present) {
      context.handle(
          _roleMeta, role.isAcceptableValue(d.role.value, _roleMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.lastActive.present) {
      context.handle(_lastActiveMeta,
          lastActive.isAcceptableValue(d.lastActive.value, _lastActiveMeta));
    }
    if (d.online.present) {
      context.handle(
          _onlineMeta, online.isAcceptableValue(d.online.value, _onlineMeta));
    }
    if (d.banned.present) {
      context.handle(
          _bannedMeta, banned.isAcceptableValue(d.banned.value, _bannedMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _UserData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _UserData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_UserCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.role.present) {
      map['role'] = Variable<String, StringType>(d.role.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.lastActive.present) {
      map['last_active'] = Variable<DateTime, DateTimeType>(d.lastActive.value);
    }
    if (d.online.present) {
      map['online'] = Variable<bool, BoolType>(d.online.value);
    }
    if (d.banned.present) {
      map['banned'] = Variable<bool, BoolType>(d.banned.value);
    }
    if (d.extraData.present) {
      final converter = $_UserTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_UserTable createAlias(String alias) {
    return $_UserTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _MessageData extends DataClass implements Insertable<_MessageData> {
  final String id;
  final String messageText;
  final MessageSendingStatus status;
  final String type;
  final Map<String, int> reactionCounts;
  final Map<String, int> reactionScores;
  final String parentId;
  final int replyCount;
  final bool showInChannel;
  final String command;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String channelId;
  final Map<String, dynamic> extraData;
  _MessageData(
      {@required this.id,
      this.messageText,
      this.status,
      @required this.type,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.replyCount,
      this.showInChannel,
      this.command,
      @required this.createdAt,
      this.updatedAt,
      this.userId,
      this.channelId,
      this.extraData});
  factory _MessageData.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return _MessageData(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      messageText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_text']),
      status: $_MessageTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}status'])),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      reactionCounts: $_MessageTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_counts'])),
      reactionScores: $_MessageTable.$converter2.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_scores'])),
      parentId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      replyCount: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}reply_count']),
      showInChannel: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}show_in_channel']),
      command:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}command']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_id']),
      extraData: $_MessageTable.$converter3.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _MessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _MessageData(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String>(json['messageText']),
      status: serializer.fromJson<MessageSendingStatus>(json['status']),
      type: serializer.fromJson<String>(json['type']),
      reactionCounts:
          serializer.fromJson<Map<String, int>>(json['reactionCounts']),
      reactionScores:
          serializer.fromJson<Map<String, int>>(json['reactionScores']),
      parentId: serializer.fromJson<String>(json['parentId']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      showInChannel: serializer.fromJson<bool>(json['showInChannel']),
      command: serializer.fromJson<String>(json['command']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      userId: serializer.fromJson<String>(json['userId']),
      channelId: serializer.fromJson<String>(json['channelId']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String>(messageText),
      'status': serializer.toJson<MessageSendingStatus>(status),
      'type': serializer.toJson<String>(type),
      'reactionCounts': serializer.toJson<Map<String, int>>(reactionCounts),
      'reactionScores': serializer.toJson<Map<String, int>>(reactionScores),
      'parentId': serializer.toJson<String>(parentId),
      'replyCount': serializer.toJson<int>(replyCount),
      'showInChannel': serializer.toJson<bool>(showInChannel),
      'command': serializer.toJson<String>(command),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'userId': serializer.toJson<String>(userId),
      'channelId': serializer.toJson<String>(channelId),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  @override
  _MessageCompanion createCompanion(bool nullToAbsent) {
    return _MessageCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      messageText: messageText == null && nullToAbsent
          ? const Value.absent()
          : Value(messageText),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      reactionCounts: reactionCounts == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionCounts),
      reactionScores: reactionScores == null && nullToAbsent
          ? const Value.absent()
          : Value(reactionScores),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      replyCount: replyCount == null && nullToAbsent
          ? const Value.absent()
          : Value(replyCount),
      showInChannel: showInChannel == null && nullToAbsent
          ? const Value.absent()
          : Value(showInChannel),
      command: command == null && nullToAbsent
          ? const Value.absent()
          : Value(command),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelId: channelId == null && nullToAbsent
          ? const Value.absent()
          : Value(channelId),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  _MessageData copyWith(
          {String id,
          String messageText,
          MessageSendingStatus status,
          String type,
          Map<String, int> reactionCounts,
          Map<String, int> reactionScores,
          String parentId,
          int replyCount,
          bool showInChannel,
          String command,
          DateTime createdAt,
          DateTime updatedAt,
          String userId,
          String channelId,
          Map<String, dynamic> extraData}) =>
      _MessageData(
        id: id ?? this.id,
        messageText: messageText ?? this.messageText,
        status: status ?? this.status,
        type: type ?? this.type,
        reactionCounts: reactionCounts ?? this.reactionCounts,
        reactionScores: reactionScores ?? this.reactionScores,
        parentId: parentId ?? this.parentId,
        replyCount: replyCount ?? this.replyCount,
        showInChannel: showInChannel ?? this.showInChannel,
        command: command ?? this.command,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
        channelId: channelId ?? this.channelId,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_MessageData(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('status: $status, ')
          ..write('type: $type, ')
          ..write('reactionCounts: $reactionCounts, ')
          ..write('reactionScores: $reactionScores, ')
          ..write('parentId: $parentId, ')
          ..write('replyCount: $replyCount, ')
          ..write('showInChannel: $showInChannel, ')
          ..write('command: $command, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('userId: $userId, ')
          ..write('channelId: $channelId, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          messageText.hashCode,
          $mrjc(
              status.hashCode,
              $mrjc(
                  type.hashCode,
                  $mrjc(
                      reactionCounts.hashCode,
                      $mrjc(
                          reactionScores.hashCode,
                          $mrjc(
                              parentId.hashCode,
                              $mrjc(
                                  replyCount.hashCode,
                                  $mrjc(
                                      showInChannel.hashCode,
                                      $mrjc(
                                          command.hashCode,
                                          $mrjc(
                                              createdAt.hashCode,
                                              $mrjc(
                                                  updatedAt.hashCode,
                                                  $mrjc(
                                                      userId.hashCode,
                                                      $mrjc(
                                                          channelId.hashCode,
                                                          extraData
                                                              .hashCode)))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _MessageData &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.status == this.status &&
          other.type == this.type &&
          other.reactionCounts == this.reactionCounts &&
          other.reactionScores == this.reactionScores &&
          other.parentId == this.parentId &&
          other.replyCount == this.replyCount &&
          other.showInChannel == this.showInChannel &&
          other.command == this.command &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.userId == this.userId &&
          other.channelId == this.channelId &&
          other.extraData == this.extraData);
}

class _MessageCompanion extends UpdateCompanion<_MessageData> {
  final Value<String> id;
  final Value<String> messageText;
  final Value<MessageSendingStatus> status;
  final Value<String> type;
  final Value<Map<String, int>> reactionCounts;
  final Value<Map<String, int>> reactionScores;
  final Value<String> parentId;
  final Value<int> replyCount;
  final Value<bool> showInChannel;
  final Value<String> command;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String> userId;
  final Value<String> channelId;
  final Value<Map<String, dynamic>> extraData;
  const _MessageCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.command = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _MessageCompanion.insert({
    @required String id,
    this.messageText = const Value.absent(),
    this.status = const Value.absent(),
    @required String type,
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.command = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelId = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        createdAt = Value(createdAt);
  _MessageCompanion copyWith(
      {Value<String> id,
      Value<String> messageText,
      Value<MessageSendingStatus> status,
      Value<String> type,
      Value<Map<String, int>> reactionCounts,
      Value<Map<String, int>> reactionScores,
      Value<String> parentId,
      Value<int> replyCount,
      Value<bool> showInChannel,
      Value<String> command,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String> userId,
      Value<String> channelId,
      Value<Map<String, dynamic>> extraData}) {
    return _MessageCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      status: status ?? this.status,
      type: type ?? this.type,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionScores: reactionScores ?? this.reactionScores,
      parentId: parentId ?? this.parentId,
      replyCount: replyCount ?? this.replyCount,
      showInChannel: showInChannel ?? this.showInChannel,
      command: command ?? this.command,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      channelId: channelId ?? this.channelId,
      extraData: extraData ?? this.extraData,
    );
  }
}

class $_MessageTable extends _Message
    with TableInfo<$_MessageTable, _MessageData> {
  final GeneratedDatabase _db;
  final String _alias;
  $_MessageTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedTextColumn _id;
  @override
  GeneratedTextColumn get id => _id ??= _constructId();
  GeneratedTextColumn _constructId() {
    return GeneratedTextColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _messageTextMeta =
      const VerificationMeta('messageText');
  GeneratedTextColumn _messageText;
  @override
  GeneratedTextColumn get messageText =>
      _messageText ??= _constructMessageText();
  GeneratedTextColumn _constructMessageText() {
    return GeneratedTextColumn(
      'message_text',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedTextColumn _status;
  @override
  GeneratedTextColumn get status => _status ??= _constructStatus();
  GeneratedTextColumn _constructStatus() {
    return GeneratedTextColumn(
      'status',
      $tableName,
      true,
    );
  }

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  GeneratedTextColumn _type;
  @override
  GeneratedTextColumn get type => _type ??= _constructType();
  GeneratedTextColumn _constructType() {
    return GeneratedTextColumn(
      'type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _reactionCountsMeta =
      const VerificationMeta('reactionCounts');
  GeneratedTextColumn _reactionCounts;
  @override
  GeneratedTextColumn get reactionCounts =>
      _reactionCounts ??= _constructReactionCounts();
  GeneratedTextColumn _constructReactionCounts() {
    return GeneratedTextColumn(
      'reaction_counts',
      $tableName,
      true,
    );
  }

  final VerificationMeta _reactionScoresMeta =
      const VerificationMeta('reactionScores');
  GeneratedTextColumn _reactionScores;
  @override
  GeneratedTextColumn get reactionScores =>
      _reactionScores ??= _constructReactionScores();
  GeneratedTextColumn _constructReactionScores() {
    return GeneratedTextColumn(
      'reaction_scores',
      $tableName,
      true,
    );
  }

  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  GeneratedTextColumn _parentId;
  @override
  GeneratedTextColumn get parentId => _parentId ??= _constructParentId();
  GeneratedTextColumn _constructParentId() {
    return GeneratedTextColumn(
      'parent_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _replyCountMeta = const VerificationMeta('replyCount');
  GeneratedIntColumn _replyCount;
  @override
  GeneratedIntColumn get replyCount => _replyCount ??= _constructReplyCount();
  GeneratedIntColumn _constructReplyCount() {
    return GeneratedIntColumn(
      'reply_count',
      $tableName,
      true,
    );
  }

  final VerificationMeta _showInChannelMeta =
      const VerificationMeta('showInChannel');
  GeneratedBoolColumn _showInChannel;
  @override
  GeneratedBoolColumn get showInChannel =>
      _showInChannel ??= _constructShowInChannel();
  GeneratedBoolColumn _constructShowInChannel() {
    return GeneratedBoolColumn(
      'show_in_channel',
      $tableName,
      true,
    );
  }

  final VerificationMeta _commandMeta = const VerificationMeta('command');
  GeneratedTextColumn _command;
  @override
  GeneratedTextColumn get command => _command ??= _constructCommand();
  GeneratedTextColumn _constructCommand() {
    return GeneratedTextColumn(
      'command',
      $tableName,
      true,
    );
  }

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  GeneratedDateTimeColumn _createdAt;
  @override
  GeneratedDateTimeColumn get createdAt => _createdAt ??= _constructCreatedAt();
  GeneratedDateTimeColumn _constructCreatedAt() {
    return GeneratedDateTimeColumn(
      'created_at',
      $tableName,
      false,
    );
  }

  final VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  GeneratedDateTimeColumn _updatedAt;
  @override
  GeneratedDateTimeColumn get updatedAt => _updatedAt ??= _constructUpdatedAt();
  GeneratedDateTimeColumn _constructUpdatedAt() {
    return GeneratedDateTimeColumn(
      'updated_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _channelIdMeta = const VerificationMeta('channelId');
  GeneratedTextColumn _channelId;
  @override
  GeneratedTextColumn get channelId => _channelId ??= _constructChannelId();
  GeneratedTextColumn _constructChannelId() {
    return GeneratedTextColumn(
      'channel_id',
      $tableName,
      true,
    );
  }

  final VerificationMeta _extraDataMeta = const VerificationMeta('extraData');
  GeneratedTextColumn _extraData;
  @override
  GeneratedTextColumn get extraData => _extraData ??= _constructExtraData();
  GeneratedTextColumn _constructExtraData() {
    return GeneratedTextColumn(
      'extra_data',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        messageText,
        status,
        type,
        reactionCounts,
        reactionScores,
        parentId,
        replyCount,
        showInChannel,
        command,
        createdAt,
        updatedAt,
        userId,
        channelId,
        extraData
      ];
  @override
  $_MessageTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'message';
  @override
  final String actualTableName = 'message';
  @override
  VerificationContext validateIntegrity(_MessageCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (d.messageText.present) {
      context.handle(_messageTextMeta,
          messageText.isAcceptableValue(d.messageText.value, _messageTextMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    context.handle(_reactionCountsMeta, const VerificationResult.success());
    context.handle(_reactionScoresMeta, const VerificationResult.success());
    if (d.parentId.present) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableValue(d.parentId.value, _parentIdMeta));
    }
    if (d.replyCount.present) {
      context.handle(_replyCountMeta,
          replyCount.isAcceptableValue(d.replyCount.value, _replyCountMeta));
    }
    if (d.showInChannel.present) {
      context.handle(
          _showInChannelMeta,
          showInChannel.isAcceptableValue(
              d.showInChannel.value, _showInChannelMeta));
    }
    if (d.command.present) {
      context.handle(_commandMeta,
          command.isAcceptableValue(d.command.value, _commandMeta));
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (d.updatedAt.present) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableValue(d.updatedAt.value, _updatedAtMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    }
    if (d.channelId.present) {
      context.handle(_channelIdMeta,
          channelId.isAcceptableValue(d.channelId.value, _channelIdMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _MessageData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _MessageData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_MessageCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.messageText.present) {
      map['message_text'] = Variable<String, StringType>(d.messageText.value);
    }
    if (d.status.present) {
      final converter = $_MessageTable.$converter0;
      map['status'] =
          Variable<String, StringType>(converter.mapToSql(d.status.value));
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.reactionCounts.present) {
      final converter = $_MessageTable.$converter1;
      map['reaction_counts'] = Variable<String, StringType>(
          converter.mapToSql(d.reactionCounts.value));
    }
    if (d.reactionScores.present) {
      final converter = $_MessageTable.$converter2;
      map['reaction_scores'] = Variable<String, StringType>(
          converter.mapToSql(d.reactionScores.value));
    }
    if (d.parentId.present) {
      map['parent_id'] = Variable<String, StringType>(d.parentId.value);
    }
    if (d.replyCount.present) {
      map['reply_count'] = Variable<int, IntType>(d.replyCount.value);
    }
    if (d.showInChannel.present) {
      map['show_in_channel'] = Variable<bool, BoolType>(d.showInChannel.value);
    }
    if (d.command.present) {
      map['command'] = Variable<String, StringType>(d.command.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.channelId.present) {
      map['channel_id'] = Variable<String, StringType>(d.channelId.value);
    }
    if (d.extraData.present) {
      final converter = $_MessageTable.$converter3;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_MessageTable createAlias(String alias) {
    return $_MessageTable(_db, alias);
  }

  static TypeConverter<MessageSendingStatus, String> $converter0 =
      _MessageSendingStatusConverter();
  static TypeConverter<Map<String, int>, String> $converter1 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, int>, String> $converter2 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, dynamic>, String> $converter3 =
      _ExtraDataConverter();
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $_ChannelTable _channel;
  $_ChannelTable get channel => _channel ??= $_ChannelTable(this);
  $_UserTable _user;
  $_UserTable get user => _user ??= $_UserTable(this);
  $_MessageTable _message;
  $_MessageTable get message => _message ??= $_MessageTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [channel, user, message];
}
