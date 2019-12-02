import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throw a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throw a [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}
