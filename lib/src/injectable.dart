// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'package:movie_db_flutter_bloc_clean/src/data/datasources/remote/the_movie_db_service.dart';
import 'core/utils/network/endpoint.dart';
import 'data/datasources/local/app_cache.dart';
import 'injectable.config.dart' as config;

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies() => $initGetIt(getIt);

Future<void> $initGetIt(
  GetIt getIt, {
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
  final gh = GetItHelper(getIt, environment);

  gh.factory<TheMovieDbService>(
    () => TheMovieDbService(
      Dio(
        BaseOptions(
          baseUrl: EndPoints.theMoviebUrl,
          contentType: null,
          headers: {
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              // CloudFront blocks GET requests with Content-Type header
              if (options.method == 'GET') {
                options.headers.remove(Headers.contentTypeHeader);
                options.contentType = null;
              }
              handler.next(options);
            },
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            logPrint: (o) => debugPrint('[DIO] $o'),
          ),
        ),
      baseUrl: EndPoints.theMoviebUrl,
    ),
  );

  gh.factory<AppCache>(
    AppCache.new,
  );

  config.$initGetIt(getIt);
}
