import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/draw_assignment.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/entities/shared_result.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/services/share_code.dart';
import '../models/shared_result_model.dart';
import '../models/statistics_model.dart';

/// Cloud storage for published results and global counters.
abstract interface class RaffleCloudDataSource {
  Future<Raffle> publish(Raffle raffle);

  Future<void> unpublish(Raffle raffle);

  Future<SharedResult> lookup(String code);

  Future<void> recordStatistics(Raffle raffle);

  Future<Statistics> fetchStatistics();
}

/// Firestore implementation. Writes are made as an anonymous Firebase user so
/// the security rules (`firebase/firestore.rules`) can tie each result to the
/// device that published it.
class FirestoreRaffleCloudDataSource implements RaffleCloudDataSource {
  FirestoreRaffleCloudDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    Random? random,
    this.timeout = const Duration(seconds: 20),
  })  : _firestore = firestore,
        _auth = auth,
        _random = random ?? Random.secure();

  static const String resultsCollection = 'results';
  static const String statsCollection = 'stats';
  static const String globalStatsDoc = 'global';

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Random _random;

  /// Upper bound for a cloud call; Firestore otherwise waits indefinitely for
  /// a connection before completing a write.
  final Duration timeout;

  CollectionReference<Map<String, dynamic>> get _results =>
      _firestore.collection(resultsCollection);

  DocumentReference<Map<String, dynamic>> get _stats =>
      _firestore.collection(statsCollection).doc(globalStatsDoc);

  @override
  Future<Raffle> publish(Raffle raffle) {
    return _guard(() async {
      final String uid = await _ownerUid();
      final WriteBatch batch = _firestore.batch();
      final Set<String> used = <String>{};
      final List<DrawAssignment> assignments = <DrawAssignment>[];
      for (final DrawAssignment assignment in raffle.assignments) {
        String code;
        do {
          code = ShareCode.generate(_random);
        } while (!used.add(code));
        batch.set(_results.doc(code), <String, dynamic>{
          ...SharedResultModel.toFirestore(raffle, assignment),
          'raffleId': raffle.id,
          'ownerUid': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        assignments.add(assignment.withCode(code));
      }
      await batch.commit();
      return raffle.copyWith(assignments: assignments);
    });
  }

  @override
  Future<void> unpublish(Raffle raffle) {
    return _guard(() async {
      await _ownerUid();
      final WriteBatch batch = _firestore.batch();
      for (final DrawAssignment assignment in raffle.assignments) {
        final String? code = assignment.code;
        if (code != null) batch.delete(_results.doc(code));
      }
      await batch.commit();
    });
  }

  @override
  Future<SharedResult> lookup(String code) {
    return _guard(() async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _results.doc(code).get();
      final Map<String, dynamic>? data = snapshot.data();
      if (data == null) throw const ResultNotFoundException();
      return SharedResultModel.fromFirestore(data);
    });
  }

  @override
  Future<void> recordStatistics(Raffle raffle) {
    return _guard(() async {
      await _ownerUid();
      await _stats.set(
        <String, dynamic>{
          for (final MapEntry<String, int> entry
              in StatisticsModel.deltaFor(raffle).entries)
            entry.key: FieldValue.increment(entry.value),
        },
        SetOptions(merge: true),
      );
    });
  }

  @override
  Future<Statistics> fetchStatistics() {
    return _guard(() async {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _stats.get();
      return StatisticsModel.fromJson(
        snapshot.data() ?? const <String, dynamic>{},
      );
    });
  }

  /// Signs in anonymously on first use; the session persists across launches.
  Future<String> _ownerUid() async {
    final User? current = _auth.currentUser;
    if (current != null) return current.uid;
    final UserCredential credential = await _auth.signInAnonymously();
    return credential.user!.uid;
  }

  /// Applies [timeout] and maps Firebase errors to [CloudException].
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(timeout);
    } on FirebaseException catch (e) {
      throw CloudException(e.message ?? e.code);
    } on TimeoutException {
      throw const CloudException('timeout');
    }
  }
}
