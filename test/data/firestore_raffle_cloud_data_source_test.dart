import 'dart:math';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/error/exceptions.dart';
import 'package:noel_raffle/data/datasources/raffle_cloud_data_source.dart';
import 'package:noel_raffle/domain/entities/draw_assignment.dart';
import 'package:noel_raffle/domain/entities/participant.dart';
import 'package:noel_raffle/domain/entities/raffle.dart';
import 'package:noel_raffle/domain/entities/raffle_config.dart';
import 'package:noel_raffle/domain/entities/raffle_type.dart';
import 'package:noel_raffle/domain/entities/shared_result.dart';
import 'package:noel_raffle/domain/entities/statistics.dart';
import 'package:noel_raffle/domain/services/share_code.dart';

void main() {
  final Raffle raffle = Raffle(
    id: 'r1',
    config: const RaffleConfig(
      title: 'Ofis',
      note: 'Bütçe 200 ₺',
      type: RaffleType.newYear,
    ),
    createdAt: DateTime(2026, 12, 20),
    assignments: const <DrawAssignment>[
      DrawAssignment(
        participant: Participant(name: 'Ayşe', email: 'a@x.com'),
        match: 'Burak',
      ),
      DrawAssignment(participant: Participant(name: 'Burak'), match: 'Cem'),
      DrawAssignment(
        participant: Participant(name: 'Cem', wish: 'Kitap, termos'),
        match: 'Ayşe',
      ),
    ],
  );

  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late FirestoreRaffleCloudDataSource dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    auth = MockFirebaseAuth();
    dataSource = FirestoreRaffleCloudDataSource(
      firestore: firestore,
      auth: auth,
      random: Random(7),
    );
  });

  test('publish uploads one private result per participant', () async {
    final Raffle published = await dataSource.publish(raffle);

    expect(published.isPublished, isTrue);
    final Set<String> codes =
        published.assignments.map((DrawAssignment a) => a.code!).toSet();
    expect(codes, hasLength(3));
    for (final String code in codes) {
      expect(ShareCode.normalize(code), code);
    }

    final Map<String, dynamic> doc = (await firestore
            .collection(FirestoreRaffleCloudDataSource.resultsCollection)
            .doc(published.assignments.first.code)
            .get())
        .data()!;
    expect(doc['participantName'], 'Ayşe');
    expect(doc['match'], 'Burak');
    expect(doc['ownerUid'], auth.currentUser!.uid);
    expect(doc.containsKey('email'), isFalse, reason: 'emails stay local');
    expect(doc.containsKey('matchWish'), isFalse,
        reason: 'Burak left no gift ideas');
  });

  test('lookup returns only the requested participant', () async {
    final Raffle published = await dataSource.publish(raffle);

    final SharedResult result =
        await dataSource.lookup(published.assignments[1].code!);
    expect(
      result,
      const SharedResult(
        title: 'Ofis',
        note: 'Bütçe 200 ₺',
        type: RaffleType.newYear,
        participantName: 'Burak',
        match: 'Cem',
        matchWish: 'Kitap, termos',
      ),
    );
  });

  test('lookup of an unknown code throws ResultNotFoundException', () {
    expect(
      dataSource.lookup('ABCDEFGH'),
      throwsA(isA<ResultNotFoundException>()),
    );
  });

  test('unpublish deletes the uploaded results', () async {
    final Raffle published = await dataSource.publish(raffle);
    await dataSource.unpublish(published);

    final int remaining = (await firestore
            .collection(FirestoreRaffleCloudDataSource.resultsCollection)
            .get())
        .size;
    expect(remaining, 0);
  });

  test('recordStatistics increments the global counters', () async {
    await dataSource.recordStatistics(raffle);
    await dataSource.recordStatistics(raffle);

    final Statistics stats = await dataSource.fetchStatistics();
    expect(stats.totalRaffleCount, 2);
    expect(stats.newYearRaffleCount, 2);
    expect(stats.giftRaffleCount, 0);
    expect(stats.participantCount, 6);
  });

  test('fetchStatistics is all zeros before anything was recorded', () async {
    final Statistics stats = await dataSource.fetchStatistics();
    expect(stats.totalRaffleCount, 0);
  });
}
