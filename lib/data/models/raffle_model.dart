import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/gift.dart';
import '../../domain/entities/match_exclusion.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/raffle_config.dart';
import '../../domain/entities/raffle_type.dart';
import 'gift_model.dart';
import 'participant_model.dart';

/// JSON form of a [Raffle] as stored in the local history.
class RaffleModel extends Raffle {
  const RaffleModel({
    required super.id,
    required super.config,
    required super.createdAt,
    required super.assignments,
    super.gifts,
    super.exclusions,
  });

  factory RaffleModel.fromEntity(Raffle raffle) {
    return RaffleModel(
      id: raffle.id,
      config: raffle.config,
      createdAt: raffle.createdAt,
      assignments: raffle.assignments,
      gifts: raffle.gifts,
      exclusions: raffle.exclusions,
    );
  }

  /// Parses into the plain entity, so parsed values compare equal to entities
  /// built elsewhere (Equatable also compares runtime types).
  static Raffle fromJson(Map<String, dynamic> json) {
    return Raffle(
      id: json['id'] as String,
      config: RaffleConfig(
        title: json['title'] as String,
        note: json['note'] as String? ?? '',
        type: RaffleType.fromName(json['type'] as String?),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      assignments: (json['assignments'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (Map<String, dynamic> a) => DrawAssignment(
              participant: ParticipantModel.fromJson(a),
              match: a['match'] as String?,
              code: a['code'] as String?,
            ),
          )
          .toList(),
      gifts: (json['gifts'] as List<dynamic>? ?? const <dynamic>[])
          .cast<Map<String, dynamic>>()
          .map(GiftModel.fromJson)
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>? ?? const <dynamic>[])
          .cast<Map<String, dynamic>>()
          .map(
            (Map<String, dynamic> e) =>
                MatchExclusion(e['first'] as String, e['second'] as String),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'note': note,
        'type': type.name,
        'createdAt': createdAt.toIso8601String(),
        'gifts':
            gifts.map((Gift g) => GiftModel.fromEntity(g).toJson()).toList(),
        'assignments': assignments
            .map(
              (DrawAssignment a) => <String, dynamic>{
                ...ParticipantModel.fromEntity(a.participant).toJson(),
                'match': a.match,
                if (a.code != null) 'code': a.code,
              },
            )
            .toList(),
        if (exclusions.isNotEmpty)
          'exclusions': exclusions
              .map(
                (MatchExclusion e) => <String, dynamic>{
                  'first': e.first,
                  'second': e.second,
                },
              )
              .toList(),
      };
}
