import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/data/datasources/raffle_local_data_source.dart';
import 'package:noel_raffle/data/repositories/raffle_history_repository_impl.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

Raffle raffle(String id, DateTime createdAt) => Raffle(
      id: id,
      config: RaffleConfig(title: 'R$id', type: RaffleType.newYear),
      createdAt: createdAt,
      assignments: const <DrawAssignment>[
        DrawAssignment(participant: Participant(name: 'A'), match: 'B'),
      ],
    );

void main() {
  late RaffleHistoryRepositoryImpl repository;

  Future<void> setUpWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    repository = RaffleHistoryRepositoryImpl(RaffleLocalDataSourceImpl(prefs));
  }

  test('saves raffles and lists them newest first', () async {
    await setUpWith(<String, Object>{});
    await repository.save(raffle('old', DateTime(2025)));
    await repository.save(raffle('new', DateTime(2026)));

    final List<Raffle> all = await repository.getAll();
    expect(all.map((Raffle r) => r.id), <String>['new', 'old']);
  });

  test('save replaces a raffle with the same id', () async {
    await setUpWith(<String, Object>{});
    final Raffle original = raffle('x', DateTime(2026));
    await repository.save(original);
    final Raffle published = original.copyWith(
      assignments: <DrawAssignment>[
        original.assignments.single.withCode('ABCDEFGH'),
      ],
    );
    await repository.save(published);

    final List<Raffle> all = await repository.getAll();
    expect(all, <Raffle>[published]);
    expect(all.single.isPublished, isTrue);
  });

  test('delete removes only the given raffle', () async {
    await setUpWith(<String, Object>{});
    await repository.save(raffle('a', DateTime(2025)));
    await repository.save(raffle('b', DateTime(2026)));
    await repository.delete('a');

    expect((await repository.getAll()).map((Raffle r) => r.id), <String>['b']);
  });

  test('corrupt storage reads as an empty history', () async {
    await setUpWith(<String, Object>{
      RaffleLocalDataSourceImpl.storageKey: 'not json',
    });
    expect(await repository.getAll(), isEmpty);
  });
}
