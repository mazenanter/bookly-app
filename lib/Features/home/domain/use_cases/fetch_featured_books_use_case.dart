import 'package:bookly/Features/home/domain/entities/book_entity.dart';
import 'package:bookly/Features/home/domain/repos/home_repo.dart';
import 'package:bookly/core/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

class FetchFeaturedBooksUseCase extends UseCase<List<BookEntity>, void> {
  final HomeRepo homeRepo;

  FetchFeaturedBooksUseCase(this.homeRepo);

  @override
  Future<Either<Failure, List<BookEntity>>> call({void param}) async {
    return await homeRepo.fetchFeaturedBooks();
  }
}


