import 'package:clean_architechture_app/core/error/exceptions.dart';
import 'package:clean_architechture_app/core/error/failures.dart';
import 'package:clean_architechture_app/core/platform/network_info.dart';
import 'package:clean_architechture_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architechture_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
    NumberTriviaModel(number: 1, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successs',
              () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTrivia);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          });
      test(
          'should cache data locally when the call to remote data source is successs',
              () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTrivia);
            // act
            await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(localDataSource.cacheNumberTrivia(tNumberTrivia));
          });
      test(
          'should return server failure when the call to remote data source is successs',
              () async {
            // arrange
            when(remoteDataSource.getConcreteNumberTrivia(any))
                .thenThrow(ServerException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(localDataSource);
            expect(result, Left(ServerFailure()));
          });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return last locally cached data when the cachded data is present',
              () async {
            // arrange
            when(localDataSource.getLastNumberTrivia()).thenAnswer((
                _) async => tNumberTrivia);
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          });
      test(
          'should return CachedFailure when there is no cached data present',
              () async {
            // arrange
            when(localDataSource.getLastNumberTrivia()).thenThrow(
                CacheException());
            // act
            final result = await repository.getConcreteNumberTrivia(tNumber);
            // assert
            verifyZeroInteractions(remoteDataSource);
            verify(localDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}