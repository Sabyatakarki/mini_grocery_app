import 'package:dartz/dartz.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

abstract interface class IBatchRepository {
  Future<Either<Failures, List<BatchEntity>>> getAllBatches();
  Future<Either<Failures, BatchEntity>> getBatchById
  (String batchId);
  Future<Either<Failures, bool>> createBatch(BatchEntity entity);
  Future<Either<Failures, bool>> updateBatch(BatchEntity entity);
  Future<Either<Failures, bool>> deleteBatch(String batchId);

}