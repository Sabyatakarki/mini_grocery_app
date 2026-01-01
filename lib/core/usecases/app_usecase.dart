import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';


abstract interface class UsecaseWithParams<SuccessType,Params>{
  Future<Either<Failures, SuccessType>> call(Params params);
}

abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failures, SuccessType>> call();
}
