# Stream Chat Dart 
[![Pub](https://img.shields.io/pub/v/stream_chat.svg)](https://pub.dartlang.org/packages/stream_chat)
![](https://img.shields.io/badge/platform-flutter%20%7C%20flutter%20web-ff69b4.svg?style=flat-square)
![CI](https://github.com/GetStream/stream-chat-dart/workflows/CI/badge.svg?branch=master)
[![codecov](https://codecov.io/gh/GetStream/stream-chat-dart/branch/master/graph/badge.svg)](https://codecov.io/gh/GetStream/stream-chat-dart)

stream-chat-dart is the official Dart client for Stream Chat, a service for building chat applications. This library can be used on any Dart project and on both mobile and web apps with Flutter.

You can sign up for a Stream account at https://getstream.io/chat/

## Getting started

### Add dependency

```yaml
dependencies:
 stream_chat: ^0.1.21
```

You should then run `flutter packages get`

### Alpha version

Use version `^0.2.0-alpha` to use the latest available version.

Note that this is still an alpha version. There may be some bugs and the api can change in breaking ways.

Thanks to whoever tries these versions and reports bugs or suggestions.

## Example Project

There is a detailed Flutter example project in the `example` folder. You can directly run and play on it. 

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

### Offline storage 

By default the library saves information about channels and messages in a SQLite DB.

Set the property `persistenceEnabled` to false if you don't want to use the offline storage.

### Push notifications

To enable push notifications set the property `pushNotificationsEnabled` to `true`.

#### Android

Follow the guide at [this link](https://pub.dev/packages/firebase_messaging#android-integration) to setup Firebase for Android.

Set the notification template on your GetStream dashboard to be like this:
```json
template = {}

data template = {
    "message_id": "{{ message.id }}"
}
```

Create a Application.kt file to be like this:
```kotlin
class Application : FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
        PathProviderPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.pathprovider.PathProviderPlugin"))
        SharedPreferencesPlugin.registerWith(registry?.registrarFor(
                "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"))
        FlutterLocalNotificationsPlugin.registerWith(registry?.registrarFor(
                "com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"))
        FirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
    }
}
```

Update the `AndroidManifest.xml` file to set the application class:
```xml
...
    <uses-permission android:name="android.permission.INTERNET"/>
    <application
        android:name=".Application"
        android:label="example"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
...
```

#### iOS

Make sure you have correctly configured your app to support push notifications, and that you have generated certificate/token for sending pushes.

To enable offline notification support on iOS a guide will be released soon on our website.

## Contributing

### Code conventions

- Make sure that you run `dartfmt` before commiting your code
- Make sure all public methods and functions are well documented

### Running tests 

### Releasing a new version

- update the package version on `pubspec.yaml` and `version.dart`

- add a changelog entry on `CHANGELOG.md`

- run `flutter pub publish` to publish the package

### Watch models and generate JSON code

JSON serialization relies on code generation; make sure to keep that running while you make changes to the library

```bash
flutter pub run build_runner watch
```
