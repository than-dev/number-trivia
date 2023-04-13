part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent(this.numberString) : super([numberString]);
}
