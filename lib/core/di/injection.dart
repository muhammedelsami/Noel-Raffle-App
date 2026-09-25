import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/raffle_cloud_data_source.dart';
import '../../data/datasources/raffle_local_data_source.dart';
import '../../data/repositories/online_raffle_repository_impl.dart';
import '../../data/repositories/raffle_history_repository_impl.dart';
import '../../domain/entities/raffle.dart';
import '../../domain/repositories/online_raffle_repository.dart';
import '../../domain/repositories/raffle_history_repository.dart';
import '../../domain/repositories/reminder_scheduler.dart';
import '../../domain/services/raffle_drawer.dart';
import '../../domain/usecases/create_raffle.dart';
import '../../domain/usecases/delete_raffle.dart';
import '../../domain/usecases/get_global_statistics.dart';
import '../../domain/usecases/get_raffle_history.dart';
import '../../domain/usecases/get_statistics.dart';
import '../../domain/usecases/lookup_result.dart';
import '../../domain/usecases/publish_raffle.dart';
import '../../domain/usecases/schedule_reminder.dart';
import '../../presentation/cubit/history/history_cubit.dart';
import '../../presentation/cubit/raffle_draw/raffle_draw_cubit.dart';
import '../../presentation/cubit/raffle_result/raffle_result_cubit.dart';
import '../../presentation/cubit/result_lookup/result_lookup_cubit.dart';
import '../../presentation/cubit/statistics/statistics_cubit.dart';
import '../l10n/locale_cubit.dart';
import '../notifications/local_reminder_scheduler.dart';
import '../review/review_prompter.dart';
import '../theme/theme_cubit.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Registers every dependency. Call once at startup before [runApp].
///
/// [cloudEnabled] is `true` only when Firebase initialized successfully;
/// otherwise the online repository reports itself unavailable and the UI
/// hides the online features.
Future<void> configureDependencies({bool cloudEnabled = false}) async {
  // External
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Data sources
  sl.registerLazySingleton<RaffleLocalDataSource>(
    () => RaffleLocalDataSourceImpl(sl()),
  );
  if (cloudEnabled) {
    sl.registerLazySingleton<RaffleCloudDataSource>(
      () => FirestoreRaffleCloudDataSource(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
      ),
    );
  }

  // Repositories
  sl
    ..registerLazySingleton<ReminderScheduler>(LocalReminderScheduler.new)
    ..registerLazySingleton<RaffleHistoryRepository>(
      () => RaffleHistoryRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OnlineRaffleRepository>(
      () => OnlineRaffleRepositoryImpl(
        cloudEnabled ? sl<RaffleCloudDataSource>() : null,
      ),
    );

  // Domain services & use cases
  sl
    ..registerLazySingleton<RaffleDrawer>(() => RaffleDrawer())
    ..registerLazySingleton<CreateRaffle>(() => CreateRaffle(sl(), sl(), sl()))
    ..registerLazySingleton<GetRaffleHistory>(() => GetRaffleHistory(sl()))
    ..registerLazySingleton<DeleteRaffle>(
      () => DeleteRaffle(sl(), sl(), sl()),
    )
    ..registerLazySingleton<ScheduleReminder>(() => ScheduleReminder(sl()))
    ..registerLazySingleton<PublishRaffle>(() => PublishRaffle(sl(), sl()))
    ..registerLazySingleton<LookupResult>(() => LookupResult(sl()))
    ..registerLazySingleton<GetStatistics>(() => GetStatistics(sl()))
    ..registerLazySingleton<GetGlobalStatistics>(
      () => GetGlobalStatistics(sl()),
    );

  // App-wide state
  sl
    ..registerLazySingleton<ReviewPrompter>(() => ReviewPrompter(sl()))
    ..registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()))
    ..registerLazySingleton<LocaleCubit>(() => LocaleCubit(sl()));

  // Per-screen cubits
  sl
    ..registerFactory<RaffleDrawCubit>(() => RaffleDrawCubit(sl()))
    ..registerFactoryParam<RaffleResultCubit, Raffle, void>(
      (Raffle raffle, _) => RaffleResultCubit(sl(), raffle),
    )
    ..registerFactory<HistoryCubit>(() => HistoryCubit(sl(), sl()))
    ..registerFactory<StatisticsCubit>(() => StatisticsCubit(sl(), sl()))
    ..registerFactory<ResultLookupCubit>(() => ResultLookupCubit(sl()));
}
