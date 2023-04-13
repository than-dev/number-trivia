import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class NumberTriviaEmptyState extends NumberTriviaState {}

class NumberTriviaLoadingState extends NumberTriviaState {}

class NumberTriviaLoadedState extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoadedState({required this.trivia}) : super([trivia]);
}

class NumberTriviaErrorState extends NumberTriviaState {
  final String message;

  NumberTriviaErrorState({required this.message}) : super([message]);
}
