import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../blocs/movie_details/movie_details_bloc.dart';
import '../blocs/movie_details/movie_details_event.dart';
import '../blocs/movie_details/movie_details_state.dart';
import '../widgets/error_view.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String imdbId;

  const MovieDetailsScreen({
    super.key,
    required this.imdbId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.movieDetails,
          style: const TextStyle(
            color: AppColors.surfaceLight,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/app_app_bar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is MovieDetailsError) {
              return ErrorView(
                messageKey: state.message,
                onRetry: () {
                  context.read<MovieDetailsBloc>().add(
                        LoadMovieDetailsRequested(imdbId: imdbId),
                      );
                },
              );
            }

            if (state is MovieDetailsSuccess) {
              return Column(
                children: [
                  if (state.fromCache) _CacheBanner(l10n: l10n),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MoviePoster(posterUrl: state.details.posterUrl),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _MovieHeader(
                                    title: state.details.title,
                                    isFavorite: state.isFavorite,
                                    l10n: l10n,
                                    onToggleFavorite: () {
                                      context
                                          .read<MovieDetailsBloc>()
                                          .add(ToggleFavoriteRequested());
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  _MovieRating(
                                    imdbRating: state.details.imdbRating,
                                    year: state.details.year,
                                  ),
                                  const SizedBox(height: 16),
                                  _MovieInfoRow(
                                    label: l10n.rated,
                                    value: state.details.rated,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.released,
                                    value: state.details.released,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.runtime,
                                    value: state.details.runtime,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.genre,
                                    value: state.details.genre,
                                  ),
                                  const SizedBox(height: 16),
                                  _MoviePlot(
                                    label: l10n.plot,
                                    plot: state.details.plot,
                                  ),
                                  const SizedBox(height: 16),
                                  _MovieInfoRow(
                                    label: l10n.director,
                                    value: state.details.director,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.writer,
                                    value: state.details.writer,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.actors,
                                    value: state.details.actors,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.language,
                                    value: state.details.language,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.country,
                                    value: state.details.country,
                                  ),
                                  _MovieInfoRow(
                                    label: l10n.awards,
                                    value: state.details.awards,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CacheBanner extends StatelessWidget {
  final AppLocalizations l10n;

  const _CacheBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: l10n.cacheFallback,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        color: AppColors.ratingGold.withValues(alpha: 0.2),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.ratingGold,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.cacheFallback,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final String posterUrl;

  const _MoviePoster({required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    if (posterUrl == 'N/A') {
      final l10n = AppLocalizations.of(context);
      return Semantics(
        label: l10n.moviePosterNotAvailable,
        child: Container(
          width: double.infinity,
          height: 400,
          color: AppColors.surface,
          child: const Icon(
            Icons.movie,
            size: 100,
            color: AppColors.textHint,
          ),
        ),
      );
    }

    final l10n = AppLocalizations.of(context);
    return Semantics(
      image: true,
      label: l10n.moviePoster,
      child: Image.network(
        posterUrl,
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 400,
            color: AppColors.surface,
            child: const Icon(
              Icons.movie,
              size: 100,
              color: AppColors.textHint,
            ),
          );
        },
      ),
    );
  }
}

class _MovieHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final AppLocalizations l10n;
  final VoidCallback onToggleFavorite;

  const _MovieHeader({
    required this.title,
    required this.isFavorite,
    required this.l10n,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        Semantics(
          button: true,
          label: isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.favoriteRed,
            ),
            onPressed: onToggleFavorite,
          ),
        ),
      ],
    );
  }
}

class _MovieRating extends StatelessWidget {
  final String imdbRating;
  final String year;

  const _MovieRating({
    required this.imdbRating,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.imdbRatingYear(imdbRating, year),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.ratingGold, size: 20),
          const SizedBox(width: 4),
          Text(
            imdbRating,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(width: 16),
          Text(
            year,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _MovieInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _MovieInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoviePlot extends StatelessWidget {
  final String label;
  final String plot;

  const _MoviePlot({
    required this.label,
    required this.plot,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: '$label: $plot',
          child: Text(
            plot,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
