import 'package:dartz/dartz.dart';
import 'package:wra_core/wra_core.dart';

abstract class IGeneralSQLDatasource<IEntity> {
  Future<Either<Failure, int>> save(MapParameter bagParam);

  Future<Either<Failure, bool>> delete(MapParameter bagParam);
  Future<Either<Failure, bool>> update(MapParameter bagParam);
  Future<Either<Failure, IEntity>> selectOne(MapParameter bagParam);
  Future<Either<Failure, IEntity>> selectMany(MapParameter bagParam);
}
