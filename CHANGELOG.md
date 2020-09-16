## 0.2.4+1

- Do not resync if there is no channel in offlinestorage

## 0.2.4

- Add null-safety to ws disconnect
- Add pagination parameters to queryUsers request

## 0.2.3+3

- Fix reaction add/remove logic

## 0.2.3+2

- Skip system messages during unreadCount computation

## 0.2.3+1

- Removed moor_ffi from dependencies in favor of moor/ffi

## 0.2.3

- Fix reject invite payload

- Add multi-tenant properties to channel and user

## 0.2.2+1

- Fix queryChannels payload

## 0.2.2

- Fix add/remove/invite members api calls

## 0.2.1

- Add `isMutedStream` to `Channel`
- Add `isGroup` to `Channel`
- Add `isDistinct` to `Channel`

## 0.2.0+2

- Fix search messages response class

## 0.2.0+1

- Fix offline members update
- Add channel mutes
- Fix default channel sort

## 0.2.0

- Add `lastMessage` getter to Channel.state
- Add `isSystem` property to Message
- Incremental websocket reconnection timeout
- Add translate message api call
- Add queryMembers api call
- Add user list to client state
- Synchronize channel members status
- Add offline storage
- Add push notifications helper functions

## 0.2.0-alpha+23

- Add `lastMessage` getter to `Channel.state`

## 0.2.0-alpha+22

- Add `isSystem` property to Message

## 0.2.0-alpha+21

- Incremental websocket reconnection timeout

## 0.2.0-alpha+20

- More robust offline storage insertions

## 0.2.0-alpha+19

- Add translate message api call
- Add queryMembers api call

## 0.2.0-alpha+18

- Revert moor_ffi version to 0.5.0

## 0.2.0-alpha+17

- Add user list to client

- Synchronize channel members status

## 0.2.0-alpha+16

- Try QueryChannels when `resync` endpoint returns an error

## 0.2.0-alpha+15

- Fix receiving reactions

## 0.2.0-alpha+14

- Avoid sending local event for optimistic updates

## 0.2.0-alpha+13

- Fix offline on app first start up

## 0.2.0-alpha+12

- Fix retry mechanism in threads
- Fix delete channel query

## 0.2.0-alpha+9

- Add retry mechanism and retry queue

## 0.2.0-alpha+8

- Add copyWith to Attachment

## 0.2.0-alpha+7

- Add channel deleted/updated event handling

## 0.2.0-alpha+6

- Align with stable release

## 0.2.0-alpha+5

- Rename client parameters

## 0.2.0-alpha+3

- Remove dependencies on notification service

- Expose some helping method for integrate offline storage with push notifications

## 0.2.0-alpha+2

- Fix unread count

## 0.2.0-alpha

- Offline storage

- Push notifications

- Minor bug fixes

## 0.1.30

- Add silent property to message

## 0.1.29

- Fix read event handling

## 0.1.28

- Fix bug clearing members when receiving a message

## 0.1.27

- Update dependencies

## 0.1.26

- Remove wrong `members` property from `ChannelModel`

## 0.1.25

- Fix online status

## 0.1.24

- Fix unread count

## 0.1.22

- Add mute/unmute channel

## 0.1.20

- Fix channel query path without id

## 0.1.19

- Fix loading message replies

## 0.1.18

- Export dio error

## 0.1.17

- Ignore current user typing events

- Add event types

## 0.1.16

- Fix message update

## 0.1.15

- Fix mentions handling

## 0.1.14

- Handle message modification and commands

## 0.1.13

- Add message.updated event handling

## 0.1.12

- Add export multipart_file from dio

## 0.1.11

- Add channel config checks

## 0.1.10

- Rename Channel.channelClients to channels

## 0.1.9

- Fix channel update on message delete

## 0.1.8

- Add delete message handling

## 0.1.7

- Add reaction handling

## 0.1.6

- Add initialized completer

- Update example

## 0.1.5

- Add `ClientState` and `ChannelClientState` classes to handle channel state updates using events

- Update example supporting threads

## 0.1.4

- Update some api with wrong or incomplete signatures

- Add documentation for public apis

## 0.1.2

- add websocket reconnection logic

- add token expiration mechanism

## 0.1.1

- add typing events handling

## 0.1.0

- a better example can be found in the example/ directory

- fix some api calls and add missing one

## 0.0.2

- first beta version