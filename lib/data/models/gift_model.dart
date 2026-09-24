import '../../domain/entities/gift.dart';

/// Serializable view of [Gift].
class GiftModel extends Gift {
  const GiftModel({required super.name, required super.count});

  factory GiftModel.fromEntity(Gift gift) {
    return GiftModel(name: gift.name, count: gift.count);
  }

  /// Parses into the plain entity, so parsed values compare equal to entities
  /// built elsewhere (Equatable also compares runtime types).
  static Gift fromJson(Map<String, dynamic> json) {
    return Gift(
      name: json['name'] as String,
      count: (json['count'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'count': count,
      };
}
