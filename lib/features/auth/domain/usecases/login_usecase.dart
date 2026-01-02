import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:mini_grocery/core/usecases/app_usecase.dart';
import 'package:mini_grocery/features/auth/data/repositories/auth_repository.dart';
import 'package:mini_grocery/features/auth/domain/entities/auth_entity.dart';
import 'package:mini_grocery/features/auth/domain/repositories/auth_repository.dart';


class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUseCase(authRepository: authRepository);
});

class LoginUseCase implements UsecaseWithParams<AuthEntity, LoginParams> {
  final IAuthRepository _authRepository;

  LoginUseCase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) {
    return _authRepository.login(params.email, params.password);
  }
}