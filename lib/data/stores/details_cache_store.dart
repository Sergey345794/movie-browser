import 'package:hive/hive.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/logging/talker_service.dart';
import '../models/movie_details_model.dart';

class DetailsCacheStore {
  final Box<Map> _box;
  final TalkerService _talkerService;
  final AppLocalizations _l10n;

  DetailsCacheStore({
    required Box<Map> box,
    required TalkerService talkerService,
    required AppLocalizations l10n,
  })  : _box = box,
        _talkerService = talkerService,
        _l10n = l10n;

  Future<MovieDetailsModel?> getDetails(String imdbId) async {
    try {
      final json = _box.get(imdbId);
      if (json == null) {
        _talkerService.debug(_l10n.logCacheMiss(imdbId));
        return null;
      }

      _talkerService.debug(_l10n.logCacheHit(imdbId));
      return MovieDetailsModel.fromJson(Map<String, dynamic>.from(json));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedLoadCache, st);
      return null;
    }
  }

  Future<void> saveDetails(MovieDetailsModel details) async {
    try {
      await _box.put(details.imdbId, details.toJson());
      _talkerService.info(_l10n.logSavedToCacheTitle(details.title));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedSaveCache, st);
    }
  }

  Future<void> clearCache() async {
    try {
      await _box.clear();
      _talkerService.info(_l10n.logCacheCleared);
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedClearCache, st);
    }
  }
}
