import 'package:equatable/equatable.dart';

/// A new-year raffle rule: [first] and [second] must not draw each other, in
/// either direction (e.g. a couple). Names compare ignoring case, like
/// participant names.
class MatchExclusion extends Equatable {
  const MatchExclusion(this.first, this.second);

  final String first;
  final String second;

  bool involves(String name) => _same(first, name) || _same(second, name);

  /// Whether this rule forbids [giver] from buying a gift for [receiver].
  bool blocks(String giver, String receiver) =>
      (_same(first, giver) && _same(second, receiver)) ||
      (_same(first, receiver) && _same(second, giver));

  /// Whether [other] keeps the same two people apart, in any order.
  bool samePairAs(MatchExclusion other) => blocks(other.first, other.second);

  /// This rule after the participant [from] was renamed to [to].
  MatchExclusion renamed(String from, String to) => MatchExclusion(
        _same(first, from) ? to : first,
        _same(second, from) ? to : second,
      );

  static bool _same(String a, String b) => a.toLowerCase() == b.toLowerCase();

  @override
  List<Object?> get props => <Object?>[first, second];
}
