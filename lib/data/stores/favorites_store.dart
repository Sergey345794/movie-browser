import 'package:hive/hive.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/logging/talker_service.dart';
import '../models/movie_model.dart';

class FavoritesStore {
  final Box<Map> _box;
  final TalkerService _talkerService;
  final AppLocalizations _l10n;

  FavoritesStore({
    required Box<Map> box,
    required TalkerService talkerService,
    required AppLocalizations l10n,
  })  : _box = box,
        _talkerService = talkerService,
        _l10n = l10n;

  Future<List<MovieModel>> getFavorites() async {
    try {
      final favorites = _box.values
          .map((json) => MovieModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      _talkerService.debug(_l10n.logLoadedFavorites(favorites.length));
      return favorites;
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedLoadFavorites, st);
      return [];
    }
  }

  Future<void> addFavorite(MovieModel movie) async {
    try {
      await _box.put(movie.imdbId, movie.toJson());
      _talkerService.info(_l10n.logAddedToFavorites(movie.title));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedAddFavorite, st);
      rethrow;
    }
  }

  Future<void> removeFavorite(String imdbId) async {
    try {
      await _box.delete(imdbId);
      _talkerService.info(_l10n.logRemovedFromFavorites(imdbId));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedRemoveFavorite, st);
      rethrow;
    }
  }

  bool isFavorite(String imdbId) {
    return _box.containsKey(imdbId);
  }
}
