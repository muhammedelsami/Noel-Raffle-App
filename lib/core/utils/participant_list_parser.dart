import '../../domain/entities/participant.dart';
import '../constants/app_constants.dart';
import 'validators.dart';

/// Turns pasted text into participants: one per line, optionally followed
/// by an email after a comma (Latin or Arabic), semicolon or tab
/// ("Ayşe Yılmaz, a@x.com").
/// Blank lines and repeated names (ignoring case) are skipped.
abstract final class ParticipantListParser {
  static final RegExp _separator = RegExp('[,;\t\u060C]');

  static List<Participant> parse(String text) {
    final List<Participant> people = <Participant>[];
    final Set<String> seen = <String>{};
    for (final String line in text.split(RegExp(r'\r?\n'))) {
      final Participant? participant = _parseLine(line.trim());
      if (participant == null) continue;
      if (seen.add(participant.name.toLowerCase())) people.add(participant);
    }
    return people;
  }

  static Participant? _parseLine(String line) {
    if (line.isEmpty) return null;
    final int split = line.lastIndexOf(_separator);
    if (split > 0) {
      final String email = line.substring(split + 1).trim();
      final String name = line.substring(0, split).trim();
      if (Validators.isValidEmail(email) && name.isNotEmpty) {
        return Participant(name: _limit(name), email: email);
      }
    }
    // Commas in a line without an email belong to the name.
    return Participant(name: _limit(line));
  }

  static String _limit(String name) => name.length <= AppConstants.maxNameLength
      ? name
      : name.substring(0, AppConstants.maxNameLength).trim();
}
