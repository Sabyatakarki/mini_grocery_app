import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository{
  Future<Either<Failures,bool>> register(AuthEntity entity);
  Future<Either<Failures,AuthEntity>>login(String email,String password);
  Future<Either<Failures,AuthEntity>>getCurrentUser();
  Future<Either<Failures,bool>>logout();


}