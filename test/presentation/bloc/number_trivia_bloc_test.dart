import 'package:clean_flutter/core/error/failures.dart';
import 'package:clean_flutter/core/usecases/usecase.dart';
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

class FakeParams extends Fake implements Params {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late NumberTriviaBloc bloc;

  late MockInputConverter mockInputConverter;

  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;

  const numberTrivia = NumberTrivia(text: 'test trivia', number: 123);

  void mockInputConverterSuccess() {
    when(() => mockInputConverter.stringToUnsignedInteger(any()))
        .thenReturn(const Right(123));
  }

  void mockGetConcreteNumberTriviaSuccess() {
    when(() => mockGetConcreteNumberTrivia(any()))
        .thenAnswer((_) async => const Right(numberTrivia));
  }

  void mockGetRandomNumberTriviaSuccess() {
    when(() => mockGetRandomNumberTrivia(any()))
        .thenAnswer((_) async => const Right(numberTrivia));
  }

  setUpAll(() {
    registerFallbackValue(FakeNumberTriviaState());
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
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
      mockGetConcreteNumberTriviaSuccess();
      mockInputConverterSuccess();

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
      await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(any()));

      // assert
      verify(() => mockInputConverter.stringToUnsignedInteger(numberString));
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

    test('should call [GetConcreteNumberTriviaUseCase]', () async {
      // arrange
      mockInputConverterSuccess();
      mockGetConcreteNumberTriviaSuccess();

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      // assert
      verify(() =>
          mockGetConcreteNumberTrivia(const Params(number: parsedNumber)));
    });

    test(
        'should emit [NumberTriviaLoadingEvent, NumberTriviaLoadedEvent] when data is gotten successfully',
        () async {
      // arrange
      mockInputConverterSuccess();
      mockGetConcreteNumberTriviaSuccess();

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaLoadedState(trivia: numberTrivia),
        ]),
      );

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
    });

    test(
        'should emit [NumberTriviaErrorEvent] with a [SERVER_FAILURE_MESSAGE] when getting data fails by server',
        () async {
      // arrange
      mockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
        ]),
      );

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
    });

    test(
        'should emit [NumberTriviaErrorEvent] with a [CACHE_FAILURE_MESSAGE] when getting data fails by cache',
        () async {
      // arrange
      mockInputConverterSuccess();
      when(() => mockGetConcreteNumberTrivia(any()))
          .thenAnswer((_) async => const Left(CacheFailure()));

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
        ]),
      );

      // act
      bloc.add(GetConcreteNumberTriviaEvent(numberString));
    });
  });

  group('GetRandomNumberTrivia', () {
    const numberTrivia = NumberTrivia(text: 'test trivia', number: 123);

    test('should call [GetRandomNumberTriviaUseCase]', () async {
      // arrange
      mockGetRandomNumberTriviaSuccess();

      // act
      bloc.add(GetRandomNumberTriviaEvent());

      await untilCalled(() => mockGetRandomNumberTrivia(any()));

      // assert
      verify(() => mockGetRandomNumberTrivia(NoParams()));
    });

    test(
        'should emit [NumberTriviaLoadingEvent, NumberTriviaLoadedEvent] when data is gotten successfully',
        () async {
      // arrange
      mockInputConverterSuccess();
      mockGetRandomNumberTriviaSuccess();

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaLoadedState(trivia: numberTrivia),
        ]),
      );

      // act
      bloc.add(GetRandomNumberTriviaEvent());
    });

    test(
        'should emit [NumberTriviaErrorEvent] with a [SERVER_FAILURE_MESSAGE] when getting data fails by server',
        () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Left(ServerFailure()));

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: SERVER_FAILURE_MESSAGE),
        ]),
      );

      // act
      bloc.add(GetRandomNumberTriviaEvent());
    });

    test(
        'should emit [NumberTriviaErrorEvent] with a [CACHE_FAILURE_MESSAGE] when getting data fails by cache',
        () async {
      // arrange
      when(() => mockGetRandomNumberTrivia(any()))
          .thenAnswer((_) async => const Left(CacheFailure()));

      // assert later
      expectLater(
        bloc.stream,
        emitsInOrder([
          NumberTriviaLoadingState(),
          NumberTriviaErrorState(message: CACHE_FAILURE_MESSAGE),
        ]),
      );

      // act
      bloc.add(GetRandomNumberTriviaEvent());
    });
  });
}
