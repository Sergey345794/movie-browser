import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/core/errors/failure.dart';
import 'package:movie_browser/domain/entities/movie.dart';
import 'package:movie_browser/domain/entities/movie_details.dart';
import 'package:movie_browser/domain/repositories/movie_repository.dart';
import 'package:movie_browser/presentation/blocs/movie_details/movie_details_bloc.dart';
import 'package:movie_browser/presentation/blocs/movie_details/movie_details_event.dart';
import 'package:movie_browser/presentation/blocs/movie_details/movie_details_state.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockRepository;
  late MovieDetailsBloc bloc;

  setUpAll(() {
    registerFallbackValue(const Movie(
      imdbId: 'tt0372784',
      title: 'Batman Begins',
      year: '2005',
      posterUrl: 'https://example.com/poster.jpg',
      type: 'movie',
    ));
  });

  setUp(() {
    mockRepository = MockMovieRepository();
    bloc = MovieDetailsBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('MovieDetailsBloc', () {
    const testImdbId = 'tt0372784';
    const testDetails = MovieDetails(
      imdbId: testImdbId,
      title: 'Batman Begins',
      year: '2005',
      rated: 'PG-13',
      released: '15 Jun 2005',
      runtime: '140 min',
      genre: 'Action, Crime',
      director: 'Christopher Nolan',
      writer: 'Bob Kane, David S. Goyer',
      actors: 'Christian Bale, Michael Caine',
      plot: 'After training with his mentor...',
      language: 'English',
      country: 'USA',
      awards: 'Nominated for 1 Oscar',
      posterUrl: 'https://example.com/poster.jpg',
      imdbRating: '8.2',
      imdbVotes: '1,200,000',
      type: 'movie',
    );

    test('initial state is MovieDetailsInitial', () {
      expect(bloc.state, isA<MovieDetailsInitial>());
    });

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsLoading, MovieDetailsSuccess] when fetch succeeds',
      build: () {
        when(() => mockRepository.getMovieDetails(testImdbId))
            .thenAnswer((_) async => testDetails);
        when(() => mockRepository.isFavorite(testImdbId))
            .thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieDetailsRequested(imdbId: testImdbId)),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsSuccess>()
            .having((s) => s.details, 'details', testDetails)
            .having((s) => s.isFavorite, 'isFavorite', false)
            .having((s) => s.fromCache, 'fromCache', false),
      ],
      verify: (_) {
        verify(() => mockRepository.getMovieDetails(testImdbId)).called(1);
        verify(() => mockRepository.isFavorite(testImdbId)).called(1);
      },
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsLoading, MovieDetailsSuccess] with cache on network failure',
      build: () {
        when(() => mockRepository.getMovieDetails(testImdbId))
            .thenThrow(const NetworkFailure());
        when(() => mockRepository.getCachedDetails(testImdbId))
            .thenAnswer((_) async => testDetails);
        when(() => mockRepository.isFavorite(testImdbId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieDetailsRequested(imdbId: testImdbId)),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsSuccess>()
            .having((s) => s.details, 'details', testDetails)
            .having((s) => s.isFavorite, 'isFavorite', true)
            .having((s) => s.fromCache, 'fromCache', true),
      ],
      verify: (_) {
        verify(() => mockRepository.getMovieDetails(testImdbId)).called(1);
        verify(() => mockRepository.getCachedDetails(testImdbId)).called(1);
        verify(() => mockRepository.isFavorite(testImdbId)).called(1);
      },
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'emits [MovieDetailsLoading, MovieDetailsError] when no cache available',
      build: () {
        when(() => mockRepository.getMovieDetails(testImdbId))
            .thenThrow(const NetworkFailure());
        when(() => mockRepository.getCachedDetails(testImdbId))
            .thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadMovieDetailsRequested(imdbId: testImdbId)),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsError>()
            .having((s) => s.message, 'message', 'network_error'),
      ],
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'toggles favorite state from false to true',
      build: () {
        when(() => mockRepository.addToFavorites(any()))
            .thenAnswer((_) async => {});
        return bloc;
      },
      seed: () => MovieDetailsSuccess(
        details: testDetails,
        isFavorite: false,
        fromCache: false,
      ),
      act: (bloc) => bloc.add(ToggleFavoriteRequested()),
      expect: () => [
        isA<MovieDetailsSuccess>()
            .having((s) => s.details, 'details', testDetails)
            .having((s) => s.isFavorite, 'isFavorite', true)
            .having((s) => s.fromCache, 'fromCache', false),
      ],
      verify: (_) {
        verify(() => mockRepository.addToFavorites(any())).called(1);
      },
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'toggles favorite state from true to false',
      build: () {
        when(() => mockRepository.removeFromFavorites(testImdbId))
            .thenAnswer((_) async => {});
        return bloc;
      },
      seed: () => MovieDetailsSuccess(
        details: testDetails,
        isFavorite: true,
        fromCache: false,
      ),
      act: (bloc) => bloc.add(ToggleFavoriteRequested()),
      expect: () => [
        isA<MovieDetailsSuccess>()
            .having((s) => s.details, 'details', testDetails)
            .having((s) => s.isFavorite, 'isFavorite', false)
            .having((s) => s.fromCache, 'fromCache', false),
      ],
      verify: (_) {
        verify(() => mockRepository.removeFromFavorites(testImdbId)).called(1);
      },
    );

    blocTest<MovieDetailsBloc, MovieDetailsState>(
      'preserves fromCache flag when toggling favorite',
      build: () {
        when(() => mockRepository.removeFromFavorites(testImdbId))
            .thenAnswer((_) async => {});
        return bloc;
      },
      seed: () => MovieDetailsSuccess(
        details: testDetails,
        isFavorite: true,
        fromCache: true,
      ),
      act: (bloc) => bloc.add(ToggleFavoriteRequested()),
      expect: () => [
        isA<MovieDetailsSuccess>()
            .having((s) => s.details, 'details', testDetails)
            .having((s) => s.isFavorite, 'isFavorite', false)
            .having((s) => s.fromCache, 'fromCache', true),
      ],
    );
  });
}
