import '../../domain/entities/participant.dart';

/// Serializable view of [Participant]. The optional keys are only written
/// when a value was entered.
class ParticipantModel extends Participant {
  const ParticipantModel({required super.name, super.email, super.wish});

  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      name: participant.name,
      email: participant.email,
      wish: participant.wish,
    );
  }

  /// Parses into the plain entity, so parsed values compare equal to entities
  /// built elsewhere (Equatable also compares runtime types).
  static Participant fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'] as String,
      email: json['email'] as String?,
      wish: json['wish'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        if (hasEmail) 'email': email,
        if (hasWish) 'wish': wish,
      };
}
