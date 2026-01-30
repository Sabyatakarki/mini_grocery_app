import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/core/error/failures.dart';
import 'package:mini_grocery/core/services/connectivity/network_info.dart';
import 'package:mini_grocery/features/profile/data/datasources/remote/profile_remote_datasource.dart';
import 'package:mini_grocery/features/profile/data/datasources/remote/profile_remote_datasource_impl.dart';
import 'package:mini_grocery/features/profile/data/models/profile_api_model.dart';
import 'package:mini_grocery/features/profile/domain/entities/profile_entity.dart';
import 'package:mini_grocery/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<IProfileRepository>((ref) {
  final remoteDataSource = ref.read(profileRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ProfileRepository(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  ProfileRepository({
    required IProfileRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = ProfileApiModel.fromEntity(profile);
        final result = await _remoteDataSource.updateProfile(apiModel);
        return Right(result.toEntity());
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile) async {
    if (await _networkInfo.isConnected) {
      try {
        final imageUrl = await _remoteDataSource.uploadProfilePicture(imageFile);
        return Right(imageUrl);
      } on DioException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'Server error'));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}