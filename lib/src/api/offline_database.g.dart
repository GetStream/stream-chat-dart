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
      @required this.frozen,
      this.lastMessageAt,
      @required this.createdAt,
      @required this.updatedAt,
      this.deletedAt,
      @required this.memberCount,
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
  _ChannelsCompanion createCompanion(bool nullToAbsent) {
    return _ChannelsCompanion(
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

  _Channel copyWith(
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
      _Channel(
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
    return (StringBuffer('_Channel(')
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
      (other is _Channel &&
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

class _ChannelsCompanion extends UpdateCompanion<_Channel> {
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
  const _ChannelsCompanion({
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
  _ChannelsCompanion.insert({
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
  _ChannelsCompanion copyWith(
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
    return _ChannelsCompanion(
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
      @required this.createdAt,
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
    @required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.lastActive = const Value.absent(),
    this.online = const Value.absent(),
    this.banned = const Value.absent(),
    this.extraData = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt);
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
                                                          channelCid.hashCode,
                                                          extraData
                                                              .hashCode)))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Message &&
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
          other.channelCid == this.channelCid &&
          other.extraData == this.extraData);
}

class _MessagesCompanion extends UpdateCompanion<_Message> {
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
  final Value<String> channelCid;
  final Value<Map<String, dynamic>> extraData;
  const _MessagesCompanion({
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
    this.channelCid = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _MessagesCompanion.insert({
    @required String id,
    this.messageText = const Value.absent(),
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

class _Attachment extends DataClass implements Insertable<_Attachment> {
  final String messageId;
  final String type;
  final String titleLink;
  final String title;
  final String thumbUrl;
  final String attachmentText;
  final String pretext;
  final String ogScrapeUrl;
  final String imageUrl;
  final String footerIcon;
  final String footer;
  final String fallback;
  final String color;
  final String authorName;
  final String authorLink;
  final String authorIcon;
  final String assetUrl;
  final Map<String, dynamic> extraData;
  _Attachment(
      {@required this.messageId,
      this.type,
      this.titleLink,
      this.title,
      this.thumbUrl,
      this.attachmentText,
      this.pretext,
      this.ogScrapeUrl,
      this.imageUrl,
      this.footerIcon,
      this.footer,
      this.fallback,
      this.color,
      this.authorName,
      this.authorLink,
      this.authorIcon,
      this.assetUrl,
      this.extraData});
  factory _Attachment.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final stringType = db.typeSystem.forDartType<String>();
    return _Attachment(
      messageId: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}message_id']),
      type: stringType.mapFromDatabaseResponse(data['${effectivePrefix}type']),
      titleLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}title_link']),
      title:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}title']),
      thumbUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}thumb_url']),
      attachmentText: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}attachment_text']),
      pretext:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}pretext']),
      ogScrapeUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}og_scrape_url']),
      imageUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}image_url']),
      footerIcon: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}footer_icon']),
      footer:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}footer']),
      fallback: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}fallback']),
      color:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}color']),
      authorName: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}author_name']),
      authorLink: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}author_link']),
      authorIcon: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}author_icon']),
      assetUrl: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}asset_url']),
      extraData: $_AttachmentsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}extra_data'])),
    );
  }
  factory _Attachment.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return _Attachment(
      messageId: serializer.fromJson<String>(json['messageId']),
      type: serializer.fromJson<String>(json['type']),
      titleLink: serializer.fromJson<String>(json['titleLink']),
      title: serializer.fromJson<String>(json['title']),
      thumbUrl: serializer.fromJson<String>(json['thumbUrl']),
      attachmentText: serializer.fromJson<String>(json['attachmentText']),
      pretext: serializer.fromJson<String>(json['pretext']),
      ogScrapeUrl: serializer.fromJson<String>(json['ogScrapeUrl']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      footerIcon: serializer.fromJson<String>(json['footerIcon']),
      footer: serializer.fromJson<String>(json['footer']),
      fallback: serializer.fromJson<String>(json['fallback']),
      color: serializer.fromJson<String>(json['color']),
      authorName: serializer.fromJson<String>(json['authorName']),
      authorLink: serializer.fromJson<String>(json['authorLink']),
      authorIcon: serializer.fromJson<String>(json['authorIcon']),
      assetUrl: serializer.fromJson<String>(json['assetUrl']),
      extraData: serializer.fromJson<Map<String, dynamic>>(json['extraData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'type': serializer.toJson<String>(type),
      'titleLink': serializer.toJson<String>(titleLink),
      'title': serializer.toJson<String>(title),
      'thumbUrl': serializer.toJson<String>(thumbUrl),
      'attachmentText': serializer.toJson<String>(attachmentText),
      'pretext': serializer.toJson<String>(pretext),
      'ogScrapeUrl': serializer.toJson<String>(ogScrapeUrl),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'footerIcon': serializer.toJson<String>(footerIcon),
      'footer': serializer.toJson<String>(footer),
      'fallback': serializer.toJson<String>(fallback),
      'color': serializer.toJson<String>(color),
      'authorName': serializer.toJson<String>(authorName),
      'authorLink': serializer.toJson<String>(authorLink),
      'authorIcon': serializer.toJson<String>(authorIcon),
      'assetUrl': serializer.toJson<String>(assetUrl),
      'extraData': serializer.toJson<Map<String, dynamic>>(extraData),
    };
  }

  @override
  _AttachmentsCompanion createCompanion(bool nullToAbsent) {
    return _AttachmentsCompanion(
      messageId: messageId == null && nullToAbsent
          ? const Value.absent()
          : Value(messageId),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      titleLink: titleLink == null && nullToAbsent
          ? const Value.absent()
          : Value(titleLink),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      thumbUrl: thumbUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbUrl),
      attachmentText: attachmentText == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentText),
      pretext: pretext == null && nullToAbsent
          ? const Value.absent()
          : Value(pretext),
      ogScrapeUrl: ogScrapeUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(ogScrapeUrl),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      footerIcon: footerIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(footerIcon),
      footer:
          footer == null && nullToAbsent ? const Value.absent() : Value(footer),
      fallback: fallback == null && nullToAbsent
          ? const Value.absent()
          : Value(fallback),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      authorName: authorName == null && nullToAbsent
          ? const Value.absent()
          : Value(authorName),
      authorLink: authorLink == null && nullToAbsent
          ? const Value.absent()
          : Value(authorLink),
      authorIcon: authorIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(authorIcon),
      assetUrl: assetUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(assetUrl),
      extraData: extraData == null && nullToAbsent
          ? const Value.absent()
          : Value(extraData),
    );
  }

  _Attachment copyWith(
          {String messageId,
          String type,
          String titleLink,
          String title,
          String thumbUrl,
          String attachmentText,
          String pretext,
          String ogScrapeUrl,
          String imageUrl,
          String footerIcon,
          String footer,
          String fallback,
          String color,
          String authorName,
          String authorLink,
          String authorIcon,
          String assetUrl,
          Map<String, dynamic> extraData}) =>
      _Attachment(
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        titleLink: titleLink ?? this.titleLink,
        title: title ?? this.title,
        thumbUrl: thumbUrl ?? this.thumbUrl,
        attachmentText: attachmentText ?? this.attachmentText,
        pretext: pretext ?? this.pretext,
        ogScrapeUrl: ogScrapeUrl ?? this.ogScrapeUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        footerIcon: footerIcon ?? this.footerIcon,
        footer: footer ?? this.footer,
        fallback: fallback ?? this.fallback,
        color: color ?? this.color,
        authorName: authorName ?? this.authorName,
        authorLink: authorLink ?? this.authorLink,
        authorIcon: authorIcon ?? this.authorIcon,
        assetUrl: assetUrl ?? this.assetUrl,
        extraData: extraData ?? this.extraData,
      );
  @override
  String toString() {
    return (StringBuffer('_Attachment(')
          ..write('messageId: $messageId, ')
          ..write('type: $type, ')
          ..write('titleLink: $titleLink, ')
          ..write('title: $title, ')
          ..write('thumbUrl: $thumbUrl, ')
          ..write('attachmentText: $attachmentText, ')
          ..write('pretext: $pretext, ')
          ..write('ogScrapeUrl: $ogScrapeUrl, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('footerIcon: $footerIcon, ')
          ..write('footer: $footer, ')
          ..write('fallback: $fallback, ')
          ..write('color: $color, ')
          ..write('authorName: $authorName, ')
          ..write('authorLink: $authorLink, ')
          ..write('authorIcon: $authorIcon, ')
          ..write('assetUrl: $assetUrl, ')
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
              titleLink.hashCode,
              $mrjc(
                  title.hashCode,
                  $mrjc(
                      thumbUrl.hashCode,
                      $mrjc(
                          attachmentText.hashCode,
                          $mrjc(
                              pretext.hashCode,
                              $mrjc(
                                  ogScrapeUrl.hashCode,
                                  $mrjc(
                                      imageUrl.hashCode,
                                      $mrjc(
                                          footerIcon.hashCode,
                                          $mrjc(
                                              footer.hashCode,
                                              $mrjc(
                                                  fallback.hashCode,
                                                  $mrjc(
                                                      color.hashCode,
                                                      $mrjc(
                                                          authorName.hashCode,
                                                          $mrjc(
                                                              authorLink
                                                                  .hashCode,
                                                              $mrjc(
                                                                  authorIcon
                                                                      .hashCode,
                                                                  $mrjc(
                                                                      assetUrl
                                                                          .hashCode,
                                                                      extraData
                                                                          .hashCode))))))))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is _Attachment &&
          other.messageId == this.messageId &&
          other.type == this.type &&
          other.titleLink == this.titleLink &&
          other.title == this.title &&
          other.thumbUrl == this.thumbUrl &&
          other.attachmentText == this.attachmentText &&
          other.pretext == this.pretext &&
          other.ogScrapeUrl == this.ogScrapeUrl &&
          other.imageUrl == this.imageUrl &&
          other.footerIcon == this.footerIcon &&
          other.footer == this.footer &&
          other.fallback == this.fallback &&
          other.color == this.color &&
          other.authorName == this.authorName &&
          other.authorLink == this.authorLink &&
          other.authorIcon == this.authorIcon &&
          other.assetUrl == this.assetUrl &&
          other.extraData == this.extraData);
}

class _AttachmentsCompanion extends UpdateCompanion<_Attachment> {
  final Value<String> messageId;
  final Value<String> type;
  final Value<String> titleLink;
  final Value<String> title;
  final Value<String> thumbUrl;
  final Value<String> attachmentText;
  final Value<String> pretext;
  final Value<String> ogScrapeUrl;
  final Value<String> imageUrl;
  final Value<String> footerIcon;
  final Value<String> footer;
  final Value<String> fallback;
  final Value<String> color;
  final Value<String> authorName;
  final Value<String> authorLink;
  final Value<String> authorIcon;
  final Value<String> assetUrl;
  final Value<Map<String, dynamic>> extraData;
  const _AttachmentsCompanion({
    this.messageId = const Value.absent(),
    this.type = const Value.absent(),
    this.titleLink = const Value.absent(),
    this.title = const Value.absent(),
    this.thumbUrl = const Value.absent(),
    this.attachmentText = const Value.absent(),
    this.pretext = const Value.absent(),
    this.ogScrapeUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.footerIcon = const Value.absent(),
    this.footer = const Value.absent(),
    this.fallback = const Value.absent(),
    this.color = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorLink = const Value.absent(),
    this.authorIcon = const Value.absent(),
    this.assetUrl = const Value.absent(),
    this.extraData = const Value.absent(),
  });
  _AttachmentsCompanion.insert({
    @required String messageId,
    this.type = const Value.absent(),
    this.titleLink = const Value.absent(),
    this.title = const Value.absent(),
    this.thumbUrl = const Value.absent(),
    this.attachmentText = const Value.absent(),
    this.pretext = const Value.absent(),
    this.ogScrapeUrl = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.footerIcon = const Value.absent(),
    this.footer = const Value.absent(),
    this.fallback = const Value.absent(),
    this.color = const Value.absent(),
    this.authorName = const Value.absent(),
    this.authorLink = const Value.absent(),
    this.authorIcon = const Value.absent(),
    this.assetUrl = const Value.absent(),
    this.extraData = const Value.absent(),
  }) : messageId = Value(messageId);
  _AttachmentsCompanion copyWith(
      {Value<String> messageId,
      Value<String> type,
      Value<String> titleLink,
      Value<String> title,
      Value<String> thumbUrl,
      Value<String> attachmentText,
      Value<String> pretext,
      Value<String> ogScrapeUrl,
      Value<String> imageUrl,
      Value<String> footerIcon,
      Value<String> footer,
      Value<String> fallback,
      Value<String> color,
      Value<String> authorName,
      Value<String> authorLink,
      Value<String> authorIcon,
      Value<String> assetUrl,
      Value<Map<String, dynamic>> extraData}) {
    return _AttachmentsCompanion(
      messageId: messageId ?? this.messageId,
      type: type ?? this.type,
      titleLink: titleLink ?? this.titleLink,
      title: title ?? this.title,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      attachmentText: attachmentText ?? this.attachmentText,
      pretext: pretext ?? this.pretext,
      ogScrapeUrl: ogScrapeUrl ?? this.ogScrapeUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      footerIcon: footerIcon ?? this.footerIcon,
      footer: footer ?? this.footer,
      fallback: fallback ?? this.fallback,
      color: color ?? this.color,
      authorName: authorName ?? this.authorName,
      authorLink: authorLink ?? this.authorLink,
      authorIcon: authorIcon ?? this.authorIcon,
      assetUrl: assetUrl ?? this.assetUrl,
      extraData: extraData ?? this.extraData,
    );
  }
}

class $_AttachmentsTable extends _Attachments
    with TableInfo<$_AttachmentsTable, _Attachment> {
  final GeneratedDatabase _db;
  final String _alias;
  $_AttachmentsTable(this._db, [this._alias]);
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
      true,
    );
  }

  final VerificationMeta _titleLinkMeta = const VerificationMeta('titleLink');
  GeneratedTextColumn _titleLink;
  @override
  GeneratedTextColumn get titleLink => _titleLink ??= _constructTitleLink();
  GeneratedTextColumn _constructTitleLink() {
    return GeneratedTextColumn(
      'title_link',
      $tableName,
      true,
    );
  }

  final VerificationMeta _titleMeta = const VerificationMeta('title');
  GeneratedTextColumn _title;
  @override
  GeneratedTextColumn get title => _title ??= _constructTitle();
  GeneratedTextColumn _constructTitle() {
    return GeneratedTextColumn(
      'title',
      $tableName,
      true,
    );
  }

  final VerificationMeta _thumbUrlMeta = const VerificationMeta('thumbUrl');
  GeneratedTextColumn _thumbUrl;
  @override
  GeneratedTextColumn get thumbUrl => _thumbUrl ??= _constructThumbUrl();
  GeneratedTextColumn _constructThumbUrl() {
    return GeneratedTextColumn(
      'thumb_url',
      $tableName,
      true,
    );
  }

  final VerificationMeta _attachmentTextMeta =
      const VerificationMeta('attachmentText');
  GeneratedTextColumn _attachmentText;
  @override
  GeneratedTextColumn get attachmentText =>
      _attachmentText ??= _constructAttachmentText();
  GeneratedTextColumn _constructAttachmentText() {
    return GeneratedTextColumn(
      'attachment_text',
      $tableName,
      true,
    );
  }

  final VerificationMeta _pretextMeta = const VerificationMeta('pretext');
  GeneratedTextColumn _pretext;
  @override
  GeneratedTextColumn get pretext => _pretext ??= _constructPretext();
  GeneratedTextColumn _constructPretext() {
    return GeneratedTextColumn(
      'pretext',
      $tableName,
      true,
    );
  }

  final VerificationMeta _ogScrapeUrlMeta =
      const VerificationMeta('ogScrapeUrl');
  GeneratedTextColumn _ogScrapeUrl;
  @override
  GeneratedTextColumn get ogScrapeUrl =>
      _ogScrapeUrl ??= _constructOgScrapeUrl();
  GeneratedTextColumn _constructOgScrapeUrl() {
    return GeneratedTextColumn(
      'og_scrape_url',
      $tableName,
      true,
    );
  }

  final VerificationMeta _imageUrlMeta = const VerificationMeta('imageUrl');
  GeneratedTextColumn _imageUrl;
  @override
  GeneratedTextColumn get imageUrl => _imageUrl ??= _constructImageUrl();
  GeneratedTextColumn _constructImageUrl() {
    return GeneratedTextColumn(
      'image_url',
      $tableName,
      true,
    );
  }

  final VerificationMeta _footerIconMeta = const VerificationMeta('footerIcon');
  GeneratedTextColumn _footerIcon;
  @override
  GeneratedTextColumn get footerIcon => _footerIcon ??= _constructFooterIcon();
  GeneratedTextColumn _constructFooterIcon() {
    return GeneratedTextColumn(
      'footer_icon',
      $tableName,
      true,
    );
  }

  final VerificationMeta _footerMeta = const VerificationMeta('footer');
  GeneratedTextColumn _footer;
  @override
  GeneratedTextColumn get footer => _footer ??= _constructFooter();
  GeneratedTextColumn _constructFooter() {
    return GeneratedTextColumn(
      'footer',
      $tableName,
      true,
    );
  }

  final VerificationMeta _fallbackMeta = const VerificationMeta('fallback');
  GeneratedTextColumn _fallback;
  @override
  GeneratedTextColumn get fallback => _fallback ??= _constructFallback();
  GeneratedTextColumn _constructFallback() {
    return GeneratedTextColumn(
      'fallback',
      $tableName,
      true,
    );
  }

  final VerificationMeta _colorMeta = const VerificationMeta('color');
  GeneratedTextColumn _color;
  @override
  GeneratedTextColumn get color => _color ??= _constructColor();
  GeneratedTextColumn _constructColor() {
    return GeneratedTextColumn(
      'color',
      $tableName,
      true,
    );
  }

  final VerificationMeta _authorNameMeta = const VerificationMeta('authorName');
  GeneratedTextColumn _authorName;
  @override
  GeneratedTextColumn get authorName => _authorName ??= _constructAuthorName();
  GeneratedTextColumn _constructAuthorName() {
    return GeneratedTextColumn(
      'author_name',
      $tableName,
      true,
    );
  }

  final VerificationMeta _authorLinkMeta = const VerificationMeta('authorLink');
  GeneratedTextColumn _authorLink;
  @override
  GeneratedTextColumn get authorLink => _authorLink ??= _constructAuthorLink();
  GeneratedTextColumn _constructAuthorLink() {
    return GeneratedTextColumn(
      'author_link',
      $tableName,
      true,
    );
  }

  final VerificationMeta _authorIconMeta = const VerificationMeta('authorIcon');
  GeneratedTextColumn _authorIcon;
  @override
  GeneratedTextColumn get authorIcon => _authorIcon ??= _constructAuthorIcon();
  GeneratedTextColumn _constructAuthorIcon() {
    return GeneratedTextColumn(
      'author_icon',
      $tableName,
      true,
    );
  }

  final VerificationMeta _assetUrlMeta = const VerificationMeta('assetUrl');
  GeneratedTextColumn _assetUrl;
  @override
  GeneratedTextColumn get assetUrl => _assetUrl ??= _constructAssetUrl();
  GeneratedTextColumn _constructAssetUrl() {
    return GeneratedTextColumn(
      'asset_url',
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
        messageId,
        type,
        titleLink,
        title,
        thumbUrl,
        attachmentText,
        pretext,
        ogScrapeUrl,
        imageUrl,
        footerIcon,
        footer,
        fallback,
        color,
        authorName,
        authorLink,
        authorIcon,
        assetUrl,
        extraData
      ];
  @override
  $_AttachmentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'attachments';
  @override
  final String actualTableName = 'attachments';
  @override
  VerificationContext validateIntegrity(_AttachmentsCompanion d,
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
    }
    if (d.titleLink.present) {
      context.handle(_titleLinkMeta,
          titleLink.isAcceptableValue(d.titleLink.value, _titleLinkMeta));
    }
    if (d.title.present) {
      context.handle(
          _titleMeta, title.isAcceptableValue(d.title.value, _titleMeta));
    }
    if (d.thumbUrl.present) {
      context.handle(_thumbUrlMeta,
          thumbUrl.isAcceptableValue(d.thumbUrl.value, _thumbUrlMeta));
    }
    if (d.attachmentText.present) {
      context.handle(
          _attachmentTextMeta,
          attachmentText.isAcceptableValue(
              d.attachmentText.value, _attachmentTextMeta));
    }
    if (d.pretext.present) {
      context.handle(_pretextMeta,
          pretext.isAcceptableValue(d.pretext.value, _pretextMeta));
    }
    if (d.ogScrapeUrl.present) {
      context.handle(_ogScrapeUrlMeta,
          ogScrapeUrl.isAcceptableValue(d.ogScrapeUrl.value, _ogScrapeUrlMeta));
    }
    if (d.imageUrl.present) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableValue(d.imageUrl.value, _imageUrlMeta));
    }
    if (d.footerIcon.present) {
      context.handle(_footerIconMeta,
          footerIcon.isAcceptableValue(d.footerIcon.value, _footerIconMeta));
    }
    if (d.footer.present) {
      context.handle(
          _footerMeta, footer.isAcceptableValue(d.footer.value, _footerMeta));
    }
    if (d.fallback.present) {
      context.handle(_fallbackMeta,
          fallback.isAcceptableValue(d.fallback.value, _fallbackMeta));
    }
    if (d.color.present) {
      context.handle(
          _colorMeta, color.isAcceptableValue(d.color.value, _colorMeta));
    }
    if (d.authorName.present) {
      context.handle(_authorNameMeta,
          authorName.isAcceptableValue(d.authorName.value, _authorNameMeta));
    }
    if (d.authorLink.present) {
      context.handle(_authorLinkMeta,
          authorLink.isAcceptableValue(d.authorLink.value, _authorLinkMeta));
    }
    if (d.authorIcon.present) {
      context.handle(_authorIconMeta,
          authorIcon.isAcceptableValue(d.authorIcon.value, _authorIconMeta));
    }
    if (d.assetUrl.present) {
      context.handle(_assetUrlMeta,
          assetUrl.isAcceptableValue(d.assetUrl.value, _assetUrlMeta));
    }
    context.handle(_extraDataMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId, assetUrl, imageUrl, type};
  @override
  _Attachment map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return _Attachment.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(_AttachmentsCompanion d) {
    final map = <String, Variable>{};
    if (d.messageId.present) {
      map['message_id'] = Variable<String, StringType>(d.messageId.value);
    }
    if (d.type.present) {
      map['type'] = Variable<String, StringType>(d.type.value);
    }
    if (d.titleLink.present) {
      map['title_link'] = Variable<String, StringType>(d.titleLink.value);
    }
    if (d.title.present) {
      map['title'] = Variable<String, StringType>(d.title.value);
    }
    if (d.thumbUrl.present) {
      map['thumb_url'] = Variable<String, StringType>(d.thumbUrl.value);
    }
    if (d.attachmentText.present) {
      map['attachment_text'] =
          Variable<String, StringType>(d.attachmentText.value);
    }
    if (d.pretext.present) {
      map['pretext'] = Variable<String, StringType>(d.pretext.value);
    }
    if (d.ogScrapeUrl.present) {
      map['og_scrape_url'] = Variable<String, StringType>(d.ogScrapeUrl.value);
    }
    if (d.imageUrl.present) {
      map['image_url'] = Variable<String, StringType>(d.imageUrl.value);
    }
    if (d.footerIcon.present) {
      map['footer_icon'] = Variable<String, StringType>(d.footerIcon.value);
    }
    if (d.footer.present) {
      map['footer'] = Variable<String, StringType>(d.footer.value);
    }
    if (d.fallback.present) {
      map['fallback'] = Variable<String, StringType>(d.fallback.value);
    }
    if (d.color.present) {
      map['color'] = Variable<String, StringType>(d.color.value);
    }
    if (d.authorName.present) {
      map['author_name'] = Variable<String, StringType>(d.authorName.value);
    }
    if (d.authorLink.present) {
      map['author_link'] = Variable<String, StringType>(d.authorLink.value);
    }
    if (d.authorIcon.present) {
      map['author_icon'] = Variable<String, StringType>(d.authorIcon.value);
    }
    if (d.assetUrl.present) {
      map['asset_url'] = Variable<String, StringType>(d.assetUrl.value);
    }
    if (d.extraData.present) {
      final converter = $_AttachmentsTable.$converter0;
      map['extra_data'] =
          Variable<String, StringType>(converter.mapToSql(d.extraData.value));
    }
    return map;
  }

  @override
  $_AttachmentsTable createAlias(String alias) {
    return $_AttachmentsTable(_db, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $converter0 =
      _ExtraDataConverter();
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
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
  $_AttachmentsTable _attachments;
  $_AttachmentsTable get attachments =>
      _attachments ??= $_AttachmentsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [channels, users, messages, reads, members, attachments];
}
