// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Project imports:
import 'package:movie_db_flutter_bloc_clean/src/core/request/home_request/get_home_request.dart';
import 'package:movie_db_flutter_bloc_clean/src/core/resource/data_source.dart';
import 'package:movie_db_flutter_bloc_clean/src/injectable.dart';
import 'package:movie_db_flutter_bloc_clean/src/presentation/home/bloc/home_bloc.dart';
import 'package:movie_db_flutter_bloc_clean/src/presentation/home/view/home_page.dart';
import '../../../domain/use_cases/mock_home_repository.dart';
import '../../../pump_app.dart';

Future<void> main() async {
  late HomeBloc homeBloc;
  late MockGetUpcomingUseCase mockGetUpcomingUseCase;
  late MockGetTopRatedUseCase mockGetTopRatedUseCase;
  late MockGetPopularUseCase mockGetPopularUseCase;
  late MockCheckFavoriteHomeUseCase mockCheckFavoriteHomeUseCase;
  late MockRemoveFavoriteHomeUseCase mockRemoveFavoriteHomeUseCase;
  late MockAddFavoriteHomeUseCase mockAddFavoriteHomeUseCase;
  setUpAll(() async {
    registerFallbackValue(GetMovieRequest('', 0, ''));
    configureDependencies();
    mockGetUpcomingUseCase = MockGetUpcomingUseCase();
    mockGetTopRatedUseCase = MockGetTopRatedUseCase();
    mockGetPopularUseCase = MockGetPopularUseCase();
    mockCheckFavoriteHomeUseCase = MockCheckFavoriteHomeUseCase();
    mockRemoveFavoriteHomeUseCase = MockRemoveFavoriteHomeUseCase();
    mockAddFavoriteHomeUseCase = MockAddFavoriteHomeUseCase();
    when(() => mockGetUpcomingUseCase.call(params: any(named: 'params')))
        .thenAnswer((_) async => const DataSuccess(null));
    when(() => mockGetTopRatedUseCase.call(params: any(named: 'params')))
        .thenAnswer((_) async => const DataSuccess(null));
    when(() => mockGetPopularUseCase.call(params: any(named: 'params')))
        .thenAnswer((_) async => const DataSuccess(null));
    homeBloc = HomeBloc(
      mockGetUpcomingUseCase,
      mockGetTopRatedUseCase,
      mockGetPopularUseCase,
      mockCheckFavoriteHomeUseCase,
      mockRemoveFavoriteHomeUseCase,
      mockAddFavoriteHomeUseCase,
    );
    await getIt.unregister<HomeBloc>();
    getIt.registerFactory<HomeBloc>(() => homeBloc);
  });

  group('HomePage', () {
    testWidgets('renders HomeView', (final tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.byType(HomeView), findsOneWidget);
    });
  });
}
