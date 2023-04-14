import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_event.dart';
import 'package:clean_flutter/features/number_trivia/presentation/bloc/number_trivia/number_trivia_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeNumberTriviaState extends Fake implements NumberTriviaState {}

void main() {
  late NumberTriviaBloc bloc;

  late MockInputConverter mockInputConverter;

  MockGetConcreteNumberTrivia mockGetConcreteNumberTriva;
  MockGetRandomNumberTrivia mockGetRandomNumberTriva;

  setUpAll(() {
    registerFallbackValue(FakeNumberTriviaState());
  });

  setUp(() {
    mockGetRandomNumberTriva = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTriva = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTriva,
        random: mockGetRandomNumberTriva,
        inputConverter: mockInputConverter);
  });

  test('initial state should be NumberTriviaEmptyState', () {
    expect(bloc.initialState, NumberTriviaEmptyState());
  });

  group('GetConcreteNumberTrivia', () {
    const numberString = '123';
    const parsedNumber = 123;

    const numberTrivia = NumberTrivia(text: 'test trivia', number: 123);

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(const Right(123));

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));

      // assert
      verify(() => mockInputConverter.stringToUnsignedInteger(numberString));
    });

    test('should make sure initial state is correct', () {
      expect(bloc.state, NumberTriviaEmptyState());
    });

    test('should emit [NumberTriviaErrorState] when the input is invalid',
        () async {
      // arrange
      when(() => mockInputConverter.stringToUnsignedInteger(any()))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      expectLater(
        bloc.stream,
        emits(NumberTriviaErrorState(message: INVALID_INPUT_FAILURE_MESSAGE)),
      );

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
    });
  });
}
