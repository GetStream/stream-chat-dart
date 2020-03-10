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

import '../../stream_chat.dart';
import '../models/channel_state.dart';

part 'models.dart';
part 'offline_database.g.dart';

LazyDatabase _openConnection(String userId) {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_$userId.sqlite'));
    return VmDatabase(
      file,
//      logStatements: true,
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
  _ChannelQueries,
])
class OfflineDatabase extends _$OfflineDatabase {
  // we tell the database where to store the data with this constructor
  OfflineDatabase(String userId) : super(_openConnection(userId));

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

//  @override
//  MigrationStrategy get migration => MigrationStrategy(
//        beforeOpen: (openingDetails) async {
//          final m = Migrator(this, customStatement);
//          for (final table in allTables) {
//            await m.deleteTable(table.actualTableName);
//            await m.createTable(table);
//          }
//        },
//        onUpgrade: (openingDetails, _, __) async {
//          final m = Migrator(this, customStatement);
//          for (final table in allTables) {
//            await m.deleteTable(table.actualTableName);
//            await m.createTable(table);
//          }
//        },
//      );

  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption> sort = const [],
    PaginationParams paginationParams,
    int messageLimit,
  }) async {
    String hash = _computeHash(filter);
    final cachedChannels = await Future.wait(await (select(channelQueries)
          ..where((c) => c.queryHash.equals(hash)))
        .get()
        .then((channelQueries) {
      final cids = channelQueries.map((c) => c.channelCid).toList();
      final query = select(channels)..where((c) => c.cid.isIn(cids));

      if (sort != null && sort.isNotEmpty) {
        query.orderBy(sort.map((s) {
          final orderExpression = CustomExpression('${s.field}');
          return (c) => OrderingTerm(
                expression: orderExpression,
                mode: s.direction == 1 ? OrderingMode.asc : OrderingMode.desc,
              );
        }).toList());
      }

      if (paginationParams != null) {
        query.limit(
          paginationParams.limit,
          offset: paginationParams.offset,
        );
      }

      return query.join([
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
      }).get();
    }));

    return cachedChannels;
  }

  String _computeHash(Map<String, dynamic> filter) {
    if (filter == null) {
      return 'allchannels';
    }
    final hash = base64Encode(utf8.encode('filter: ${jsonEncode(filter)}'));
    return hash;
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
                type: attachmentRow.type == '' ? null : attachmentRow.type,
                color: attachmentRow.color,
                assetUrl: attachmentRow.assetUrl == ''
                    ? null
                    : attachmentRow.assetUrl,
                title: attachmentRow.title,
                authorIcon: attachmentRow.authorIcon,
                authorLink: attachmentRow.authorLink,
                authorName: attachmentRow.authorName,
                fallback: attachmentRow.fallback,
                footer: attachmentRow.footer,
                footerIcon: attachmentRow.footerIcon,
                imageUrl: attachmentRow.imageUrl == ''
                    ? null
                    : attachmentRow.imageUrl,
                ogScrapeUrl: attachmentRow.ogScrapeUrl,
                pretext: attachmentRow.pretext,
                thumbUrl: attachmentRow.thumbUrl == ''
                    ? null
                    : attachmentRow.thumbUrl,
                titleLink: attachmentRow.titleLink == ''
                    ? null
                    : attachmentRow.titleLink,
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

  Future<void> updateChannelStates(
    List<ChannelState> channelStates, [
    Map<String, dynamic> filter,
  ]) async {
    await batch((batch) {
      final hash = _computeHash(filter);
      batch.insertAll(
        channelQueries,
        channelStates.map((c) {
          return ChannelQuery(
            queryHash: hash,
            channelCid: c.channel.cid,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );

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
                  if (cs.messages != null)
                    ...cs.messages.map((m) => _userDataFromUser(m.user)),
                  if (cs.read != null)
                    ...cs.read.map((r) => _userDataFromUser(r.user)),
                  if (cs.members != null)
                    ...cs.members.map((m) => _userDataFromUser(m.user)),
                ])
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      batch.insertAll(
        attachments,
        channelStates
            .map((cs) => cs.messages.map((m) {
                  final attachments = m.attachments.map((a) => _Attachment(
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
                      ));
                  return attachments;
                }).expand((v) => v))
            .expand((v) => v)
            .toList(),
        mode: InsertMode.insertOrReplace,
      );

      final newReads = channelStates
          .map((cs) => cs.read?.map((r) => _Read(
                lastRead: r.lastRead,
                userId: r.user.id,
                channelCid: cs.channel.cid,
              )))
          .where((v) => v != null)
          .expand((v) => v);

      if (newReads != null && newReads.isNotEmpty) {
        batch.insertAll(
          reads,
          newReads.toList(),
          mode: InsertMode.insertOrReplace,
        );
      }

      final newMembers = channelStates
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
          .where((v) => v != null)
          .expand((v) => v);
      if (newMembers != null && newMembers.isNotEmpty) {
        batch.insertAll(
          members,
          newMembers.toList(),
          mode: InsertMode.insertOrReplace,
        );
      }

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
