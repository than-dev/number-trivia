import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  void mockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void mockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  const tNumber = 1;
  final tNumberTriviaModel = NumberTriviaModel.fromJson(fixture('trivia.json'));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

    registerFallbackValue(FakeUri());
  });

  group('getConcreteNumberTrivia', () {
    test('should perform a GET request with the correct endpoint and headers',
        () {
      //arrange
      mockHttpClientSuccess200();

      // act
      dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockHttpClient.get(Uri.http('numbersapi.com', '/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when status code is 200 (success)',
        () async {
      // arrange
      mockHttpClientSuccess200();

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        mockHttpClientFailure404();

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    test('should perform a GET request with the correct endpoint and headers',
        () {
      //arrange
      mockHttpClientSuccess200();

      // act
      dataSource.getRandomNumberTrivia();

      // assert
      verify(() => mockHttpClient.get(
          Uri.http('numbersapi.com', '/random/trivia'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when status code is 200 (success)',
        () async {
      // arrange
      mockHttpClientSuccess200();

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        mockHttpClientFailure404();

        // act
        final call = dataSource.getRandomNumberTrivia;

        // assert
        expect(call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
