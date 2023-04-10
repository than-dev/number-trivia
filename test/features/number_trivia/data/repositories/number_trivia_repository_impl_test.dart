import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source%20.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_flutter/core/network/network_info.dart';
import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockRemoteDataSource mockRemoteDataSource = MockRemoteDataSource();
  MockLocalDataSource mockLocalDataSource = MockLocalDataSource();
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  NumberTriviaRepositoryImpl mockRepository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo);

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(number: tNumber, text: 'test trivia');
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  void mockGetLastNumberTriviaToReturnCorrectly() {
    when(() => mockLocalDataSource.getLastNumberTrivia())
        .thenAnswer((_) async => tNumberTriviaModel);
  }

  void mockGetConcreteNumberTriviaToReturnCorrectly() {
    when((() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber)))
        .thenAnswer((_) async => tNumberTriviaModel);
  }

  void mockGetRandomNumberTriviaToReturnCorrectly() {
    when((() => mockRemoteDataSource.getRandomNumberTrivia()))
        .thenAnswer((_) async => tNumberTriviaModel);
  }

  void mockNetworkInfoToIsConnectedTrue() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  }

  void mockNetworkInfoToIsConnectedFalse() {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
  }

  void mockCacheNumberTrivia() {
    when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
        .thenAnswer((_) async => {});
  }

  group('getConcreteNumberTrivia', () {
    test('should check if the device is online', () {
      //arrange
      mockGetConcreteNumberTriviaToReturnCorrectly();
      mockNetworkInfoToIsConnectedTrue();
      mockCacheNumberTrivia();

      // act
      mockRepository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        mockNetworkInfoToIsConnectedTrue();
      });

      test(
          'should return remote data when the call to remote data source is success',
          () async {
        // arrange
        mockGetConcreteNumberTriviaToReturnCorrectly();
        mockCacheNumberTrivia();

        // act
        final result = await mockRepository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        mockGetConcreteNumberTriviaToReturnCorrectly();

        // act
        await mockRepository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          reset(mockLocalDataSource);
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
              .thenThrow(ServerException());

          // act
          final result = await mockRepository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(const Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        mockNetworkInfoToIsConnectedFalse();
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        reset(mockRemoteDataSource);
        mockGetLastNumberTriviaToReturnCorrectly();

        // act
        final result = await mockRepository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Right(tNumberTriviaModel)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await mockRepository.getConcreteNumberTrivia(tNumber);

        // assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    setUp(() {
      resetMocktailState();
      reset(mockRemoteDataSource);
      reset(mockLocalDataSource);
      reset(mockNetworkInfo);
    });

    test('should check if the device is online', () async {
      //arrange
      mockGetRandomNumberTriviaToReturnCorrectly();
      mockNetworkInfoToIsConnectedTrue();
      mockCacheNumberTrivia();

      // act
      await mockRepository.getRandomNumberTrivia();

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        mockNetworkInfoToIsConnectedTrue();
      });

      test(
          'should return remote data when the call to remote data source is success',
          () async {
        // arrange
        mockGetRandomNumberTriviaToReturnCorrectly();
        mockCacheNumberTrivia();

        // act
        final result = await mockRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTriviaModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        mockCacheNumberTrivia();
        mockGetRandomNumberTriviaToReturnCorrectly();

        // act
        await mockRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        // act
        final result = await mockRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(const Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        mockNetworkInfoToIsConnectedFalse();
      });

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        // arrange
        mockGetLastNumberTriviaToReturnCorrectly();

        // act
        final result = await mockRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Right(tNumberTriviaModel)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        // act
        final result = await mockRepository.getRandomNumberTrivia();

        // assert
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);
        expect(result, equals(const Left(CacheFailure())));
      });
    });
  });
}
