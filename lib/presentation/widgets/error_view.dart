import 'package:flutter/material.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String messageKey;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.messageKey,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String getMessage() {
      switch (messageKey) {
        case 'network_error':
          return l10n.networkError;
        case 'server_error':
          return l10n.serverError;
        case 'api_error':
          return l10n.apiError;
        case 'no_results_found':
          return l10n.noResultsFound;
        case 'too_many_results':
          return l10n.tooManyResults;
        case 'movie_not_found':
          return l10n.movieNotFound;
        case 'error_occurred':
        default:
          return l10n.errorOccurred;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                getMessage(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
