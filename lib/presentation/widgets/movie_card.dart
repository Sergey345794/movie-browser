import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/movie.dart';
import '../../../theme/app_colors.dart';
import '../blocs/movie_details/movie_details_bloc.dart';
import '../blocs/movie_details/movie_details_event.dart';
import '../screens/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onDelete;

  const MovieCard({
    required this.movie,
    this.onDelete,
  }) : super(key: const ValueKey('movie_card'));

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(movie.imdbId),
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/card_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          InkWell(
            onTap: () {
              // Validate imdbId before loading details
              // IMDb ID format: tt + at least 7 digits (e.g., tt0111161)
              final imdbIdPattern = RegExp(r'^tt\d{7,}$');
              if (movie.imdbId.isEmpty ||
                  movie.imdbId == 'N/A' ||
                  !imdbIdPattern.hasMatch(movie.imdbId)) {
                return;
              }

              context.read<MovieDetailsBloc>().add(
                    LoadMovieDetailsRequested(imdbId: movie.imdbId),
                  );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    imdbId: movie.imdbId,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (movie.posterUrl != 'N/A')
                    Semantics(
                      image: true,
                      label: AppLocalizations.of(context)
                          .moviePosterLabel(movie.title),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: AppColors.surface,
                              child: const Icon(
                                Icons.movie,
                                color: AppColors.textHint,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.movie,
                        color: AppColors.textHint,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              movie.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            movie.year,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              movie.type.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Delete button (if onDelete callback is provided)
          if (onDelete != null)
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () {
                    // Call onDelete and prevent event from reaching InkWell below
                    onDelete?.call();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 17,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
