import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/exceptions.dart';

class RetryPolicy {
  RetryPolicy({
    this.shouldRetry,
    this.retryTimeout,
    this.attempt,
  });

  int attempt = 0;

  final bool Function(Client client, int attempt, ApiError apiError)
      shouldRetry;
  final Duration Function(Client client, int attempt, ApiError apiError)
      retryTimeout;

  RetryPolicy copyWith({
    bool Function(Client client, int attempt, ApiError apiError) shouldRetry,
    Duration Function(Client client, int attempt, ApiError apiError)
        retryTimeout,
    int attempt,
  }) =>
      RetryPolicy(
        retryTimeout: retryTimeout ?? this.retryTimeout,
        shouldRetry: shouldRetry ?? this.shouldRetry,
        attempt: attempt ?? this.attempt,
      );
}
