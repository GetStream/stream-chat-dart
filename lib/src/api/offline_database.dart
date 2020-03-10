import 'dart:convert';
import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat/src/models/attachment.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/read.dart';
import 'package:stream_chat/src/models/user.dart';

import '../models/channel_state.dart';

part 'offline_database.g.dart';

class _Channels extends Table {
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

class _Users extends Table {
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

class _Reads extends Table {
  DateTimeColumn get lastRead => dateTime()();

  TextColumn get userId => text()();

  TextColumn get channelCid => text()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}

class _Messages extends Table {
  TextColumn get id => text()();

  TextColumn get messageText => text().nullable()();

  IntColumn get status =>
      integer().map(_MessageSendingStatusConverter()).nullable()();

  TextColumn get type => text().nullable()();

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

  TextColumn get channelCid => text().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class _Members extends Table {
  TextColumn get userId => text()();

  TextColumn get channelCid => text()();

  TextColumn get role => text().nullable()();

  DateTimeColumn get inviteAcceptedAt => dateTime().nullable()();

  DateTimeColumn get inviteRejectedAt => dateTime().nullable()();

  BoolColumn get invited => boolean().nullable()();

  BoolColumn get isModerator => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {
        userId,
        channelCid,
      };
}

class _Attachments extends Table {
  TextColumn get messageId => text()();

  TextColumn get type => text().nullable()();

  TextColumn get titleLink => text().nullable()();

  TextColumn get title => text().nullable()();

  TextColumn get thumbUrl => text().nullable()();

  TextColumn get attachmentText => text().nullable()();

  TextColumn get pretext => text().nullable()();

  TextColumn get ogScrapeUrl => text().nullable()();

  TextColumn get imageUrl => text().nullable()();

  TextColumn get footerIcon => text().nullable()();

  TextColumn get footer => text().nullable()();

  TextColumn get fallback => text().nullable()();

  TextColumn get color => text().nullable()();

  TextColumn get authorName => text().nullable()();

  TextColumn get authorLink => text().nullable()();

  TextColumn get authorIcon => text().nullable()();

  TextColumn get assetUrl => text().nullable()();

  TextColumn get extraData => text().nullable().map(_ExtraDataConverter())();

  @override
  Set<Column> get primaryKey => {
        messageId,
        assetUrl,
        imageUrl,
        type,
      };
}

class _ExtraDataConverter<T> extends TypeConverter<Map<String, T>, String> {
  @override
  Map<String, T> mapToDart(fromDb) {
    if (fromDb == null) {
      return null;
    }
    return Map<String, T>.from(jsonDecode(fromDb) ?? {});
  }

  @override
  String mapToSql(value) {
    return jsonEncode(value);
  }
}

class _MessageSendingStatusConverter
    extends TypeConverter<MessageSendingStatus, int> {
  @override
  MessageSendingStatus mapToDart(int fromDb) {
    switch (fromDb) {
      case 0:
        return MessageSendingStatus.SENDING;
      case 1:
        return MessageSendingStatus.SENT;
      case 2:
        return MessageSendingStatus.FAILED;
      default:
        return null;
    }
  }

  @override
  int mapToSql(MessageSendingStatus value) {
    switch (value) {
      case MessageSendingStatus.SENDING:
        return 0;
      case MessageSendingStatus.SENT:
        return 1;
      case MessageSendingStatus.FAILED:
        return 2;
      default:
        return null;
    }
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(
      file,
    );
  });
}

@UseMoor(tables: [
  _Channels,
  _Users,
  _Messages,
  _Reads,
  _Members,
  _Attachments,
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
    return Future.wait(await (select(channels)
          ..orderBy([(c) => OrderingTerm.desc(c.lastMessageAt)]))
        .join([
      leftOuterJoin(users, channels.createdBy.equalsExp(users.id)),
    ]).map((row) async {
      final channelRow = row.readTable(channels);
      final userRow = row.readTable(users);

      List<Message> rowMessages = await _getChannelMessages(channelRow);
      List<Read> rowReads = await _getChannelReads(channelRow);
      List<Member> rowMembers = await _getChannelMembers(channelRow);

      return ChannelState(
        members: rowMembers,
        read: rowReads,
        messages: rowMessages,
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

  Future<List<Message>> _getChannelMessages(_Channel channelRow) async {
    final rowMessages = await Future.wait(await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.channelCid.equals(channelRow.cid))
          ..orderBy([
            OrderingTerm.asc(messages.createdAt),
          ]))
        .map((row) async {
      final messageRow = row.readTable(messages);
      final userRow = row.readTable(users);

      final attachmentsRow = await (select(attachments)
            ..where((a) => a.messageId.equals(messageRow.id)))
          .map((attachmentRow) => Attachment(
                extraData: attachmentRow.extraData,
                text: attachmentRow.attachmentText,
                type: attachmentRow.type,
                color: attachmentRow.color,
                assetUrl: attachmentRow.assetUrl,
                title: attachmentRow.title,
                authorIcon: attachmentRow.authorIcon,
                authorLink: attachmentRow.authorLink,
                authorName: attachmentRow.authorName,
                fallback: attachmentRow.fallback,
                footer: attachmentRow.footer,
                footerIcon: attachmentRow.footerIcon,
                imageUrl: attachmentRow.imageUrl,
                ogScrapeUrl: attachmentRow.ogScrapeUrl,
                pretext: attachmentRow.pretext,
                thumbUrl: attachmentRow.thumbUrl,
                titleLink: attachmentRow.titleLink,
              ))
          .get();

      return Message(
        attachments: attachmentsRow,
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
    }).get());
    return rowMessages;
  }

  Future<List<Read>> _getChannelReads(_Channel channelRow) async {
    final rowReads = await (select(reads).join([
      leftOuterJoin(users, reads.userId.equalsExp(users.id)),
    ])
          ..where(reads.channelCid.equals(channelRow.cid))
          ..orderBy([
            OrderingTerm.asc(reads.lastRead),
          ]))
        .map((row) {
      final userRow = row.readTable(users);
      final readRow = row.readTable(reads);
      return Read(
        user: _userFromUserRow(userRow),
        lastRead: readRow.lastRead,
      );
    }).get();
    return rowReads;
  }

  Future<List<Member>> _getChannelMembers(_Channel channelRow) async {
    final rowMembers = await (select(members).join([
      leftOuterJoin(users, members.userId.equalsExp(users.id)),
    ])
          ..where(members.channelCid.equals(channelRow.cid))
          ..orderBy([
            OrderingTerm.asc(members.createdAt),
          ]))
        .map((row) {
      final userRow = row.readTable(users);
      final memberRow = row.readTable(members);
      return Member(
        user: _userFromUserRow(userRow),
        userId: userRow.id,
        updatedAt: memberRow.updatedAt,
        createdAt: memberRow.createdAt,
        role: memberRow.role,
        inviteAcceptedAt: memberRow.inviteAcceptedAt,
        invited: memberRow.invited,
        inviteRejectedAt: memberRow.inviteRejectedAt,
        isModerator: memberRow.isModerator,
      );
    }).get();
    return rowMembers;
  }

  User _userFromUserRow(_User userRow) {
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
        messages,
        channelStates
            .map((cs) => cs.messages.map(
                  (m) {
                    return _Message(
                      id: m.id,
                      channelCid: cs.channel.cid,
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
                    );
                  },
                ))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        users,
        channelStates
            .map((cs) => [
                  _userDataFromUser(cs.channel.createdBy),
                  ...cs.messages.map((m) => _userDataFromUser(m.user)),
                  ...cs.read.map((r) => _userDataFromUser(r.user)),
                  ...cs.members.map((m) => _userDataFromUser(m.user)),
                ])
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        attachments,
        channelStates
            .map((cs) => cs.messages
                .map((m) => m.attachments.map((a) => _Attachment(
                      messageId: m.id,
                      titleLink: a.titleLink,
                      thumbUrl: a.thumbUrl,
                      pretext: a.pretext,
                      ogScrapeUrl: a.ogScrapeUrl,
                      imageUrl: a.imageUrl,
                      footerIcon: a.footerIcon,
                      footer: a.footer,
                      fallback: a.fallback,
                      authorName: a.authorName,
                      authorLink: a.authorLink,
                      authorIcon: a.authorIcon,
                      title: a.title,
                      assetUrl: a.assetUrl,
                      color: a.color,
                      type: a.type,
                      extraData: a.extraData,
                      attachmentText: a.text,
                    )))
                .expand((v) => v))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        reads,
        channelStates
            .map((cs) => cs.read.map((r) => _Read(
                  lastRead: r.lastRead,
                  userId: r.user.id,
                  channelCid: cs.channel.cid,
                )))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        members,
        channelStates
            .map((cs) => cs.members.map((m) => _Member(
                  userId: m.user.id,
                  channelCid: cs.channel.cid,
                  createdAt: m.createdAt,
                  isModerator: m.isModerator,
                  inviteRejectedAt: m.inviteRejectedAt,
                  invited: m.invited,
                  inviteAcceptedAt: m.inviteAcceptedAt,
                  role: m.role,
                  updatedAt: m.updatedAt,
                )))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        channels,
        channelStates.map((cs) {
          final channel = cs.channel;
          return _channelDataFromChannelModel(channel);
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  _User _userDataFromUser(User user) {
    return _User(
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

  _Channel _channelDataFromChannelModel(ChannelModel channel) {
    return _Channel(
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
