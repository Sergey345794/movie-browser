import 'package:hive/hive.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/logging/talker_service.dart';

class SearchHistoryStore {
  final Box<String> _box;
  final TalkerService _talkerService;
  final AppLocalizations _l10n;
  static const int maxHistory = 20;

  SearchHistoryStore({
    required Box<String> box,
    required TalkerService talkerService,
    required AppLocalizations l10n,
  })  : _box = box,
        _talkerService = talkerService,
        _l10n = l10n;

  Future<List<String>> getHistory() async {
    try {
      final history = _box.values.toList();
      _talkerService.debug(_l10n.logLoadedHistoryItems(history.length));
      return history;
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedLoadHistory, st);
      return [];
    }
  }

  Future<void> addSearch(String query) async {
    try {
      final history = _box.values.toList();

      if (history.contains(query)) {
        final key = _box.keys.firstWhere(
          (k) => _box.get(k) == query,
        );
        await _box.delete(key);
      }

      await _box.add(query);

      if (_box.length > maxHistory) {
        await _box.deleteAt(0);
      }

      _talkerService.info(_l10n.logAddedToHistory(query));
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedAddHistory, st);
    }
  }

  Future<void> removeSearch(String query) async {
    try {
      final key = _box.keys.firstWhere(
        (k) => _box.get(k) == query,
        orElse: () => null,
      );

      if (key != null) {
        await _box.delete(key);
        _talkerService.info(_l10n.logRemovedFromHistory(query));
      }
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedRemoveHistory, st);
    }
  }

  Future<void> clearHistory() async {
    try {
      await _box.clear();
      _talkerService.info(_l10n.logHistoryCleared);
    } catch (e, st) {
      _talkerService.error(_l10n.logFailedClearHistory, st);
    }
  }
}
