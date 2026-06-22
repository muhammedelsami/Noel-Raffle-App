import '../../domain/entities/gift.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/raffle_config.dart';
import 'gift_model.dart';
import 'participant_model.dart';

/// Builds the JSON body sent when creating a raffle. The `gifts` key is only
/// included when gifts are present, mirroring the original API contract.
class RaffleRequestModel {
  const RaffleRequestModel({
    required this.config,
    required this.participants,
    this.gifts = const <Gift>[],
  });

  final RaffleConfig config;
  final List<Participant> participants;
  final List<Gift> gifts;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> body = <String, dynamic>{
      'title': config.title,
      'group': config.group,
      'sector': config.sector,
      'participants': participants
          .map((Participant p) => ParticipantModel.fromEntity(p).toJson())
          .toList(),
    };

    if (gifts.isNotEmpty) {
      body['gifts'] =
          gifts.map((Gift g) => GiftModel.fromEntity(g).toJson()).toList();
    }

    return body;
  }
}
