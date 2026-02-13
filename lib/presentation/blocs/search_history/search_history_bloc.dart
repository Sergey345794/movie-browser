import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/stores/search_history_store.dart';
import 'search_history_event.dart';
import 'search_history_state.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  final SearchHistoryStore _store;

  SearchHistoryBloc({
    required SearchHistoryStore store,
  })  : _store = store,
        super(SearchHistoryInitial()) {
    on<LoadSearchHistoryRequested>(_onLoadSearchHistoryRequested);
    on<RemoveSearchHistoryItemRequested>(_onRemoveSearchHistoryItemRequested);
    on<ClearSearchHistoryRequested>(_onClearSearchHistoryRequested);
  }

  Future<void> _onLoadSearchHistoryRequested(
    LoadSearchHistoryRequested event,
    Emitter<SearchHistoryState> emit,
  ) async {
    emit(SearchHistoryLoading());

    try {
      final history = await _store.getHistory();
      emit(SearchHistoryLoaded(history: history.reversed.toList()));
    } catch (_) {
      emit(SearchHistoryError(message: 'error_occurred'));
    }
  }

  Future<void> _onRemoveSearchHistoryItemRequested(
    RemoveSearchHistoryItemRequested event,
    Emitter<SearchHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchHistoryLoaded) return;

    try {
      await _store.removeSearch(event.query);
      final updatedHistory =
          currentState.history.where((q) => q != event.query).toList();
      emit(SearchHistoryLoaded(history: updatedHistory));
    } catch (_) {
      emit(SearchHistoryError(message: 'error_occurred'));
    }
  }

  Future<void> _onClearSearchHistoryRequested(
    ClearSearchHistoryRequested event,
    Emitter<SearchHistoryState> emit,
  ) async {
    try {
      await _store.clearHistory();
      emit(SearchHistoryLoaded(history: const []));
    } catch (_) {
      emit(SearchHistoryError(message: 'error_occurred'));
    }
  }
}
