import 'package:clean_architechture_app/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignInteger', () {
    test(
        'should return an integer when the string presents an unsigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = inputConverter.stringToUnSignInteger(str);
      // assert
      expect(result, Right(123));
    });

    test('should return a Failure when the string is not an integer', () async {
      // arrange
      final str = 'abc';
      // act
      final result = inputConverter.stringToUnSignInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a Failure when the string is a negative integer',
        () async {
      // arrange
      final str = '-123';
      // act
      final result = inputConverter.stringToUnSignInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
