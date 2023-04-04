import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source%20.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson((fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferencia when there is one in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      // act
      final result = await dataSource.getLastNumberTrivia();

      // assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is no one in the cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      // act
      final call = dataSource.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      // act
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = tNumberTriviaModel.toJson();

      // assert
      verify(() => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
