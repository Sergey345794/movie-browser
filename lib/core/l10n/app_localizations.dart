import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Load localization without context (for early initialization like main.dart)
  static Future<AppLocalizations> loadWithoutContext() async {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final languageCode = ['en', 'he'].contains(systemLocale.languageCode)
        ? systemLocale.languageCode
        : 'en';
    final locale = Locale(languageCode);
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  Future<bool> load() async {
    final jsonString =
        await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? key;
  }

  String get appName => translate('app_name');
  String get search => translate('search');
  String get favorites => translate('favorites');
  String get movieDetails => translate('movie_details');
  String get searchMovies => translate('search_movies');
  String get searchHint => translate('search_hint');
  String get searching => translate('searching');
  String get loading => translate('loading');
  String get tryAgain => translate('try_again');
  String get addToFavorites => translate('add_to_favorites');
  String get removeFromFavorites => translate('remove_from_favorites');
  String get noResultsFound => translate('no_results_found');
  String get tooManyResults => translate('too_many_results');
  String get noFavorites => translate('no_favorites');
  String get noHistory => translate('no_history');
  String get searchHistory => translate('search_history');
  String get recentSearch => translate('recent_search');
  String get clearHistory => translate('clear_history');
  String get clearCache => translate('clear_cache');
  String get year => translate('year');
  String get rated => translate('rated');
  String get released => translate('released');
  String get runtime => translate('runtime');
  String get genre => translate('genre');
  String get director => translate('director');
  String get writer => translate('writer');
  String get actors => translate('actors');
  String get plot => translate('plot');
  String get language => translate('language');
  String get country => translate('country');
  String get awards => translate('awards');
  String get imdbRating => translate('imdb_rating');
  String get networkError => translate('network_error');
  String get serverError => translate('server_error');
  String get apiError => translate('api_error');
  String get errorOccurred => translate('error_occurred');
  String get movieNotFound => translate('movie_not_found');
  String get usingCachedData => translate('using_cached_data');
  String get loadedFromCache => translate('loaded_from_cache');
  String get cacheFallback => translate('cache_fallback');
  String get apiKeyRequired => translate('api_key_required');
  String get apiKeyInstructions => translate('api_key_instructions');
  String get moviePosterNotAvailable => translate('movie_poster_not_available');
  String get moviePoster => translate('movie_poster');

  String imdbRatingYear(String rating, String year) {
    return translate('imdb_rating_year')
        .replaceAll('{rating}', rating)
        .replaceAll('{year}', year);
  }

  String moviePosterLabel(String title) {
    return translate('movie_poster_label').replaceAll('{title}', title);
  }

  // Logging messages
  String get logAppStarting => translate('log_app_starting');

  String logApiKeyConfigured(bool configured) {
    return translate('log_api_key_configured')
        .replaceAll('{configured}', configured.toString());
  }

  String get logInvalidApiKey => translate('log_invalid_api_key');
  String get logHiveInitialized => translate('log_hive_initialized');
  String get logHiveInitFailed => translate('log_hive_init_failed');

  String logBoxOpened(String name) {
    return translate('log_box_opened').replaceAll('{name}', name);
  }

  String logBoxOpenFailed(String name) {
    return translate('log_box_open_failed').replaceAll('{name}', name);
  }

  String logBoxClosed(String name) {
    return translate('log_box_closed').replaceAll('{name}', name);
  }

  String logBoxCloseFailed(String name) {
    return translate('log_box_close_failed').replaceAll('{name}', name);
  }

  String logBoxDeleted(String name) {
    return translate('log_box_deleted').replaceAll('{name}', name);
  }

  String logBoxDeleteFailed(String name) {
    return translate('log_box_delete_failed').replaceAll('{name}', name);
  }

  String logSearchingMovies(String query, int page) {
    return translate('log_searching_movies')
        .replaceAll('{query}', query)
        .replaceAll('{page}', page.toString());
  }

  String get logNetworkErrorSearch => translate('log_network_error_search');
  String get logUnknownErrorSearch => translate('log_unknown_error_search');

  String logFetchingDetails(String imdbId) {
    return translate('log_fetching_details').replaceAll('{imdbId}', imdbId);
  }

  String logSavedToCache(String imdbId) {
    return translate('log_saved_to_cache').replaceAll('{imdbId}', imdbId);
  }

  String get logNetworkErrorDetails => translate('log_network_error_details');
  String get logUnknownErrorDetails => translate('log_unknown_error_details');

  String logLoadedFromCacheId(String imdbId) {
    return translate('log_loaded_from_cache').replaceAll('{imdbId}', imdbId);
  }

  String get logFailedLoadCached => translate('log_failed_load_cached');
  String get logFailedGetFavorites => translate('log_failed_get_favorites');

  String logFavoriteAdded(String title) {
    return translate('log_favorite_added').replaceAll('{title}', title);
  }

  String get logFailedAddFavorite => translate('log_failed_add_favorite');

  String logFavoriteRemoved(String imdbId) {
    return translate('log_favorite_removed').replaceAll('{imdbId}', imdbId);
  }

  String get logFailedRemoveFavorite => translate('log_failed_remove_favorite');

  String logLoadedHistoryItems(int count) {
    return translate('log_loaded_history_items')
        .replaceAll('{count}', count.toString());
  }

  String get logFailedLoadHistory => translate('log_failed_load_history');

  String logAddedToHistory(String query) {
    return translate('log_added_to_history').replaceAll('{query}', query);
  }

  String get logFailedAddHistory => translate('log_failed_add_history');

  String logRemovedFromHistory(String query) {
    return translate('log_removed_from_history').replaceAll('{query}', query);
  }

  String get logFailedRemoveHistory => translate('log_failed_remove_history');
  String get logHistoryCleared => translate('log_history_cleared');
  String get logFailedClearHistory => translate('log_failed_clear_history');

  String logLoadedFavorites(int count) {
    return translate('log_loaded_favorites')
        .replaceAll('{count}', count.toString());
  }

  String get logFailedLoadFavorites => translate('log_failed_load_favorites');

  String logAddedToFavorites(String title) {
    return translate('log_added_to_favorites').replaceAll('{title}', title);
  }

  String logRemovedFromFavorites(String imdbId) {
    return translate('log_removed_from_favorites')
        .replaceAll('{imdbId}', imdbId);
  }

  String logCacheMiss(String imdbId) {
    return translate('log_cache_miss').replaceAll('{imdbId}', imdbId);
  }

  String logCacheHit(String imdbId) {
    return translate('log_cache_hit').replaceAll('{imdbId}', imdbId);
  }

  String get logFailedLoadCache => translate('log_failed_load_cache');

  String logSavedToCacheTitle(String title) {
    return translate('log_saved_to_cache_title').replaceAll('{title}', title);
  }

  String get logFailedSaveCache => translate('log_failed_save_cache');
  String get logCacheCleared => translate('log_cache_cleared');
  String get logFailedClearCache => translate('log_failed_clear_cache');

  String logApiRequest(String method, String uri) {
    return translate('log_api_request')
        .replaceAll('{method}', method)
        .replaceAll('{uri}', uri);
  }

  String logSearchQuery(String query) {
    return translate('log_search_query').replaceAll('{query}', query);
  }

  String logPagination(String page) {
    return translate('log_pagination').replaceAll('{page}', page);
  }

  String logApiResponse(int statusCode, String uri) {
    return translate('log_api_response')
        .replaceAll('{statusCode}', statusCode.toString())
        .replaceAll('{uri}', uri);
  }

  String logApiErrorReturned(String error) {
    return translate('log_api_error_returned').replaceAll('{error}', error);
  }

  String logApiError(String errorType, String uri) {
    return translate('log_api_error')
        .replaceAll('{errorType}', errorType)
        .replaceAll('{uri}', uri);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'he'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
