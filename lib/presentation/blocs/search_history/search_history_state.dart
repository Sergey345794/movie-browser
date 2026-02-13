import 'package:equatable/equatable.dart';

abstract class SearchHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchHistoryInitial extends SearchHistoryState {}

class SearchHistoryLoading extends SearchHistoryState {}

class SearchHistoryLoaded extends SearchHistoryState {
  final List<String> history;

  SearchHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

class SearchHistoryError extends SearchHistoryState {
  final String message;

  SearchHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
