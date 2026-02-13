import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../blocs/movie_search/movie_search_bloc.dart';
import '../blocs/movie_search/movie_search_event.dart';
import '../blocs/movie_search/movie_search_state.dart';
import '../blocs/search_history/search_history_bloc.dart';
import '../blocs/search_history/search_history_event.dart';
import '../blocs/search_history/search_history_state.dart';
import '../widgets/movie_list.dart';
import '../widgets/error_view.dart';

class SearchScreen extends HookWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchController = useTextEditingController();
    final scrollController = useScrollController();
    final showHistory = useState(false);

    useEffect(() {
      context.read<SearchHistoryBloc>().add(LoadSearchHistoryRequested());
      return null;
    }, []);

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent * 0.9) {
          final state = context.read<MovieSearchBloc>().state;
          if (state is MovieSearchSuccess && state.hasMore) {
            context.read<MovieSearchBloc>().add(
                  LoadMoreMoviesRequested(
                    query: searchController.text,
                    page: state.currentPage + 1,
                  ),
                );
          }
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    void performSearch() {
      final query = searchController.text.trim();
      if (query.isNotEmpty) {
        showHistory.value = false;
        context.read<MovieSearchBloc>().add(
              SearchMoviesRequested(query: query),
            );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.search,
          style: const TextStyle(
            color: Colors.white,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: l10n.searchMovies,
                            prefixIcon: const Icon(Icons.search,
                                color: AppColors.primary),
                          ),
                          onSubmitted: (_) => performSearch(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: performSearch,
                        child: Text(l10n.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showHistory.value = !showHistory.value;
                      // Reload history when opening
                      if (showHistory.value) {
                        context
                            .read<SearchHistoryBloc>()
                            .add(LoadSearchHistoryRequested());
                      }
                    },
                    child: Text(
                      l10n.recentSearch,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: showHistory.value
                  ? BlocBuilder<SearchHistoryBloc, SearchHistoryState>(
                      builder: (context, historyState) {
                        if (historyState is SearchHistoryLoaded) {
                          if (historyState.history.isEmpty) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l10n.searchHint,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white.withValues(alpha: 0.4),
                                  //   borderRadius: BorderRadius.circular(8),
                                  // ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        l10n.searchHistory,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<SearchHistoryBloc>().add(
                                              ClearSearchHistoryRequested());
                                        },
                                        child: Text(l10n.clearHistory),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListView.builder(
                                    itemCount: historyState.history.length,
                                    itemBuilder: (context, index) {
                                      final query = historyState.history[index];
                                      return ListTile(
                                        leading: const Icon(
                                          Icons.history,
                                          color: AppColors.textSecondary,
                                        ),
                                        title: Text(query),
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.close,
                                            color: AppColors.textSecondary,
                                          ),
                                          tooltip: l10n.clearHistory,
                                          onPressed: () {
                                            context
                                                .read<SearchHistoryBloc>()
                                                .add(
                                                  RemoveSearchHistoryItemRequested(
                                                    query: query,
                                                  ),
                                                );
                                          },
                                        ),
                                        onTap: () {
                                          searchController.text = query;
                                          performSearch();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.searchHint,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                        );
                      },
                    )
                  : BlocListener<MovieSearchBloc, MovieSearchState>(
                      listener: (context, searchState) {
                        // Reload history when search is successful
                        if (searchState is MovieSearchSuccess) {
                          context
                              .read<SearchHistoryBloc>()
                              .add(LoadSearchHistoryRequested());
                        }
                      },
                      child: BlocBuilder<MovieSearchBloc, MovieSearchState>(
                        builder: (context, searchState) {
                          if (searchState is MovieSearchLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            );
                          }

                          if (searchState is MovieSearchError) {
                            return ErrorView(
                              messageKey: searchState.message,
                              onRetry: () {
                                context
                                    .read<MovieSearchBloc>()
                                    .add(SearchCleared());
                                searchController.clear();
                              },
                            );
                          }

                          if (searchState is MovieSearchSuccess) {
                            if (searchState.movies.isEmpty) {
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    l10n.noResultsFound,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                              );
                            }

                            return MovieList(
                              movies: searchState.movies,
                              scrollController: scrollController,
                              isLoadingMore: false,
                            );
                          }

                          if (searchState is MovieSearchLoadingMore) {
                            return MovieList(
                              movies: searchState.movies,
                              scrollController: scrollController,
                              isLoadingMore: true,
                            );
                          }

                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.searchHint,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
