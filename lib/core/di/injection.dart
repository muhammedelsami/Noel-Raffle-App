import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/raffle_remote_data_source.dart';
import '../../data/datasources/statistics_remote_data_source.dart';
import '../../data/repositories/raffle_repository_impl.dart';
import '../../data/repositories/statistics_repository_impl.dart';
import '../../domain/repositories/raffle_repository.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/usecases/create_raffle.dart';
import '../../domain/usecases/get_statistics.dart';
import '../../presentation/cubit/raffle_submit/raffle_submit_cubit.dart';
import '../../presentation/cubit/statistics/statistics_cubit.dart';
import '../network/api_client.dart';
import '../theme/theme_cubit.dart';

/// Global service locator.
final GetIt sl = GetIt.instance;

/// Registers every dependency. Call once at startup before [runApp].
Future<void> configureDependencies() async {
  // External
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl
    ..registerSingleton<SharedPreferences>(prefs)
    ..registerLazySingleton<ApiClient>(ApiClient.new);

  // Data sources
  sl
    ..registerLazySingleton<RaffleRemoteDataSource>(
      () => RaffleRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<StatisticsRemoteDataSource>(
      () => StatisticsRemoteDataSourceImpl(sl()),
    );

  // Repositories
  sl
    ..registerLazySingleton<RaffleRepository>(
      () => RaffleRepositoryImpl(sl()),
    )
    ..registerLazySingleton<StatisticsRepository>(
      () => StatisticsRepositoryImpl(sl()),
    );

  // Use cases
  sl
    ..registerLazySingleton<CreateRaffle>(() => CreateRaffle(sl()))
    ..registerLazySingleton<GetStatistics>(() => GetStatistics(sl()));

  // App-wide state
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(sl()));

  // Per-screen cubits
  sl
    ..registerFactory<RaffleSubmitCubit>(() => RaffleSubmitCubit(sl()))
    ..registerFactory<StatisticsCubit>(() => StatisticsCubit(sl()));
}
