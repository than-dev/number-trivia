import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

    registerFallbackValue(FakeUri());
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
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
  });
}
