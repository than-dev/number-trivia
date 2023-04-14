import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_event.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaState get initialState => NumberTriviaEmptyState();

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(NumberTriviaEmptyState()) {
    // register events
    on<GetConcreteNumberTriviaEvent>((event, emit) {
      final response =
          inputConverter.stringToUnsignedInteger(event.numberString);

      response.fold(
          (failure) => emit(
              NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) => emit(NumberTriviaEmptyState()));
    });
  }
}
