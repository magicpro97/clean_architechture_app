import 'package:clean_architechture_app/core/error/exceptions.dart';
import 'package:clean_architechture_app/core/error/failures.dart';
import 'package:clean_architechture_app/core/platform/network_info.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architechture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({@required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(
            number);
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    return null;
  }
}
