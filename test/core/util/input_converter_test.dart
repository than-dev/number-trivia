import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter = InputConverter();

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string represents an unsigned integer',
        () async {
      // arrange
      const string = '123';

      // act
      final result = inputConverter.stringToUnsignedInteger(string);

      // assert
      expect(result, const Right(123));
    });

    test(
        'should return a InvalidInputFailure when received string not represents a number',
        () async {
      // arrange
      const string = 'abc';

      // act
      final result = inputConverter.stringToUnsignedInteger(string);

      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test(
      'should return a InvalidInputFailure when the string is a negative integer',
      () async {
        // arrange
        const string = '-123';

        // act
        final result = inputConverter.stringToUnsignedInteger(string);

        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
