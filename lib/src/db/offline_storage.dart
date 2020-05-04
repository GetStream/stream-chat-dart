import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:logging/logging.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/own_user.dart';

import '../api/requests.dart';
import '../models/attachment.dart';
import '../models/channel_config.dart';
import '../models/channel_model.dart';
import '../models/channel_state.dart';
import '../models/member.dart';
import '../models/message.dart';
import '../models/reaction.dart';
import '../models/read.dart';
import '../models/user.dart';

part 'models.part.dart';
part 'offline_storage.g.dart';

Future<MoorIsolate> _createMoorIsolate(String userId) async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'db_$userId.sqlite');

  final receivePort = ReceivePort();
  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path),
  );

  return (await receivePort.first as MoorIsolate);
}

void _startBackground(_IsolateStartRequest request) {
  final executor = LazyDatabase(() async {
    return VmDatabase(File(request.targetPath));
  });
  final moorIsolate = MoorIsolate.inCurrent(
    () => DatabaseConnection.fromExecutor(executor),
  );
  request.sendMoorIsolate.send(moorIsolate);
}

/// Gets a new instance of the database running on a background isolate
Future<OfflineStorage> connectDatabase(User user, Logger logger) async {
  logger.info('Connecting on background isolate');
  final isolate = await _createMoorIsolate(user.id);
  final connection = await isolate.connect();
  return OfflineStorage.connect(
    connection,
    user.id,
    isolate,
    logger,
  );
}

class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}

LazyDatabase _openConnection(String userId) {
  moorRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'db_$userId.sqlite');
    final file = File(path);
    return VmDatabase(file);
  });
}

/// Offline database used for caching channel queries and state
@UseMoor(tables: [
  _ConnectionEvent,
  _Channels,
  _Users,
  _Messages,
  _Reads,
  _Members,
  _ChannelQueries,
  _Reactions,
])
class OfflineStorage extends _$OfflineStorage {
  /// Creates a new database instance
  OfflineStorage.connect(
    DatabaseConnection connection,
    this._userId,
    this._isolate,
    this._logger,
  ) : super.connect(connection);

  /// Instantiate a new OfflineStorage
  OfflineStorage(
    this._userId,
    this._logger,
  )   : _isolate = null,
        super(_openConnection(_userId)) {
    _logger.info('Connecting on standard isolate');
  }

  final String _userId;
  final MoorIsolate _isolate;
  final Logger _logger;

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

  /// Closes the database instance
  /// If [flush] is true, the database data will be deleted
  Future<void> disconnect({bool flush = false}) async {
    _logger.info('Disconnecting');
    if (flush) {
      _logger.info('Flushing');
      await batch((batch) {
        allTables.forEach((table) {
          delete(table);
        });
      });
    }

    await _isolate?.shutdownAll();

    await close();
  }

  /// Get stored replies by messageId
  Future<List<Message>> getReplies(String parentId) async {
    return await Future.wait(await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.parentId.equals(parentId))
          ..orderBy([
            OrderingTerm.asc(messages.createdAt),
          ]))
        .map(_messageFromJoinRow)
        .get());
  }

  /// Get stored connection event
  Future<Event> getConnectionInfo() async {
    return select(connectionEvent)
        .map((row) => Event(
              me: OwnUser.fromJson(row.ownUser),
              totalUnreadCount: row.totalUnreadCount,
              unreadChannels: row.unreadChannels,
            ))
        .getSingle();
  }

  /// Update stored connection event
  Future<void> updateConnectionInfo(Event event) async {
    return into(connectionEvent).insert(
      _ConnectionEventData(
        id: 1,
        unreadChannels: event.unreadChannels,
        totalUnreadCount: event.totalUnreadCount,
        ownUser: event.me?.toJson(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get channel data by cid
  Future<ChannelState> getChannel(String cid) async {
    return await (select(channels)..where((c) => c.cid.equals(cid))).join([
      leftOuterJoin(users, channels.createdBy.equalsExp(users.id)),
    ]).map((row) {
      return _channelFromRow(
        row.readTable(channels),
        row.readTable(users),
      );
    }).getSingle();
  }

  /// Get list of channels by filter, sort and paginationParams
  Future<List<ChannelState>> getChannelStates({
    Map<String, dynamic> filter,
    List<SortOption> sort = const [],
    PaginationParams paginationParams,
  }) async {
    _logger.info('Get channel states');
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
        final userRow = row.readTable(users);
        final channelRow = row.readTable(channels);

        return _channelFromRow(channelRow, userRow);
      }).get();
    }));

    _logger.info('Got ${cachedChannels.length} channels');

    return cachedChannels;
  }

  /// Update list of channel queries
  /// If [clearQueryCache] is true before the insert
  /// the list of matching rows will be deleted
  void updateChannelQueries(
    Map<String, dynamic> filter,
    List<String> cids,
    bool clearQueryCache,
  ) {
    final hash = _computeHash(filter);
    if (clearQueryCache) {
      delete(channelQueries).where(
        (_ChannelQueries query) => query.queryHash.equals(hash),
      );
    }

    batch((batch) {
      batch.insertAll(
        channelQueries,
        cids.map((cid) {
          return ChannelQuery(
            queryHash: hash,
            channelCid: cid,
          );
        }).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Remove a message by message id
  Future<void> deleteMessages(List<String> messageIds) {
    return batch((batch) {
      batch.deleteWhere<_Reactions, _Reaction>(
        reactions,
        (r) => r.messageId.isIn(messageIds),
      );
      batch.deleteWhere<_Messages, _Message>(
        messages,
        (m) => m.id.isIn(messageIds),
      );
    });
  }

  /// Remove a message by message id
  Future<void> deleteChannelsMessages(List<String> cids) async {
    final List<String> messageIds = await (select(messages)
          ..where((m) => m.channelCid.isIn(cids)))
        .map((m) => m.id)
        .get();
    return batch((batch) {
      batch.deleteWhere<_Reactions, _Reaction>(
        reactions,
        (r) => r.messageId.isIn(messageIds),
      );
      batch.deleteWhere<_Messages, _Message>(
        messages,
        (m) => m.id.isIn(messageIds),
      );
    });
  }

  /// Remove a channel by cid
  Future<void> deleteChannels(List<String> cids) async {
    await deleteChannelsMessages(cids);
    return batch((batch) {
      batch.deleteWhere<_Members, _Member>(
        members,
        (m) => m.channelCid.isIn(cids),
      );
      batch.deleteWhere<_Reads, _Read>(
        reads,
        (r) => r.channelCid.isIn(cids),
      );
      batch.deleteWhere<_Channels, _Channel>(
        channels,
        (c) => c.cid.isIn(cids),
      );
    });
  }

  /// Update messages data from a list
  Future<void> updateMessages(
    List<Message> newMessages,
    String cid,
  ) {
    return batch((batch) {
      batch.insertAll(
        messages,
        newMessages.map(
          (m) {
            return _Message(
              id: m.id,
              attachmentJson: m.attachments != null
                  ? jsonEncode(m.attachments.map((a) => a.toJson()).toList())
                  : null,
              channelCid: cid,
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
              deletedAt: m.deletedAt,
              messageText: m.text,
            );
          },
        ).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Update single channel state
  Future<void> updateChannelState(ChannelState channelState) async {
    await updateChannelStates([channelState]);
  }

  /// Update list of channel states
  Future<void> updateChannelStates(List<ChannelState> channelStates) async {
    channelStates.forEach((cs) {
      updateMessages(
        cs.messages,
        cs.channel.cid,
      );
    });

    await batch((batch) {
      _updateReactions(batch, channelStates);

      _updateUsers(batch, channelStates);

      _updateReads(channelStates, batch);

      _updateMembers(channelStates, batch);

      _updateChannels(batch, channelStates);
    });
  }

  /// Get the info about channel threads
  Future<Map<String, List<Message>>> getChannelThreads(String cid) async {
    final rowMessages = await Future.wait(await (select(messages).join([
      leftOuterJoin(users, messages.userId.equalsExp(users.id)),
    ])
          ..where(messages.channelCid.equals(cid))
          ..where(isNotNull(messages.parentId))
          ..orderBy([
            OrderingTerm.asc(messages.createdAt),
          ]))
        .map(_messageFromJoinRow)
        .get());

    final threads = Map<String, List<Message>>();
    rowMessages.forEach((message) {
      if (threads.containsKey(message.parentId)) {
        threads[message.parentId].add(message);
      } else {
        threads[message.parentId] = [message];
      }
    });

    return threads;
  }

  Future<ChannelState> _channelFromRow(
    _Channel channelRow,
    _User userRow,
  ) async {
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
        config: ChannelConfig.fromJson(jsonDecode(channelRow.config)),
        createdBy: userRow != null ? _userFromUserRow(userRow) : null,
      ),
    );
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
          ..where(
              isNull(messages.parentId) | messages.showInChannel.equals(true))
          ..orderBy([
            OrderingTerm.asc(messages.createdAt),
          ]))
        .map(_messageFromJoinRow)
        .get());
    return rowMessages;
  }

  Future<Message> _messageFromJoinRow(row) async {
    final messageRow = row.readTable(messages);
    final userRow = row.readTable(users);

    final latestReactions = await _getLatestReactions(messageRow);
    final ownReactions = await _getOwnReactions(messageRow);

    return Message(
      latestReactions: latestReactions,
      ownReactions: ownReactions,
      attachments: messageRow.attachmentJson != null
          ? List<Map<String, dynamic>>.from(
                  jsonDecode(messageRow.attachmentJson))
              .map((j) => Attachment.fromJson(j))
              .toList()
          : null,
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
      deletedAt: messageRow.deletedAt,
    );
  }

  Future<List<Reaction>> _getLatestReactions(_Message messageRow) async {
    return await (select(reactions).join([
      leftOuterJoin(users, reactions.userId.equalsExp(users.id)),
    ])
          ..where(reactions.messageId.equals(messageRow.id))
          ..orderBy([OrderingTerm.asc(reactions.createdAt)]))
        .map((row) {
      final r = row.readTable(reactions);
      final u = row.readTable(users);
      return _reactionFromRow(r, u);
    }).get();
  }

  Reaction _reactionFromRow(_Reaction r, _User u) {
    return Reaction(
      extraData: r.extraData,
      type: r.type,
      createdAt: r.createdAt,
      userId: r.userId,
      user: _userFromUserRow(u),
      messageId: r.messageId,
      score: r.score,
    );
  }

  Future<List<Reaction>> _getOwnReactions(_Message messageRow) async {
    return await (select(reactions).join([
      leftOuterJoin(users, reactions.userId.equalsExp(users.id)),
    ])
          ..where(reactions.userId.equals(_userId))
          ..where(reactions.messageId.equals(messageRow.id))
          ..orderBy([OrderingTerm.asc(reactions.createdAt)]))
        .map((row) {
      final r = row.readTable(reactions);
      final u = row.readTable(users);
      return _reactionFromRow(r, u);
    }).get();
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

  void _updateChannels(Batch batch, List<ChannelState> channelStates) {
    batch.insertAll(
      channels,
      channelStates.map((cs) {
        final channel = cs.channel;
        return _channelDataFromChannelModel(channel);
      }).toList(),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _updateMembers(List<ChannelState> channelStates, Batch batch) {
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
  }

  void _updateReads(List<ChannelState> channelStates, Batch batch) {
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
  }

  void _updateUsers(Batch batch, List<ChannelState> channelStates) {
    batch.insertAll(
      users,
      channelStates
          .map((cs) => [
                if (cs.channel.createdBy != null)
                  _userDataFromUser(cs.channel.createdBy),
                if (cs.messages != null)
                  ...cs.messages
                      .map((m) => [
                            _userDataFromUser(m.user),
                            if (m.latestReactions != null)
                              ...m.latestReactions
                                  .map((r) => _userDataFromUser(r.user)),
                            if (m.ownReactions != null)
                              ...m.ownReactions
                                  .map((r) => _userDataFromUser(r.user)),
                          ])
                      .expand((v) => v),
                if (cs.read != null)
                  ...cs.read.map((r) => _userDataFromUser(r.user)),
                if (cs.members != null)
                  ...cs.members.map((m) => _userDataFromUser(m.user)),
              ])
          .expand((v) => v)
          .toList(),
      mode: InsertMode.insertOrReplace,
    );
  }

  void _updateReactions(Batch batch, List<ChannelState> channelStates) {
    batch.deleteWhere<_Reactions, _Reaction>(
      reactions,
      (r) => r.messageId.isIn(channelStates
          .map((cs) => cs.messages.map((m) => m.id))
          .expand((v) => v)),
    );
    final newReactions = channelStates
        .map((cs) => cs.messages.map((m) {
              final ownReactions = m.ownReactions?.map(
                    (r) => _reactionDataFromReaction(m, r),
                  ) ??
                  [];
              final latestReactions = m.latestReactions?.map(
                    (r) => _reactionDataFromReaction(m, r),
                  ) ??
                  [];
              return [
                ...ownReactions,
                ...latestReactions,
              ];
            }).expand((v) => v))
        .expand((v) => v);

    if (newReactions.isNotEmpty) {
      batch.insertAll(
        reactions,
        newReactions.toList(),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  _Reaction _reactionDataFromReaction(Message m, Reaction r) {
    return _Reaction(
      messageId: m.id,
      type: r.type,
      extraData: r.extraData,
      score: r.score,
      createdAt: r.createdAt,
      userId: r.user.id,
    );
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
      config: jsonEncode(channel.config?.toJson() ?? {}),
      type: channel.type,
      frozen: channel.frozen,
      createdAt: channel.createdAt,
      updatedAt: channel.updatedAt,
      memberCount: channel.memberCount,
      cid: channel.cid,
      lastMessageAt: channel.lastMessageAt,
      deletedAt: channel.deletedAt,
      extraData: channel.extraData,
      createdBy: channel.createdBy?.id,
    );
  }
}
