// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map json) {
  return SyncResponse()
    ..duration = json['duration'] as String
    ..events = (json['events'] as List)
        ?.map((e) => e == null
            ? null
            : Event.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

QueryChannelsResponse _$QueryChannelsResponseFromJson(Map json) {
  return QueryChannelsResponse()
    ..duration = json['duration'] as String
    ..channels = (json['channels'] as List)
        ?.map((e) => e == null ? null : ChannelState.fromJson(e as Map))
        ?.toList();
}

TranslateMessageResponse _$TranslateMessageResponseFromJson(Map json) {
  return TranslateMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : TranslatedMessage.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

QueryMembersResponse _$QueryMembersResponseFromJson(Map json) {
  return QueryMembersResponse()
    ..duration = json['duration'] as String
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

QueryUsersResponse _$QueryUsersResponseFromJson(Map json) {
  return QueryUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as List)
        ?.map((e) => e == null
            ? null
            : User.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

QueryReactionsResponse _$QueryReactionsResponseFromJson(Map json) {
  return QueryReactionsResponse()
    ..duration = json['duration'] as String
    ..reactions = (json['reactions'] as List)
        ?.map((e) => e == null
            ? null
            : Reaction.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

QueryRepliesResponse _$QueryRepliesResponseFromJson(Map json) {
  return QueryRepliesResponse()
    ..duration = json['duration'] as String
    ..messages = (json['messages'] as List)
        ?.map((e) => e == null
            ? null
            : Message.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

ListDevicesResponse _$ListDevicesResponseFromJson(Map json) {
  return ListDevicesResponse()
    ..duration = json['duration'] as String
    ..devices = (json['devices'] as List)
        ?.map((e) => e == null
            ? null
            : Device.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

SendFileResponse _$SendFileResponseFromJson(Map json) {
  return SendFileResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

SendImageResponse _$SendImageResponseFromJson(Map json) {
  return SendImageResponse()
    ..duration = json['duration'] as String
    ..file = json['file'] as String;
}

SendReactionResponse _$SendReactionResponseFromJson(Map json) {
  return SendReactionResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..reaction = json['reaction'] == null
        ? null
        : Reaction.fromJson((json['reaction'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

SetGuestUserResponse _$SetGuestUserResponseFromJson(Map json) {
  return SetGuestUserResponse()
    ..duration = json['duration'] as String
    ..accessToken = json['access_token'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

UpdateUsersResponse _$UpdateUsersResponseFromJson(Map json) {
  return UpdateUsersResponse()
    ..duration = json['duration'] as String
    ..users = (json['users'] as Map)?.map(
      (k, e) => MapEntry(
          k as String,
          e == null
              ? null
              : User.fromJson((e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                ))),
    );
}

UpdateMessageResponse _$UpdateMessageResponseFromJson(Map json) {
  return UpdateMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

SendMessageResponse _$SendMessageResponseFromJson(Map json) {
  return SendMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

GetMessageResponse _$GetMessageResponseFromJson(Map json) {
  return GetMessageResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

SearchMessagesResponse _$SearchMessagesResponseFromJson(Map json) {
  return SearchMessagesResponse()
    ..duration = json['duration'] as String
    ..results = (json['results'] as List)
        ?.map((e) => e == null ? null : GetMessageResponse.fromJson(e as Map))
        ?.toList();
}

GetMessagesByIdResponse _$GetMessagesByIdResponseFromJson(Map json) {
  return GetMessagesByIdResponse()
    ..duration = json['duration'] as String
    ..messages = (json['messages'] as List)
        ?.map((e) => e == null
            ? null
            : Message.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}

UpdateChannelResponse _$UpdateChannelResponseFromJson(Map json) {
  return UpdateChannelResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

InviteMembersResponse _$InviteMembersResponseFromJson(Map json) {
  return InviteMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

RemoveMembersResponse _$RemoveMembersResponseFromJson(Map json) {
  return RemoveMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

SendActionResponse _$SendActionResponseFromJson(Map json) {
  return SendActionResponse()
    ..duration = json['duration'] as String
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

AddMembersResponse _$AddMembersResponseFromJson(Map json) {
  return AddMembersResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

AcceptInviteResponse _$AcceptInviteResponseFromJson(Map json) {
  return AcceptInviteResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

RejectInviteResponse _$RejectInviteResponseFromJson(Map json) {
  return RejectInviteResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..message = json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ));
}

EmptyResponse _$EmptyResponseFromJson(Map json) {
  return EmptyResponse()..duration = json['duration'] as String;
}

ChannelStateResponse _$ChannelStateResponseFromJson(Map json) {
  return ChannelStateResponse()
    ..duration = json['duration'] as String
    ..channel = json['channel'] == null
        ? null
        : ChannelModel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          ))
    ..messages = (json['messages'] as List)
        ?.map((e) => e == null
            ? null
            : Message.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList()
    ..watcherCount = json['watcher_count'] as int
    ..read = (json['read'] as List)
        ?.map((e) => e == null
            ? null
            : Read.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList();
}
