import 'package:equatable/equatable.dart';

abstract class SearchHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSearchHistoryRequested extends SearchHistoryEvent {}

class RemoveSearchHistoryItemRequested extends SearchHistoryEvent {
  final String query;

  RemoveSearchHistoryItemRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchHistoryRequested extends SearchHistoryEvent {}
