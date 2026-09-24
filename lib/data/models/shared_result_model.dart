import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/raffle_type.dart';
import '../../domain/entities/shared_result.dart';

/// Firestore form of a single participant's result (`results/{code}`).
///
/// Only what the participant needs to see is uploaded: never emails and
/// never other participants' results.
class SharedResultModel extends SharedResult {
  const SharedResultModel({
    required super.title,
    required super.type,
    required super.participantName,
    super.match,
    super.note,
  });

  /// Parses a Firestore document into the plain entity, so parsed values
  /// compare equal to entities built elsewhere (Equatable also compares
  /// runtime types).
  static SharedResult fromFirestore(Map<String, dynamic> data) {
    return SharedResult(
      title: data['title'] as String? ?? '',
      note: data['note'] as String? ?? '',
      type: RaffleType.fromName(data['type'] as String?),
      participantName: data['participantName'] as String? ?? '',
      match: data['match'] as String?,
    );
  }

  /// The result fields for [assignment]; the data source adds ownership and
  /// timestamp fields.
  static Map<String, dynamic> toFirestore(
    Raffle raffle,
    DrawAssignment assignment,
  ) {
    return <String, dynamic>{
      'title': raffle.title,
      'note': raffle.note,
      'type': raffle.type.name,
      'participantName': assignment.participant.name,
      'match': assignment.match,
    };
  }
}
