export 'shared/unsupported_db.dart'
    if (dart.library.io) 'src/db/shared/native_db.dart' // implementation using dart:io
    if (dart.library.html) 'src/db/shared/web_db.dart'; // implementation using dart:html|js
