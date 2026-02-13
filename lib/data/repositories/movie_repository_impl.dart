import 'package:dio/dio.dart';
import '../../core/errors/failure.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/logging/talker_service.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/entities/movie_search_result.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';
import '../models/movie_model.dart';
import '../stores/details_cache_store.dart';
import '../stores/favorites_store.dart';
import '../stores/search_history_store.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDatasource _remoteDatasource;
  final FavoritesStore _favoritesStore;
  final DetailsCacheStore _detailsCacheStore;
  final SearchHistoryStore _searchHistoryStore;
  final TalkerService _talkerService;
  final AppLocalizations _l10n;

  MovieRepositoryImpl({
    required MovieRemoteDatasource remoteDatasource,
    required FavoritesStore favoritesStore,
    required DetailsCacheStore detailsCacheStore,
    required SearchHistoryStore searchHistoryStore,
    required TalkerService talkerService,
    required AppLocalizations l10n,
  })  : _remoteDatasource = remoteDatasource,
        _favoritesStore = favoritesStore,
        _detailsCacheStore = detailsCacheStore,
        _searchHistoryStore = searchHistoryStore,
        _talkerService = talkerService,
        _l10n = l10n;

  @override
  Future<MovieSearchResult> searchMovies(String query, int page) async {
    try {
      _talkerService.info(_l10n.logSearchingMovies(query, page));

      final response = await _remoteDatasource.searchMovies(query, page);

      await _searchHistoryStore.addSearch(query);

      return response.toEntity();
    } on Failure {
      rethrow;
    } on DioException catch (e, st) {
      _talkerService.error(_l10n.logNetworkErrorSearch, st);
      throw _handleDioError(e);
    } catch (e, st) {
      _talkerService.error(_l10n.logUnknownErrorSearch, st);
      throw const UnknownFailure();
    }
  }

  @override
  Future<MovieDetails> getMovieDetails(String imdbId) async {
    try {
      _talkerService.info(_l10n.logFetchingDetails(imdbId));

      final response = await _remoteDatasource.getMovieDetails(imdbId);

      await _detailsCacheStore.saveDetails(response);
      _talkerService.info(_l10n.logSavedToCache(imdbId));

      return response.toEntity();
    } on Failure {
      rethrow;
    } on DioException catch (e, st) {
      _talkerService.error(_l10n.logNetworkErrorDetails, st);
      throw _handleDioError(e);
    } catch (e, st) {
      _talkerService.error(_l10n.logUnknownErrorDetails, st);
      throw const UnknownFailure();
    }
  }

  @override
  Future<MovieDetails?> getCachedDetails(String imdbId) async {
    try {
      final cached = await _detailsCacheStore.getDetails(imdbId);
      if (cached != null) {
        _talkerService.info(_l10n.logLoadedFromCacheId(imdbId));
        return cached.toEntity();
      }
      return null;
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedLoadCached, st);
      return null;
    }
  }

  @override
  Future<List<Movie>> getFavorites() async {
    try {
      final favorites = await _favoritesStore.getFavorites();
      return favorites.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedGetFavorites, st);
      return [];
    }
  }

  @override
  Future<void> addToFavorites(Movie movie) async {
    try {
      final model = MovieModel.fromEntity(movie);
      await _favoritesStore.addFavorite(model);
      _talkerService.info(_l10n.logFavoriteAdded(movie.title));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedAddFavorite, st);
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String imdbId) async {
    try {
      await _favoritesStore.removeFavorite(imdbId);
      _talkerService.info(_l10n.logFavoriteRemoved(imdbId));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedRemoveFavorite, st);
      rethrow;
    }
  }

  @override
  Future<bool> isFavorite(String imdbId) async {
    return _favoritesStore.isFavorite(imdbId);
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return const ApiFailure();
      case DioExceptionType.cancel:
        return const NetworkFailure();
      default:
        return const UnknownFailure();
    }
  }
}
