/// Thrown when an online feature is used while Firebase is not configured.
class CloudUnavailableException implements Exception {
  const CloudUnavailableException();

  @override
  String toString() => 'CloudUnavailableException';
}

/// Thrown when a cloud call fails (no connection, timeout, permission denied).
class CloudException implements Exception {
  const CloudException(this.message);

  final String message;

  @override
  String toString() => 'CloudException: $message';
}

/// Thrown when no online result exists for a share code.
class ResultNotFoundException implements Exception {
  const ResultNotFoundException();

  @override
  String toString() => 'ResultNotFoundException';
}
