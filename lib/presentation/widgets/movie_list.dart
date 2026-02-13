import 'package:flutter/material.dart';
import '../../../domain/entities/movie.dart';
import '../../../theme/app_colors.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const MovieList({
    super.key,
    required this.movies,
    this.scrollController,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: movies.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == movies.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          );
        }

        return MovieCard(movie: movies[index]);
      },
    );
  }
}
