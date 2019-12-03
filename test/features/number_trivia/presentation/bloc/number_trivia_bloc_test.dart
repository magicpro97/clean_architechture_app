import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architechture_app/core/error/failures.dart';
import 'package:clean_architechture_app/core/usecases/usecase.dart';
import 'package:clean_architechture_app/core/util/input_converter.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () async {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    blocTest(
      'should emit [Loading, Loaded] when data is gotten sucessfully',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnSignInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to validate to convert the string to an unsigned integer',
            () async {
          // arrange
          setUpMockInputConverterSuccess();
          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockInputConverter.stringToUnSignInteger(any));
          // assert
          verify(mockInputConverter.stringToUnSignInteger(tNumberString));
        });

    blocTest(
      'shoud emit [Error] when the input is invalid',
      build: () {
        when(mockInputConverter.stringToUnSignInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    test('should get data from concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when data is gotten sucessfully',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
