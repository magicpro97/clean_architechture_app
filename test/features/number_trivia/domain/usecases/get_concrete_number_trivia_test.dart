import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository repository;
  setUp(() {
    repository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(repository);
  });
  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia for the number from repository', () async {
    // arrange
    when(repository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));
    // act
    final result = await usecase(Params(number: tNumber));
    // assert
    expect(result, Right(tNumberTrivia));
    verify(repository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(repository);
  });
}