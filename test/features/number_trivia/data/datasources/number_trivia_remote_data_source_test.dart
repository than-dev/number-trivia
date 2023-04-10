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

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

    registerFallbackValue(FakeUri());
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixture('trivia.json'));
    test('should perform a GET request with the correct endpoint and headers',
        () {
      //arrange
      when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer(
        (_) async => http.Response(fixture('trivia.json'), 200),
      );

      // act
      dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      verify(() => mockHttpClient.get(Uri.http('numbersapi.com', '/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when status code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      // assert
      expect(result, tNumberTriviaModel);
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();

        // act
        final call = dataSource.getConcreteNumberTrivia;

        // assert
        expect(call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });
}
