import 'package:clean_architechture_app/core/platform/network_info.dart';
import 'package:clean_architechture_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_local_data_source.dart';
import 'package:clean_architechture_app/features/number_trivia/data/sources/number_trivia_remote_data_source.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {
}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {
}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;
}