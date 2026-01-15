// ...existing code...
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:mini_grocery/core/usecases/app_usecase.dart';
import 'package:mini_grocery/features/auth/data/repositories/auth_repository.dart';
import 'package:mini_grocery/features/auth/domain/entities/auth_entity.dart';
import 'package:mini_grocery/features/auth/domain/repositories/auth_repository.dart';

// ...existing code...
class RegisterUsecaseParams extends Equatable {
  final String authId;
  final String fullName;
  final String email;
  final String username;
  final String password;
  final String? phoneNumber;

  const RegisterUsecaseParams({
    required this.authId,
    required this.fullName,
    required this.email,
    required this.username,
    required this.password,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    username,
    password,
    phoneNumber,
  ];
}
// ...existing code...

//Provider
final registerUsercaseProvider = Provider<RegisterUsecase>((ref){
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParams<bool,RegisterUsecaseParams>{

  final IAuthRepository _authRepository;
  RegisterUsecase({required IAuthRepository authRepository}) 
  :_authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      authId: params.authId,
      fullName: params.fullName,
      email: params.email,
      username: params.username,
      password: params.password,
      phoneNumber: params.phoneNumber,
    );
    return  _authRepository.register(entity);
  }
}