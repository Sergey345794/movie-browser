import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/l10n/app_localizations.dart';
import 'core/logging/talker_service.dart';
import 'core/storage/boxes.dart';
import 'core/storage/hive_service.dart';
import 'data/datasources/movie_remote_datasource.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'data/stores/details_cache_store.dart';
import 'data/stores/favorites_store.dart';
import 'data/stores/search_history_store.dart';
import 'domain/repositories/movie_repository.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/blocs/favorites/favorites_event.dart';
import 'presentation/blocs/movie_details/movie_details_bloc.dart';
import 'presentation/blocs/movie_search/movie_search_bloc.dart';
import 'presentation/blocs/search_history/search_history_bloc.dart';
import 'presentation/screens/favorites_screen.dart';
import 'presentation/screens/search_screen.dart';
import 'theme/app_theme.dart';

class MovieBrowserApp extends StatefulWidget {
  final String apiKey;
  final TalkerService talkerService;
  final HiveService hiveService;
  final AppLocalizations l10n;

  const MovieBrowserApp({
    super.key,
    required this.apiKey,
    required this.talkerService,
    required this.hiveService,
    required this.l10n,
  });

  @override
  State<MovieBrowserApp> createState() => _MovieBrowserAppState();
}

class _MovieBrowserAppState extends State<MovieBrowserApp> {
  late final MovieRepository _repository;
  late final SearchHistoryStore _searchHistoryStore;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final apiClient = ApiClient(
      apiKey: widget.apiKey,
      talkerService: widget.talkerService,
      l10n: widget.l10n,
    );

    final remoteDatasource = MovieRemoteDatasource(apiClient: apiClient);

    final favoritesBox =
        await widget.hiveService.openBox<Map>(HiveBoxes.favorites);
    final detailsCacheBox =
        await widget.hiveService.openBox<Map>(HiveBoxes.detailsCache);
    final searchHistoryBox =
        await widget.hiveService.openBox<String>(HiveBoxes.searchHistory);

    final favoritesStore = FavoritesStore(
      box: favoritesBox,
      talkerService: widget.talkerService,
      l10n: widget.l10n,
    );

    final detailsCacheStore = DetailsCacheStore(
      box: detailsCacheBox,
      talkerService: widget.talkerService,
      l10n: widget.l10n,
    );

    _searchHistoryStore = SearchHistoryStore(
      box: searchHistoryBox,
      talkerService: widget.talkerService,
      l10n: widget.l10n,
    );

    _repository = MovieRepositoryImpl(
      remoteDatasource: remoteDatasource,
      favoritesStore: favoritesStore,
      detailsCacheStore: detailsCacheStore,
      searchHistoryStore: _searchHistoryStore,
      talkerService: widget.talkerService,
      l10n: widget.l10n,
    );

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MovieRepository>.value(value: _repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MovieSearchBloc(
              repository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => MovieDetailsBloc(
              repository: context.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => FavoritesBloc(
              repository: context.read<MovieRepository>(),
            )..add(LoadFavoritesRequested()),
          ),
          BlocProvider(
            create: (context) => SearchHistoryBloc(
              store: _searchHistoryStore,
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('he'),
          ],
          home: const MainScreen(),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    SearchScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            context.read<FavoritesBloc>().add(LoadFavoritesRequested());
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: l10n.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),
        ],
      ),
    );
  }
}
