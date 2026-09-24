import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/data/repositories/online_raffle_repository_impl.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_rules.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/repositories/raffle_history_repository.dart';
import 'package:noel_raffle/domain/services/raffle_drawer.dart';
import 'package:noel_raffle/domain/usecases/create_raffle.dart';
import 'package:noel_raffle/presentation/cubit/raffle_draw/raffle_draw_cubit.dart';

class InMemoryHistory implements RaffleHistoryRepository {
  final List<Raffle> saved = <Raffle>[];

  @override
  Future<List<Raffle>> getAll() async => saved;

  @override
  Future<void> save(Raffle raffle) async => saved.add(raffle);

  @override
  Future<void> delete(String id) async =>
      saved.removeWhere((Raffle r) => r.id == id);
}

void main() {
  const RaffleConfig config =
      RaffleConfig(title: 'Ofis', type: RaffleType.newYear);
  const List<Participant> three = <Participant>[
    Participant(name: 'A'),
    Participant(name: 'B'),
    Participant(name: 'C'),
  ];

  late InMemoryHistory history;

  RaffleDrawCubit build() {
    history = InMemoryHistory();
    return RaffleDrawCubit(
      CreateRaffle(
        RaffleDrawer(),
        history,
        const OnlineRaffleRepositoryImpl(null),
        clock: () => DateTime(2026, 12, 31),
      ),
    );
  }

  blocTest<RaffleDrawCubit, RaffleDrawState>(
    'draws and saves the raffle',
    build: build,
    act: (RaffleDrawCubit cubit) =>
        cubit.draw(config: config, participants: three),
    expect: () => <Matcher>[
      isA<RaffleDrawState>()
          .having((RaffleDrawState s) => s.isDrawing, 'isDrawing', isTrue),
      isA<RaffleDrawState>()
          .having((RaffleDrawState s) => s.status, 'status',
              RaffleDrawStatus.success)
          .having((RaffleDrawState s) => s.raffle?.assignments.length,
              'assignments', 3),
    ],
    verify: (_) {
      expect(history.saved, hasLength(1));
      expect(history.saved.single.createdAt, DateTime(2026, 12, 31));
    },
  );

  blocTest<RaffleDrawCubit, RaffleDrawState>(
    'reports the broken rule without saving',
    build: build,
    act: (RaffleDrawCubit cubit) =>
        cubit.draw(config: config, participants: three.take(2).toList()),
    expect: () => const <RaffleDrawState>[
      RaffleDrawState(status: RaffleDrawStatus.drawing),
      RaffleDrawState(
        status: RaffleDrawStatus.failure,
        violation: RaffleRuleViolation.notEnoughParticipants,
      ),
    ],
    verify: (_) => expect(history.saved, isEmpty),
  );
}
