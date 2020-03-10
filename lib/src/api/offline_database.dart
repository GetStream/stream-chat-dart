import 'dart:convert';
import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/user.dart';

import '../models/channel_state.dart';

part 'offline_database.g.dart';

class _Channel extends Table {
  TextColumn get id => text()();

  TextColumn get type => text()();

  TextColumn get cid => text()();

  BoolColumn get frozen => boolean().withDefault(Constant(false))();

  DateTimeColumn get lastMessageAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get memberCount => integer()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  TextColumn get createdBy => text().nullable()();

  @override
  Set<Column> get primaryKey => {cid};
}

class _User extends Table {
  TextColumn get id => text()();

  TextColumn get role => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get lastActive => dateTime().nullable()();

  BoolColumn get online => boolean().nullable()();

  BoolColumn get banned => boolean().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class _Message extends Table {
  TextColumn get id => text()();

  TextColumn get messageText => text().nullable()();

  TextColumn get status =>
      text().nullable().map(_MessageSendingStatusConverter())();

  TextColumn get type => text()();

//  List<Attachment> attachments;
  List<User> mentionedUsers;

  TextColumn get reactionCounts =>
      text().nullable().map(_ExtraDataConverter<int>())();

  TextColumn get reactionScores =>
      text().nullable().map(_ExtraDataConverter<int>())();

//  List<Reaction> latestReactions;
//  List<Reaction> ownReactions;
  TextColumn get parentId => text().nullable()();

  IntColumn get replyCount => integer().nullable()();

  BoolColumn get showInChannel => boolean().nullable()();

  TextColumn get command => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get userId => text().nullable()();

  TextColumn get channelId => text().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class _ExtraDataConverter<T> extends TypeConverter<Map<String, T>, String> {
  @override
  Map<String, T> mapToDart(fromDb) {
    return Map<String, T>.from(jsonDecode(fromDb) ?? {});
  }

  @override
  String mapToSql(value) {
    return jsonEncode(value);
  }
}

class _MessageSendingStatusConverter
    extends TypeConverter<MessageSendingStatus, String> {
  @override
  MessageSendingStatus mapToDart(fromDb) {
    switch (fromDb) {
      case 'SENDING':
        return MessageSendingStatus.SENDING;
      case 'SENT':
        return MessageSendingStatus.SENT;
      case 'FAILED':
        return MessageSendingStatus.FAILED;
      default:
        return null;
    }
  }

  @override
  String mapToSql(value) {
    return jsonEncode(value);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [
  _Channel,
  _User,
  _Message,
])
class OfflineDatabase extends _$OfflineDatabase {
  // we tell the database where to store the data with this constructor
  OfflineDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (openingDetails) async {
          final m = Migrator(this, customStatement);
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
          }
        },
        onUpgrade: (openingDetails, _, __) async {
          final m = Migrator(this, customStatement);
          for (final table in allTables) {
            await m.deleteTable(table.actualTableName);
            await m.createTable(table);
          }
        },
      );

  Future<List<ChannelState>> getChannelStates() async {
    return Future.wait(await select(channel).join([
      leftOuterJoin(user, channel.createdBy.equalsExp(user.id)),
    ]).map((row) async {
      final channelRow = row.readTable(channel);
      final userRow = row.readTable(user);

      final messages = await (select(message).join([
        leftOuterJoin(user, message.userId.equalsExp(user.id)),
      ])
            ..where(message.channelId.equals(channelRow.id))
            ..orderBy([
              OrderingTerm.asc(message.createdAt),
            ]))
          .map((row) {
        final messageRow = row.readTable(message);
        final userRow = row.readTable(user);
        return Message(
          createdAt: messageRow.createdAt,
          extraData: messageRow.extraData,
          updatedAt: messageRow.updatedAt,
          id: messageRow.id,
          type: messageRow.type,
          status: messageRow.status,
          command: messageRow.command,
          parentId: messageRow.parentId,
          reactionCounts: messageRow.reactionCounts,
          reactionScores: messageRow.reactionScores,
          replyCount: messageRow.replyCount,
          showInChannel: messageRow.showInChannel,
          text: messageRow.messageText,
          user: _userFromUserRow(userRow),
        );
      }).get();

      return ChannelState(
        messages: messages,
        channel: ChannelModel(
          id: channelRow.id,
          type: channelRow.type,
          frozen: channelRow.frozen,
          createdAt: channelRow.createdAt,
          updatedAt: channelRow.updatedAt,
          memberCount: channelRow.memberCount,
          cid: channelRow.cid,
          lastMessageAt: channelRow.lastMessageAt,
          deletedAt: channelRow.deletedAt,
          extraData: channelRow.extraData,
          members: [],
          config: null,
          createdBy: _userFromUserRow(userRow),
        ),
      );
    }).get());
  }

  User _userFromUserRow(_UserData userRow) {
    return User(
      updatedAt: userRow.updatedAt,
      role: userRow.role,
      online: userRow.online,
      lastActive: userRow.lastActive,
      extraData: userRow.extraData,
      banned: userRow.banned,
      createdAt: userRow.createdAt,
      id: userRow.id,
    );
  }

  Future<void> updateChannelState(ChannelState channelState) async {
    await updateChannelStates([channelState]);
  }

  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    await batch((batch) {
      batch.insertAll(
        message,
        channelStates
            .map((cs) => cs.messages.map((m) => _MessageData(
                  id: m.id,
                  channelId: cs.channel.id,
                  type: m.type,
                  parentId: m.parentId,
                  command: m.command,
                  createdAt: m.createdAt,
                  showInChannel: m.showInChannel,
                  replyCount: m.replyCount,
                  reactionScores: m.reactionScores,
                  reactionCounts: m.reactionCounts,
                  status: m.status,
                  updatedAt: m.updatedAt,
                  extraData: m.extraData,
                  userId: m.user.id,
                  messageText: m.text,
                )))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        user,
        channelStates
            .map((cs) => [
                  _userDataFromUser(cs.channel.createdBy),
                  ...cs.messages.map((m) => _userDataFromUser(m.user)),
                ])
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        channel,
        channelStates.map((cs) {
          final channel = cs.channel;
          return _channelDataFromChannelModel(channel);
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  _UserData _userDataFromUser(User user) {
    return _UserData(
      id: user.id,
      createdAt: user.createdAt,
      banned: user.banned,
      extraData: user.extraData,
      lastActive: user.lastActive,
      online: user.online,
      role: user.role,
      updatedAt: user.updatedAt,
    );
  }

  _ChannelData _channelDataFromChannelModel(ChannelModel channel) {
    return _ChannelData(
      id: channel.id,
      type: channel.type,
      frozen: channel.frozen,
      createdAt: channel.createdAt,
      updatedAt: channel.updatedAt,
      memberCount: channel.memberCount,
      cid: channel.cid,
      lastMessageAt: channel.lastMessageAt,
      deletedAt: channel.deletedAt,
      extraData: channel.extraData,
      createdBy: channel.createdBy.id,
    );
  }
}
