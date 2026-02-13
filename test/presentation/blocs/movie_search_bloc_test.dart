import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/core/errors/failure.dart';
import 'package:movie_browser/domain/entities/movie.dart';
import 'package:movie_browser/domain/entities/movie_search_result.dart';
import 'package:movie_browser/domain/repositories/movie_repository.dart';
import 'package:movie_browser/presentation/blocs/movie_search/movie_search_bloc.dart';
import 'package:movie_browser/presentation/blocs/movie_search/movie_search_event.dart';
import 'package:movie_browser/presentation/blocs/movie_search/movie_search_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late MovieSearchBloc bloc;

  setUp(() {
    mockRepository = MockMovieRepository();
    bloc = MovieSearchBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('MovieSearchBloc', () {
    const testQuery = 'Batman';
    final testMovies = [
      const Movie(
        imdbId: 'tt0372784',
        title: 'Batman Begins',
        year: '2005',
        posterUrl: 'https://example.com/poster.jpg',
        type: 'movie',
      ),
    ];

    final testSearchResult = MovieSearchResult(
      movies: testMovies,
      totalResults: 1,
    );

    test('initial state is MovieSearchInitial', () {
      expect(bloc.state, isA<MovieSearchInitial>());
    });

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchSuccess] when search succeeds',
      build: () {
        when(() => mockRepository.searchMovies(testQuery, 1))
            .thenAnswer((_) async => testSearchResult);
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesRequested(query: testQuery)),
      expect: () => [
        isA<MovieSearchLoading>(),
        isA<MovieSearchSuccess>()
            .having((s) => s.movies, 'movies', testMovies)
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
      verify: (_) {
        verify(() => mockRepository.searchMovies(testQuery, 1)).called(1);
      },
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchSuccess] with empty list',
      build: () {
        when(() => mockRepository.searchMovies(testQuery, 1))
            .thenAnswer((_) async => const MovieSearchResult(
                  movies: [],
                  totalResults: 0,
                ));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesRequested(query: testQuery)),
      expect: () => [
        isA<MovieSearchLoading>(),
        isA<MovieSearchSuccess>()
            .having((s) => s.movies, 'movies', isEmpty)
            .having((s) => s.currentPage, 'currentPage', 1)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchError] on network failure',
      build: () {
        when(() => mockRepository.searchMovies(testQuery, 1))
            .thenThrow(const NetworkFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesRequested(query: testQuery)),
      expect: () => [
        isA<MovieSearchLoading>(),
        isA<MovieSearchError>()
            .having((s) => s.message, 'message', 'network_error'),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchError] on API failure',
      build: () {
        when(() => mockRepository.searchMovies(testQuery, 1))
            .thenThrow(const ApiFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesRequested(query: testQuery)),
      expect: () => [
        isA<MovieSearchLoading>(),
        isA<MovieSearchError>()
            .having((s) => s.message, 'message', 'api_error'),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoading, MovieSearchError] on empty results failure',
      build: () {
        when(() => mockRepository.searchMovies(testQuery, 1))
            .thenThrow(const EmptyResultsFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMoviesRequested(query: testQuery)),
      expect: () => [
        isA<MovieSearchLoading>(),
        isA<MovieSearchError>()
            .having((s) => s.message, 'message', 'no_results_found'),
      ],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [MovieSearchLoadingMore, MovieSearchSuccess] when loading more',
      build: () {
        final moreMovies = [
          const Movie(
            imdbId: 'tt1345836',
            title: 'The Dark Knight Rises',
            year: '2012',
            posterUrl: 'https://example.com/poster2.jpg',
            type: 'movie',
          ),
        ];
        when(() => mockRepository.searchMovies(testQuery, 2))
            .thenAnswer((_) async => MovieSearchResult(
                  movies: moreMovies,
                  totalResults: 20,
                ));
        return bloc;
      },
      seed: () => MovieSearchSuccess(
        movies: testMovies,
        totalResults: 20,
        currentPage: 1,
        hasMore: true,
      ),
      act: (bloc) =>
          bloc.add(LoadMoreMoviesRequested(query: testQuery, page: 2)),
      expect: () => [
        isA<MovieSearchLoadingMore>()
            .having((s) => s.movies, 'movies', testMovies),
        isA<MovieSearchSuccess>()
            .having((s) => s.movies.length, 'movies.length', 2)
            .having((s) => s.currentPage, 'currentPage', 2),
      ],
    );
  });
}
