// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class _Channel extends DataClass implements Insertable<_Channel> {
  final String id;
  final String type;
  final String cid;
  final String config;
  final bool frozen;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final int memberCount;
  final Map<String, dynamic> extraData;
  final String createdBy;
  _Channel(
      {@required this.id,
      @required this.type,
      @required this.cid,
      @required this.config,
      @required this.frozen,
      this.lastMessageAt,
      @required this.createdAt,
      @required this.updatedAt,
      this.deletedAt,
      this.memberCount,
      this.extraData,
      this.createdBy});
  factory _Channel.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return _Channel(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      cid: stringType.mapFromDatabaseResponse(data['${effectivePrefix}cid']),
      config:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}config']),
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
      extraData: $_ChannelsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
      createdBy: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_by']),
    );
  }
  factory _Channel.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Channel(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      cid: serializer.fromJson<String>(json['cid']),
      config: serializer.fromJson<String>(json['config']),
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
      'config': serializer.toJson<String>(config),
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
  _ChannelsCompanion createCompanion(bool nullToAbsent) {
    return _ChannelsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      config:
          config == null && nullToAbsent ? const Value.absent() : Value(config),
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

  _Channel copyWith(
          {String id,
          String type,
          String cid,
          String config,
          bool frozen,
          DateTime lastMessageAt,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime deletedAt,
          int memberCount,
          Map<String, dynamic> extraData,
          String createdBy}) =>
      _Channel(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
        config: config ?? this.config,
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
    return (StringBuffer('_Channel(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('cid: $cid, ')
          ..write('config: $config, ')
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
                  config.hashCode,
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
                                              createdBy.hashCode))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Channel &&
          other.id == this.id &&
          other.type == this.type &&
          other.cid == this.cid &&
          other.config == this.config &&
          other.frozen == this.frozen &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.memberCount == this.memberCount &&
          other.extraData == this.extraData &&
          other.createdBy == this.createdBy);
}

class _ChannelsCompanion extends UpdateCompanion<_Channel> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> cid;
  final Value<String> config;
  final Value<bool> frozen;
  final Value<DateTime> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> deletedAt;
  final Value<int> memberCount;
  final Value<Map<String, dynamic>> extraData;
  final Value<String> createdBy;
  const _ChannelsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.cid = const Value.absent(),
    this.config = const Value.absent(),
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  _ChannelsCompanion.insert({
    @required String id,
    @required String type,
    @required String cid,
    @required String config,
    this.frozen = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    @required DateTime createdAt,
    @required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.memberCount = const Value.absent(),
    this.extraData = const Value.absent(),
    this.createdBy = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        cid = Value(cid),
        config = Value(config),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  _ChannelsCompanion copyWith(
      {Value<String> id,
      Value<String> type,
      Value<String> cid,
      Value<String> config,
      Value<bool> frozen,
      Value<DateTime> lastMessageAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> deletedAt,
      Value<int> memberCount,
      Value<Map<String, dynamic>> extraData,
      Value<String> createdBy}) {
    return _ChannelsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      cid: cid ?? this.cid,
      config: config ?? this.config,
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

class $_ChannelsTable extends _Channels
    with TableInfo<$_ChannelsTable, _Channel> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ChannelsTable(this._db, [this._alias]);
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

  final VerificationMeta _configMeta = const VerificationMeta('config');
  GeneratedTextColumn _config;
  @override
  GeneratedTextColumn get config => _config ??= _constructConfig();
  GeneratedTextColumn _constructConfig() {
    return GeneratedTextColumn(
      'config',
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
        config,
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
  $_ChannelsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channels';
  @override
  final String actualTableName = 'channels';
  @override
  VerificationContext validateIntegrity(_ChannelsCompanion d,
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
    if (d.config.present) {
      context.handle(
          _configMeta, config.isAcceptableValue(d.config.value, _configMeta));
    } else if (isInserting) {
      context.missing(_configMeta);
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
  _Channel map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Channel.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_ChannelsCompanion d) {
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
    if (d.config.present) {
      map['config'] = Variable<String, StringType>(d.config.value);
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
      final converter = $_ChannelsTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    if (d.createdBy.present) {
      map['created_by'] = Variable<String, StringType>(d.createdBy.value);
    }
    return map;
  }

  @override
  $_ChannelsTable createAlias(String alias) {
    return $_ChannelsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _User extends DataClass implements Insertable<_User> {
  final String id;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastActive;
  final bool online;
  final bool banned;
  final Map<String, dynamic> extraData;
  _User(
      {@required this.id,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.lastActive,
      this.online,
      this.banned,
      this.extraData});
  factory _User.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return _User(
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
      extraData: $_UsersTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _User.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _User(
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
  _UsersCompanion createCompanion(bool nullToAbsent) {
    return _UsersCompanion(
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

  _User copyWith(
          {String id,
          String role,
          DateTime createdAt,
          DateTime updatedAt,
          DateTime lastActive,
          bool online,
          bool banned,
          Map<String, dynamic> extraData}) =>
      _User(
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
    return (StringBuffer('_User(')
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
      (other is _User &&
          other.id == this.id &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastActive == this.lastActive &&
          other.online == this.online &&
          other.banned == this.banned &&
          other.extraData == this.extraData);
}

class _UsersCompanion extends UpdateCompanion<_User> {
  final Value<String> id;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> lastActive;
  final Value<bool> online;
  final Value<bool> banned;
  final Value<Map<String, dynamic>> extraData;
  const _UsersCompanion({
    this.id = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _UsersCompanion.insert({
    @required String id,
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  }) : id = Value(id);
  _UsersCompanion copyWith(
      {Value<String> id,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> lastActive,
      Value<bool> online,
      Value<bool> banned,
      Value<Map<String, dynamic>> extraData}) {
    return _UsersCompanion(
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

class $_UsersTable extends _Users with TableInfo<$_UsersTable, _User> {
  final GeneratedDatabase _db;
  final String _alias;
  $_UsersTable(this._db, [this._alias]);
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
      true,
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
  $_UsersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'users';
  @override
  final String actualTableName = 'users';
  @override
  VerificationContext validateIntegrity(_UsersCompanion d,
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
  _User map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _User.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_UsersCompanion d) {
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
      final converter = $_UsersTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_UsersTable createAlias(String alias) {
    return $_UsersTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

class _Message extends DataClass implements Insertable<_Message> {
  final String id;
  final String messageText;
  final String attachmentJson;
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
  final String channelCid;
  final Map<String, dynamic> extraData;
  _Message(
      {@required this.id,
      this.messageText,
      this.attachmentJson,
      this.status,
      this.type,
      this.reactionCounts,
      this.reactionScores,
      this.parentId,
      this.replyCount,
      this.showInChannel,
      this.command,
      @required this.createdAt,
      this.updatedAt,
      this.userId,
      this.channelCid,
      this.extraData});
  factory _Message.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final intType = db.typeSystem.forDartType<int>();
    final boolType = db.typeSystem.forDartType<bool>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    return _Message(
      id: stringType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      messageText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_text']),
      attachmentJson: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}attachment_json']),
      status: $_MessagesTable.$converter0.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}status'])),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      reactionCounts: $_MessagesTable.$converter1.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}reaction_counts'])),
      reactionScores: $_MessagesTable.$converter2.mapToDart(stringType
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
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
      extraData: $_MessagesTable.$converter3.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Message(
      id: serializer.fromJson<String>(json['id']),
      messageText: serializer.fromJson<String>(json['messageText']),
      attachmentJson: serializer.fromJson<String>(json['attachmentJson']),
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
      channelCid: serializer.fromJson<String>(json['channelCid']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageText': serializer.toJson<String>(messageText),
      'attachmentJson': serializer.toJson<String>(attachmentJson),
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
      'channelCid': serializer.toJson<String>(channelCid),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  @override
  _MessagesCompanion createCompanion(bool nullToAbsent) {
    return _MessagesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      messageText: messageText == null && nullToAbsent
          ? const Value.absent()
          : Value(messageText),
      attachmentJson: attachmentJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentJson),
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
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  _Message copyWith(
          {String id,
          String messageText,
          String attachmentJson,
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
          String channelCid,
          Map<String, dynamic> extraData}) =>
      _Message(
        id: id ?? this.id,
        messageText: messageText ?? this.messageText,
        attachmentJson: attachmentJson ?? this.attachmentJson,
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
        channelCid: channelCid ?? this.channelCid,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_Message(')
          ..write('id: $id, ')
          ..write('messageText: $messageText, ')
          ..write('attachmentJson: $attachmentJson, ')
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
          ..write('channelCid: $channelCid, ')
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
              attachmentJson.hashCode,
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
                                                              channelCid
                                                                  .hashCode,
                                                              extraData
                                                                  .hashCode))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Message &&
          other.id == this.id &&
          other.messageText == this.messageText &&
          other.attachmentJson == this.attachmentJson &&
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
          other.channelCid == this.channelCid &&
          other.extraData == this.extraData);
}

class _MessagesCompanion extends UpdateCompanion<_Message> {
  final Value<String> id;
  final Value<String> messageText;
  final Value<String> attachmentJson;
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
  final Value<String> channelCid;
  final Value<Map<String, dynamic>> extraData;
  const _MessagesCompanion({
    this.id = const Value.absent(),
    this.messageText = const Value.absent(),
    this.attachmentJson = const Value.absent(),
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
    this.channelCid = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _MessagesCompanion.insert({
    @required String id,
    this.messageText = const Value.absent(),
    this.attachmentJson = const Value.absent(),
    this.status = const Value.absent(),
    this.type = const Value.absent(),
    this.reactionCounts = const Value.absent(),
    this.reactionScores = const Value.absent(),
    this.parentId = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.showInChannel = const Value.absent(),
    this.command = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt);
  _MessagesCompanion copyWith(
      {Value<String> id,
      Value<String> messageText,
      Value<String> attachmentJson,
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
      Value<String> channelCid,
      Value<Map<String, dynamic>> extraData}) {
    return _MessagesCompanion(
      id: id ?? this.id,
      messageText: messageText ?? this.messageText,
      attachmentJson: attachmentJson ?? this.attachmentJson,
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
      channelCid: channelCid ?? this.channelCid,
      extraData: extraData ?? this.extraData,
    );
  }
}

class $_MessagesTable extends _Messages
    with TableInfo<$_MessagesTable, _Message> {
  final GeneratedDatabase _db;
  final String _alias;
  $_MessagesTable(this._db, [this._alias]);
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

  final VerificationMeta _attachmentJsonMeta =
      const VerificationMeta('attachmentJson');
  GeneratedTextColumn _attachmentJson;
  @override
  GeneratedTextColumn get attachmentJson =>
      _attachmentJson ??= _constructAttachmentJson();
  GeneratedTextColumn _constructAttachmentJson() {
    return GeneratedTextColumn(
      'attachment_json',
      $tableName,
      true,
    );
  }

  final VerificationMeta _statusMeta = const VerificationMeta('status');
  GeneratedIntColumn _status;
  @override
  GeneratedIntColumn get status => _status ??= _constructStatus();
  GeneratedIntColumn _constructStatus() {
    return GeneratedIntColumn(
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
      true,
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

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
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
        attachmentJson,
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
        channelCid,
        extraData
      ];
  @override
  $_MessagesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'messages';
  @override
  final String actualTableName = 'messages';
  @override
  VerificationContext validateIntegrity(_MessagesCompanion d,
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
    if (d.attachmentJson.present) {
      context.handle(
          _attachmentJsonMeta,
          attachmentJson.isAcceptableValue(
              d.attachmentJson.value, _attachmentJsonMeta));
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
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
    if (d.channelCid.present) {
      context.handle(_channelCidMeta,
          channelCid.isAcceptableValue(d.channelCid.value, _channelCidMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  _Message map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Message.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_MessagesCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<String, StringType>(d.id.value);
    }
    if (d.messageText.present) {
      map['message_text'] = Variable<String, StringType>(d.messageText.value);
    }
    if (d.attachmentJson.present) {
      map['attachment_json'] =
          Variable<String, StringType>(d.attachmentJson.value);
    }
    if (d.status.present) {
      final converter = $_MessagesTable.$converter0;
      map['status'] =
          Variable<int, IntType>(converter.mapToSql(d.status.value));
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.reactionCounts.present) {
      final converter = $_MessagesTable.$converter1;
      map['reaction_counts'] = Variable<String, StringType>(
          converter.mapToSql(d.reactionCounts.value));
    }
    if (d.reactionScores.present) {
      final converter = $_MessagesTable.$converter2;
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
    if (d.channelCid.present) {
      map['channel_cid'] = Variable<String, StringType>(d.channelCid.value);
    }
    if (d.extraData.present) {
      final converter = $_MessagesTable.$converter3;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_MessagesTable createAlias(String alias) {
    return $_MessagesTable(_db, alias);
  }

  static TypeConverter<MessageSendingStatus, int> $converter0 =
      _MessageSendingStatusConverter();
  static TypeConverter<Map<String, int>, String> $converter1 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, int>, String> $converter2 =
      _ExtraDataConverter<int>();
  static TypeConverter<Map<String, dynamic>, String> $converter3 =
      _ExtraDataConverter();
}

class _Read extends DataClass implements Insertable<_Read> {
  final DateTime lastRead;
  final String userId;
  final String channelCid;
  _Read(
      {@required this.lastRead,
      @required this.userId,
      @required this.channelCid});
  factory _Read.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    return _Read(
      lastRead: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}last_read']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
    );
  }
  factory _Read.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Read(
      lastRead: serializer.fromJson<DateTime>(json['lastRead']),
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lastRead': serializer.toJson<DateTime>(lastRead),
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
    };
  }

  @override
  _ReadsCompanion createCompanion(bool nullToAbsent) {
    return _ReadsCompanion(
      lastRead: lastRead == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRead),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
    );
  }

  _Read copyWith({DateTime lastRead, String userId, String channelCid}) =>
      _Read(
        lastRead: lastRead ?? this.lastRead,
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
      );
  @override
  String toString() {
    return (StringBuffer('_Read(')
          ..write('lastRead: $lastRead, ')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf(
      $mrjc(lastRead.hashCode, $mrjc(userId.hashCode, channelCid.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Read &&
          other.lastRead == this.lastRead &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid);
}

class _ReadsCompanion extends UpdateCompanion<_Read> {
  final Value<DateTime> lastRead;
  final Value<String> userId;
  final Value<String> channelCid;
  const _ReadsCompanion({
    this.lastRead = const Value.absent(),
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
  });
  _ReadsCompanion.insert({
    @required DateTime lastRead,
    @required String userId,
    @required String channelCid,
  })  : lastRead = Value(lastRead),
        userId = Value(userId),
        channelCid = Value(channelCid);
  _ReadsCompanion copyWith(
      {Value<DateTime> lastRead,
      Value<String> userId,
      Value<String> channelCid}) {
    return _ReadsCompanion(
      lastRead: lastRead ?? this.lastRead,
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
    );
  }
}

class $_ReadsTable extends _Reads with TableInfo<$_ReadsTable, _Read> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ReadsTable(this._db, [this._alias]);
  final VerificationMeta _lastReadMeta = const VerificationMeta('lastRead');
  GeneratedDateTimeColumn _lastRead;
  @override
  GeneratedDateTimeColumn get lastRead => _lastRead ??= _constructLastRead();
  GeneratedDateTimeColumn _constructLastRead() {
    return GeneratedDateTimeColumn(
      'last_read',
      $tableName,
      false,
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
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [lastRead, userId, channelCid];
  @override
  $_ReadsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reads';
  @override
  final String actualTableName = 'reads';
  @override
  VerificationContext validateIntegrity(_ReadsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.lastRead.present) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableValue(d.lastRead.value, _lastReadMeta));
    } else if (isInserting) {
      context.missing(_lastReadMeta);
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.channelCid.present) {
      context.handle(_channelCidMeta,
          channelCid.isAcceptableValue(d.channelCid.value, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  _Read map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Read.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_ReadsCompanion d) {
    final map = <String, Variable>{};
    if (d.lastRead.present) {
      map['last_read'] = Variable<DateTime, DateTimeType>(d.lastRead.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.channelCid.present) {
      map['channel_cid'] = Variable<String, StringType>(d.channelCid.value);
    }
    return map;
  }

  @override
  $_ReadsTable createAlias(String alias) {
    return $_ReadsTable(_db, alias);
  }
}

class _Member extends DataClass implements Insertable<_Member> {
  final String userId;
  final String channelCid;
  final String role;
  final DateTime inviteAcceptedAt;
  final DateTime inviteRejectedAt;
  final bool invited;
  final bool isModerator;
  final DateTime createdAt;
  final DateTime updatedAt;
  _Member(
      {@required this.userId,
      @required this.channelCid,
      this.role,
      this.inviteAcceptedAt,
      this.inviteRejectedAt,
      this.invited,
      this.isModerator,
      @required this.createdAt,
      this.updatedAt});
  factory _Member.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return _Member(
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
      role: stringType.mapFromDatabaseResponse(data['${effectivePrefix}role']),
      inviteAcceptedAt: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}invite_accepted_at']),
      inviteRejectedAt: dateTimeType.mapFromDatabaseResponse(
          data['${effectivePrefix}invite_rejected_at']),
      invited:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}invited']),
      isModerator: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_moderator']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      updatedAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}updated_at']),
    );
  }
  factory _Member.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Member(
      userId: serializer.fromJson<String>(json['userId']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
      role: serializer.fromJson<String>(json['role']),
      inviteAcceptedAt: serializer.fromJson<DateTime>(json['inviteAcceptedAt']),
      inviteRejectedAt: serializer.fromJson<DateTime>(json['inviteRejectedAt']),
      invited: serializer.fromJson<bool>(json['invited']),
      isModerator: serializer.fromJson<bool>(json['isModerator']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'channelCid': serializer.toJson<String>(channelCid),
      'role': serializer.toJson<String>(role),
      'inviteAcceptedAt': serializer.toJson<DateTime>(inviteAcceptedAt),
      'inviteRejectedAt': serializer.toJson<DateTime>(inviteRejectedAt),
      'invited': serializer.toJson<bool>(invited),
      'isModerator': serializer.toJson<bool>(isModerator),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  @override
  _MembersCompanion createCompanion(bool nullToAbsent) {
    return _MembersCompanion(
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
      role: role == null && nullToAbsent ? const Value.absent() : Value(role),
      inviteAcceptedAt: inviteAcceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteAcceptedAt),
      inviteRejectedAt: inviteRejectedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inviteRejectedAt),
      invited: invited == null && nullToAbsent
          ? const Value.absent()
          : Value(invited),
      isModerator: isModerator == null && nullToAbsent
          ? const Value.absent()
          : Value(isModerator),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  _Member copyWith(
          {String userId,
          String channelCid,
          String role,
          DateTime inviteAcceptedAt,
          DateTime inviteRejectedAt,
          bool invited,
          bool isModerator,
          DateTime createdAt,
          DateTime updatedAt}) =>
      _Member(
        userId: userId ?? this.userId,
        channelCid: channelCid ?? this.channelCid,
        role: role ?? this.role,
        inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
        inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
        invited: invited ?? this.invited,
        isModerator: isModerator ?? this.isModerator,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  @override
  String toString() {
    return (StringBuffer('_Member(')
          ..write('userId: $userId, ')
          ..write('channelCid: $channelCid, ')
          ..write('role: $role, ')
          ..write('inviteAcceptedAt: $inviteAcceptedAt, ')
          ..write('inviteRejectedAt: $inviteRejectedAt, ')
          ..write('invited: $invited, ')
          ..write('isModerator: $isModerator, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      userId.hashCode,
      $mrjc(
          channelCid.hashCode,
          $mrjc(
              role.hashCode,
              $mrjc(
                  inviteAcceptedAt.hashCode,
                  $mrjc(
                      inviteRejectedAt.hashCode,
                      $mrjc(
                          invited.hashCode,
                          $mrjc(
                              isModerator.hashCode,
                              $mrjc(createdAt.hashCode,
                                  updatedAt.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Member &&
          other.userId == this.userId &&
          other.channelCid == this.channelCid &&
          other.role == this.role &&
          other.inviteAcceptedAt == this.inviteAcceptedAt &&
          other.inviteRejectedAt == this.inviteRejectedAt &&
          other.invited == this.invited &&
          other.isModerator == this.isModerator &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class _MembersCompanion extends UpdateCompanion<_Member> {
  final Value<String> userId;
  final Value<String> channelCid;
  final Value<String> role;
  final Value<DateTime> inviteAcceptedAt;
  final Value<DateTime> inviteRejectedAt;
  final Value<bool> invited;
  final Value<bool> isModerator;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const _MembersCompanion({
    this.userId = const Value.absent(),
    this.channelCid = const Value.absent(),
    this.role = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.isModerator = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  _MembersCompanion.insert({
    @required String userId,
    @required String channelCid,
    this.role = const Value.absent(),
    this.inviteAcceptedAt = const Value.absent(),
    this.inviteRejectedAt = const Value.absent(),
    this.invited = const Value.absent(),
    this.isModerator = const Value.absent(),
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
  })  : userId = Value(userId),
        channelCid = Value(channelCid),
        createdAt = Value(createdAt);
  _MembersCompanion copyWith(
      {Value<String> userId,
      Value<String> channelCid,
      Value<String> role,
      Value<DateTime> inviteAcceptedAt,
      Value<DateTime> inviteRejectedAt,
      Value<bool> invited,
      Value<bool> isModerator,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt}) {
    return _MembersCompanion(
      userId: userId ?? this.userId,
      channelCid: channelCid ?? this.channelCid,
      role: role ?? this.role,
      inviteAcceptedAt: inviteAcceptedAt ?? this.inviteAcceptedAt,
      inviteRejectedAt: inviteRejectedAt ?? this.inviteRejectedAt,
      invited: invited ?? this.invited,
      isModerator: isModerator ?? this.isModerator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class $_MembersTable extends _Members with TableInfo<$_MembersTable, _Member> {
  final GeneratedDatabase _db;
  final String _alias;
  $_MembersTable(this._db, [this._alias]);
  final VerificationMeta _userIdMeta = const VerificationMeta('userId');
  GeneratedTextColumn _userId;
  @override
  GeneratedTextColumn get userId => _userId ??= _constructUserId();
  GeneratedTextColumn _constructUserId() {
    return GeneratedTextColumn(
      'user_id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
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

  final VerificationMeta _inviteAcceptedAtMeta =
      const VerificationMeta('inviteAcceptedAt');
  GeneratedDateTimeColumn _inviteAcceptedAt;
  @override
  GeneratedDateTimeColumn get inviteAcceptedAt =>
      _inviteAcceptedAt ??= _constructInviteAcceptedAt();
  GeneratedDateTimeColumn _constructInviteAcceptedAt() {
    return GeneratedDateTimeColumn(
      'invite_accepted_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _inviteRejectedAtMeta =
      const VerificationMeta('inviteRejectedAt');
  GeneratedDateTimeColumn _inviteRejectedAt;
  @override
  GeneratedDateTimeColumn get inviteRejectedAt =>
      _inviteRejectedAt ??= _constructInviteRejectedAt();
  GeneratedDateTimeColumn _constructInviteRejectedAt() {
    return GeneratedDateTimeColumn(
      'invite_rejected_at',
      $tableName,
      true,
    );
  }

  final VerificationMeta _invitedMeta = const VerificationMeta('invited');
  GeneratedBoolColumn _invited;
  @override
  GeneratedBoolColumn get invited => _invited ??= _constructInvited();
  GeneratedBoolColumn _constructInvited() {
    return GeneratedBoolColumn(
      'invited',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isModeratorMeta =
      const VerificationMeta('isModerator');
  GeneratedBoolColumn _isModerator;
  @override
  GeneratedBoolColumn get isModerator =>
      _isModerator ??= _constructIsModerator();
  GeneratedBoolColumn _constructIsModerator() {
    return GeneratedBoolColumn(
      'is_moderator',
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

  @override
  List<GeneratedColumn> get $columns => [
        userId,
        channelCid,
        role,
        inviteAcceptedAt,
        inviteRejectedAt,
        invited,
        isModerator,
        createdAt,
        updatedAt
      ];
  @override
  $_MembersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'members';
  @override
  final String actualTableName = 'members';
  @override
  VerificationContext validateIntegrity(_MembersCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (d.channelCid.present) {
      context.handle(_channelCidMeta,
          channelCid.isAcceptableValue(d.channelCid.value, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    if (d.role.present) {
      context.handle(
          _roleMeta, role.isAcceptableValue(d.role.value, _roleMeta));
    }
    if (d.inviteAcceptedAt.present) {
      context.handle(
          _inviteAcceptedAtMeta,
          inviteAcceptedAt.isAcceptableValue(
              d.inviteAcceptedAt.value, _inviteAcceptedAtMeta));
    }
    if (d.inviteRejectedAt.present) {
      context.handle(
          _inviteRejectedAtMeta,
          inviteRejectedAt.isAcceptableValue(
              d.inviteRejectedAt.value, _inviteRejectedAtMeta));
    }
    if (d.invited.present) {
      context.handle(_invitedMeta,
          invited.isAcceptableValue(d.invited.value, _invitedMeta));
    }
    if (d.isModerator.present) {
      context.handle(_isModeratorMeta,
          isModerator.isAcceptableValue(d.isModerator.value, _isModeratorMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, channelCid};
  @override
  _Member map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Member.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_MembersCompanion d) {
    final map = <String, Variable>{};
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.channelCid.present) {
      map['channel_cid'] = Variable<String, StringType>(d.channelCid.value);
    }
    if (d.role.present) {
      map['role'] = Variable<String, StringType>(d.role.value);
    }
    if (d.inviteAcceptedAt.present) {
      map['invite_accepted_at'] =
          Variable<DateTime, DateTimeType>(d.inviteAcceptedAt.value);
    }
    if (d.inviteRejectedAt.present) {
      map['invite_rejected_at'] =
          Variable<DateTime, DateTimeType>(d.inviteRejectedAt.value);
    }
    if (d.invited.present) {
      map['invited'] = Variable<bool, BoolType>(d.invited.value);
    }
    if (d.isModerator.present) {
      map['is_moderator'] = Variable<bool, BoolType>(d.isModerator.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.updatedAt.present) {
      map['updated_at'] = Variable<DateTime, DateTimeType>(d.updatedAt.value);
    }
    return map;
  }

  @override
  $_MembersTable createAlias(String alias) {
    return $_MembersTable(_db, alias);
  }
}

class ChannelQuery extends DataClass implements Insertable<ChannelQuery> {
  final String queryHash;
  final String channelCid;
  ChannelQuery({@required this.queryHash, @required this.channelCid});
  factory ChannelQuery.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return ChannelQuery(
      queryHash: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}query_hash']),
      channelCid: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}channel_cid']),
    );
  }
  factory ChannelQuery.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return ChannelQuery(
      queryHash: serializer.fromJson<String>(json['queryHash']),
      channelCid: serializer.fromJson<String>(json['channelCid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queryHash': serializer.toJson<String>(queryHash),
      'channelCid': serializer.toJson<String>(channelCid),
    };
  }

  @override
  _ChannelQueriesCompanion createCompanion(bool nullToAbsent) {
    return _ChannelQueriesCompanion(
      queryHash: queryHash == null && nullToAbsent
          ? const Value.absent()
          : Value(queryHash),
      channelCid: channelCid == null && nullToAbsent
          ? const Value.absent()
          : Value(channelCid),
    );
  }

  ChannelQuery copyWith({String queryHash, String channelCid}) => ChannelQuery(
        queryHash: queryHash ?? this.queryHash,
        channelCid: channelCid ?? this.channelCid,
      );
  @override
  String toString() {
    return (StringBuffer('ChannelQuery(')
          ..write('queryHash: $queryHash, ')
          ..write('channelCid: $channelCid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(queryHash.hashCode, channelCid.hashCode));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is ChannelQuery &&
          other.queryHash == this.queryHash &&
          other.channelCid == this.channelCid);
}

class _ChannelQueriesCompanion extends UpdateCompanion<ChannelQuery> {
  final Value<String> queryHash;
  final Value<String> channelCid;
  const _ChannelQueriesCompanion({
    this.queryHash = const Value.absent(),
    this.channelCid = const Value.absent(),
  });
  _ChannelQueriesCompanion.insert({
    @required String queryHash,
    @required String channelCid,
  })  : queryHash = Value(queryHash),
        channelCid = Value(channelCid);
  _ChannelQueriesCompanion copyWith(
      {Value<String> queryHash, Value<String> channelCid}) {
    return _ChannelQueriesCompanion(
      queryHash: queryHash ?? this.queryHash,
      channelCid: channelCid ?? this.channelCid,
    );
  }
}

class $_ChannelQueriesTable extends _ChannelQueries
    with TableInfo<$_ChannelQueriesTable, ChannelQuery> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ChannelQueriesTable(this._db, [this._alias]);
  final VerificationMeta _queryHashMeta = const VerificationMeta('queryHash');
  GeneratedTextColumn _queryHash;
  @override
  GeneratedTextColumn get queryHash => _queryHash ??= _constructQueryHash();
  GeneratedTextColumn _constructQueryHash() {
    return GeneratedTextColumn(
      'query_hash',
      $tableName,
      false,
    );
  }

  final VerificationMeta _channelCidMeta = const VerificationMeta('channelCid');
  GeneratedTextColumn _channelCid;
  @override
  GeneratedTextColumn get channelCid => _channelCid ??= _constructChannelCid();
  GeneratedTextColumn _constructChannelCid() {
    return GeneratedTextColumn(
      'channel_cid',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [queryHash, channelCid];
  @override
  $_ChannelQueriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'channel_queries';
  @override
  final String actualTableName = 'channel_queries';
  @override
  VerificationContext validateIntegrity(_ChannelQueriesCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.queryHash.present) {
      context.handle(_queryHashMeta,
          queryHash.isAcceptableValue(d.queryHash.value, _queryHashMeta));
    } else if (isInserting) {
      context.missing(_queryHashMeta);
    }
    if (d.channelCid.present) {
      context.handle(_channelCidMeta,
          channelCid.isAcceptableValue(d.channelCid.value, _channelCidMeta));
    } else if (isInserting) {
      context.missing(_channelCidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queryHash, channelCid};
  @override
  ChannelQuery map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return ChannelQuery.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_ChannelQueriesCompanion d) {
    final map = <String, Variable>{};
    if (d.queryHash.present) {
      map['query_hash'] = Variable<String, StringType>(d.queryHash.value);
    }
    if (d.channelCid.present) {
      map['channel_cid'] = Variable<String, StringType>(d.channelCid.value);
    }
    return map;
  }

  @override
  $_ChannelQueriesTable createAlias(String alias) {
    return $_ChannelQueriesTable(_db, alias);
  }
}

class _Reaction extends DataClass implements Insertable<_Reaction> {
  final String messageId;
  final String type;
  final DateTime createdAt;
  final int score;
  final String userId;
  final Map<String, dynamic> extraData;
  _Reaction(
      {@required this.messageId,
      @required this.type,
      @required this.createdAt,
      this.score,
      @required this.userId,
      this.extraData});
  factory _Reaction.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final intType = db.typeSystem.forDartType<int>();
    return _Reaction(
      messageId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      createdAt: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_at']),
      score: intType.mapFromDatabaseResponse(data['${effectivePrefix}score']),
      userId:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}user_id']),
      extraData: $_ReactionsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _Reaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Reaction(
      messageId: serializer.fromJson<String>(json['messageId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      score: serializer.fromJson<int>(json['score']),
      userId: serializer.fromJson<String>(json['userId']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'score': serializer.toJson<int>(score),
      'userId': serializer.toJson<String>(userId),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  @override
  _ReactionsCompanion createCompanion(bool nullToAbsent) {
    return _ReactionsCompanion(
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  _Reaction copyWith(
          {String messageId,
          String type,
          DateTime createdAt,
          int score,
          String userId,
          Map<String, dynamic> extraData}) =>
      _Reaction(
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        score: score ?? this.score,
        userId: userId ?? this.userId,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_Reaction(')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('score: $score, ')
          ..write('userId: $userId, ')
          ..write('extraData: $extraData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      messageId.hashCode,
      $mrjc(
          type.hashCode,
          $mrjc(
              createdAt.hashCode,
              $mrjc(score.hashCode,
                  $mrjc(userId.hashCode, extraData.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Reaction &&
          other.messageId == this.messageId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.score == this.score &&
          other.userId == this.userId &&
          other.extraData == this.extraData);
}

class _ReactionsCompanion extends UpdateCompanion<_Reaction> {
  final Value<String> messageId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> score;
  final Value<String> userId;
  final Value<Map<String, dynamic>> extraData;
  const _ReactionsCompanion({
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.score = const Value.absent(),
    this.userId = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _ReactionsCompanion.insert({
    @required String messageId,
    @required String type,
    @required DateTime createdAt,
    this.score = const Value.absent(),
    @required String userId,
    this.extraData = const Value.absent(),
  })  : messageId = Value(messageId),
        type = Value(type),
        createdAt = Value(createdAt),
        userId = Value(userId);
  _ReactionsCompanion copyWith(
      {Value<String> messageId,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<int> score,
      Value<String> userId,
      Value<Map<String, dynamic>> extraData}) {
    return _ReactionsCompanion(
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      userId: userId ?? this.userId,
      extraData: extraData ?? this.extraData,
    );
  }
}

class $_ReactionsTable extends _Reactions
    with TableInfo<$_ReactionsTable, _Reaction> {
  final GeneratedDatabase _db;
  final String _alias;
  $_ReactionsTable(this._db, [this._alias]);
  final VerificationMeta _messageIdMeta = const VerificationMeta('messageId');
  GeneratedTextColumn _messageId;
  @override
  GeneratedTextColumn get messageId => _messageId ??= _constructMessageId();
  GeneratedTextColumn _constructMessageId() {
    return GeneratedTextColumn(
      'message_id',
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

  final VerificationMeta _scoreMeta = const VerificationMeta('score');
  GeneratedIntColumn _score;
  @override
  GeneratedIntColumn get score => _score ??= _constructScore();
  GeneratedIntColumn _constructScore() {
    return GeneratedIntColumn(
      'score',
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

  @override
  List<GeneratedColumn> get $columns =>
      [messageId, type, createdAt, score, userId, extraData];
  @override
  $_ReactionsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'reactions';
  @override
  final String actualTableName = 'reactions';
  @override
  VerificationContext validateIntegrity(_ReactionsCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.messageId.present) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableValue(d.messageId.value, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (d.type.present) {
      context.handle(
          _typeMeta, type.isAcceptableValue(d.type.value, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (d.createdAt.present) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableValue(d.createdAt.value, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (d.score.present) {
      context.handle(
          _scoreMeta, score.isAcceptableValue(d.score.value, _scoreMeta));
    }
    if (d.userId.present) {
      context.handle(
          _userIdMeta, userId.isAcceptableValue(d.userId.value, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, type, userId};
  @override
  _Reaction map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Reaction.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_ReactionsCompanion d) {
    final map = <String, Variable>{};
    if (d.messageId.present) {
      map['message_id'] = Variable<String, StringType>(d.messageId.value);
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.createdAt.present) {
      map['created_at'] = Variable<DateTime, DateTimeType>(d.createdAt.value);
    }
    if (d.score.present) {
      map['score'] = Variable<int, IntType>(d.score.value);
    }
    if (d.userId.present) {
      map['user_id'] = Variable<String, StringType>(d.userId.value);
    }
    if (d.extraData.present) {
      final converter = $_ReactionsTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_ReactionsTable createAlias(String alias) {
    return $_ReactionsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$OfflineDatabase.connect(DatabaseConnection c) : super.connect(c);
  $_ChannelsTable _channels;
  $_ChannelsTable get channels => _channels ??= $_ChannelsTable(this);
  $_UsersTable _users;
  $_UsersTable get users => _users ??= $_UsersTable(this);
  $_MessagesTable _messages;
  $_MessagesTable get messages => _messages ??= $_MessagesTable(this);
  $_ReadsTable _reads;
  $_ReadsTable get reads => _reads ??= $_ReadsTable(this);
  $_MembersTable _members;
  $_MembersTable get members => _members ??= $_MembersTable(this);
  $_ChannelQueriesTable _channelQueries;
  $_ChannelQueriesTable get channelQueries =>
      _channelQueries ??= $_ChannelQueriesTable(this);
  $_ReactionsTable _reactions;
  $_ReactionsTable get reactions => _reactions ??= $_ReactionsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [channels, users, messages, reads, members, channelQueries, reactions];
}
