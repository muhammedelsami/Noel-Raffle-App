import '../../domain/entities/participant.dart';

/// Serializable view of [Participant] matching the backend payload shape.
class ParticipantModel extends Participant {
  const ParticipantModel({
    required super.name,
    required super.surname,
    required super.email,
  });

  factory ParticipantModel.fromEntity(Participant participant) {
    return ParticipantModel(
      name: participant.name,
      surname: participant.surname,
      email: participant.email,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'surname': surname,
        'email': email,
      };
}
