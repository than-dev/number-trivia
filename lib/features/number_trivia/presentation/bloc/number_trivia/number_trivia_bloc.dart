import 'package:clean_flutter/core/error/failures.dart';
import 'package:clean_flutter/core/usecases/usecase.dart';
import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_event.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
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
    on<GetConcreteNumberTriviaEvent>((event, emit) async {
      final response =
          inputConverter.stringToUnsignedInteger(event.numberString);

      await response.fold((failure) {
        emit(NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (integer) async {
        emit(NumberTriviaLoadingState());
        final response = await getConcreteNumberTrivia(Params(number: integer));

        emit(_eitherLoadedOrErrorState(response));
      });
    });

    on<GetRandomNumberTriviaEvent>((event, emit) async {
      emit(NumberTriviaLoadingState());
      final response = await getRandomNumberTrivia(NoParams());

      emit(_eitherLoadedOrErrorState(response));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case (ServerFailure):
        return SERVER_FAILURE_MESSAGE;
      case (CacheFailure):
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNKNOW_FAILURE_MESSAGE;
    }
  }

  NumberTriviaState _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) {
    return failureOrTrivia.fold(
        (failure) =>
            NumberTriviaErrorState(message: _mapFailureToMessage(failure)),
        (trivia) => NumberTriviaLoadedState(trivia: trivia));
  }
}
