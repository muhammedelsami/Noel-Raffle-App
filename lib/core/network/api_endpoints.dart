/// Backend endpoints — kept identical to the original API contract.
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://www.noelraffle.com';

  static const String newYearRaffle = '$baseUrl/api/noel/raffle';
  static const String giftRaffle = '$baseUrl/api/gift/raffle';
  static const String statistics = '$baseUrl/api/stats/';
}
