import '../../core/constants/app_constants.dart';
import '../../domain/entities/gift.dart';

/// Serializable view of [Gift] matching the backend payload shape.
class GiftModel extends Gift {
  const GiftModel({required super.name, required super.count});

  factory GiftModel.fromEntity(Gift gift) {
    return GiftModel(name: gift.name, count: gift.count);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'giftId': AppConstants.defaultGiftId,
        'name': name,
        'count': count,
      };
}
