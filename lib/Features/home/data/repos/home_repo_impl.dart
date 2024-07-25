import 'package:bookly/Features/home/data/data_sources/home_local_data_source.dart';
import 'package:bookly/Features/home/data/data_sources/home_remote_data_source.dart';
import 'package:bookly/Features/home/domain/entities/book_entity.dart';
import 'package:bookly/Features/home/domain/repos/home_repo.dart';
import 'package:bookly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class HomeRepoImpl extends HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  final HomeLocalDataSource homeLocalDataSource;

  HomeRepoImpl(
      {required this.homeRemoteDataSource, required this.homeLocalDataSource});
  @override
  Future<Either<Failure, List<BookEntity>>> fetchFeaturedBooks() async {
    try {
      var bookFromCache = homeLocalDataSource.fetchFeaturedBooks();

      if (bookFromCache.isNotEmpty) return right(bookFromCache);
      var bookFromNet = await homeRemoteDataSource.fetchFeaturedBooks();

      return right(bookFromNet);
    } catch (e) {
      if (e is DioException) return left(ServerFailure.fromDioErr(e));
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> fetchNewestBooks() async {
    try {
      var booksFromCache = homeLocalDataSource.fetchNewestBooks();
      if (booksFromCache.isNotEmpty) return right(booksFromCache);
      var booksFromNet = await homeRemoteDataSource.fetchFeaturedBooks();
      return right(booksFromNet);
    } catch (e) {
      if (e is DioException) return left(ServerFailure.fromDioErr(e));
      return left(ServerFailure(e.toString()));
    }
  }
}
