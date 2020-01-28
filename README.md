# Stream Chat Dart 

stream-chat-dart is the official Dart client for Stream Chat, a service for building chat applications.

You can sign up for a Stream account at https://getstream.io/chat/

This library is currently under development: you can subscribe for updates [here](https://github.com/GetStream/stream-chat-dart/issues/1)

## Getting started

You must add the library as a dependency to your project. At the moment the library is under development and there is not package published on pub.dev

```yaml
dependencies:
 stream_chat_dart:
   git: git://github.com/GetStream/stream-chat-dart.git
```
You should then run `flutter packages get`

## Example Project

There is a detailed example project in the `example` folder. You can directly run and play on it. 

## Setup API Client

First you need to instantiate a chat client. The Chat client will manage API call, event handling and manage the websocket connection to Stream Chat servers. You should only create the client once and re-use it across your application.

```dart
var client = Client("stream-chat-api-key");
```

### Logging

By default the Chat Client will write all messages with level Warn or Error to stdout.

#### Change Logging Level

During development you might want to enable more logging information, you can change the default log level when constructing the client.

```dart
var client = Client("stream-chat-api-key", logLevel: Level.INFO);
```

#### Custom Logger

You can handle the log messages directly instead of have them written to stdout, this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.

```dart
myLogHandlerFunction = (LogRecord record) {
  // do something with the record (ie. send it to Sentry or Fabric)
}

var client = Client("stream-chat-api-key", logHandlerFunction: myLogHandlerFunction);
```

### Watch models and generate JSON code

```bash
flutter pub run build_runner watch
```
