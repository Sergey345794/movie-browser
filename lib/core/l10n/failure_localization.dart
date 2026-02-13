import '../errors/failure.dart';
import 'app_localizations.dart';

extension FailureLocalization on Failure {
  String toLocalizedMessage(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure() => l10n.networkError,
      ApiFailure() => l10n.apiError,
      EmptyResultsFailure() => l10n.noResultsFound,
      TooManyResultsFailure() => l10n.tooManyResults,
      MovieNotFoundFailure() => l10n.movieNotFound,
      UnknownFailure() => l10n.errorOccurred,
    };
  }
}
