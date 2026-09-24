import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/utils/participant_list_parser.dart';
import 'package:noel_raffle/domain/entities/participant.dart';

void main() {
  test('reads one person per line with an optional email', () {
    expect(
      ParticipantListParser.parse(
        'Ayşe Yılmaz, ayse@mail.com\n'
        '  Burak  \n'
        '\n'
        'Cem;cem@mail.com\n'
        'سارة علي، sara@mail.com',
      ),
      const <Participant>[
        Participant(name: 'Ayşe Yılmaz', email: 'ayse@mail.com'),
        Participant(name: 'Burak'),
        Participant(name: 'Cem', email: 'cem@mail.com'),
        Participant(name: 'سارة علي', email: 'sara@mail.com'),
      ],
    );
  });

  test('keeps commas in names that are not followed by an email', () {
    expect(
      ParticipantListParser.parse('Kaya, Deniz'),
      const <Participant>[Participant(name: 'Kaya, Deniz')],
    );
  });

  test('skips repeated names, ignoring case', () {
    expect(
      ParticipantListParser.parse('Elif\nELIF\nelif, e@mail.com'),
      const <Participant>[Participant(name: 'Elif')],
    );
  });
}
