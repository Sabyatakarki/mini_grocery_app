import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  return BatchRepository(datasource: ref.read(batchLocalDataSourceProvider));
}); // Provider

class BatchRepository implements IBatchRepository {
  final IBatchDataSource _dataSource;

  BatchRepository({required IBatchDataSource datasource})
    : _dataSource = datasource;

  @override
  Future<Either<Failures, bool>> createBatch(BatchEntity entity) async {
    try {
      final model = BatchHiveModel.fromEntity(entity);
      final result = await _dataSource.createBatch(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDataBaseFailure(message: 'Failed to create batch'));
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, bool>> deleteBatch(String batchId) async {
    try {
      final result = await _dataSource.deleteBatch(batchId);
      if (result) {
        return Right(true);
      }
      return Left(LocalDataBaseFailure(message: 'Failed to delete branch'));
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<BatchEntity>>> getAllBatches() async {
    try {
      final models = await _dataSource.getAllBatches();
      final entities = BatchHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, BatchEntity>> getBatchById(String batchId) async {
    try {
      final model = await _dataSource.getBatchById(batchId);
      if (model != null) {
        return Right(model.toEntity());
      }
      return Left(LocalDataBaseFailure(message: 'Batch not found'));
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failures, bool>> updateBatch(BatchEntity entity) async {
    try {
      final model = BatchHiveModel.fromEntity(entity);
      final result = await _dataSource.updatedBatch(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDataBaseFailure(message: 'Failed to update batch'));
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }
}