import 'package:hive_flutter/hive_flutter.dart';
import '../l10n/app_localizations.dart';
import '../logging/talker_service.dart';

class HiveService {
  final TalkerService talkerService;
  final AppLocalizations l10n;

  HiveService({required this.talkerService, required this.l10n});

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      talkerService.info(l10n.logHiveInitialized);
    } catch (e, st) {
      talkerService.error(l10n.logHiveInitFailed, st);
      rethrow;
    }
  }

  Future<Box<T>> openBox<T>(String name) async {
    try {
      final box = await Hive.openBox<T>(name);
      talkerService.info(l10n.logBoxOpened(name));
      return box;
    } catch (e, st) {
      talkerService.error(l10n.logBoxOpenFailed(name), st);
      rethrow;
    }
  }

  Future<void> closeBox(String name) async {
    try {
      await Hive.box(name).close();
      talkerService.info(l10n.logBoxClosed(name));
    } catch (e, st) {
      talkerService.error(l10n.logBoxCloseFailed(name), st);
    }
  }

  Future<void> deleteBox(String name) async {
    try {
      await Hive.deleteBoxFromDisk(name);
      talkerService.info(l10n.logBoxDeleted(name));
    } catch (e, st) {
      talkerService.error(l10n.logBoxDeleteFailed(name), st);
    }
  }
}
