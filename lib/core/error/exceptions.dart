/// Thrown by data sources when a remote call fails.
class ServerException implements Exception {
  const ServerException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Thrown when the device cannot reach the network.
class NetworkException implements Exception {
  const NetworkException([this.message = 'Ağ bağlantısı kurulamadı.']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
