import 'package:dartz/dartz.dart';
import 'package:wra_core/wra_core.dart';
import 'package:wra_core_data/wra_core_data.dart';
import 'package:wra_domain_interface/wra_domain_interface.dart';
//import 'package:wra_entity_interface/wra_entity_interface.dart';
import 'package:wra_repository_interface_sql/wra_repository_interface_sql.dart';

import '../datasources/interface/general_sql_datasource_interface.dart';

class GeneralSQLRepositoryImpl implements IGeneralSQLRepository<IDomain> {
  //
  final IGeneralSQLDatasource datasource;
  //
  //GeneralMapperImpl mapper;
  //
  GeneralSQLRepositoryImpl({required this.datasource});
  //
  @override
  Future<Either<Failure, int>> create(bagParam) async {
    try {
      var mapper =
          GeneralMapperImpl(entidade: bagParam.entity, modelo: bagParam.model);
      bagParam.entity = mapper.getEntityMapper(bagParam.model);
      var results = await datasource.save(bagParam);
      return results.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.repository,
          message:
              'Erro:  $e   no repositorio MasterContaCorrenteRepositoryImpl - Método: CREATE'));
    }
  }

  @override
  Future<Either<Failure, bool>> update(bagParam) async {
    try {
      var mapper =
          GeneralMapperImpl(entidade: bagParam.entity, modelo: bagParam.model);
      bagParam.entity = mapper.getEntityMapper(bagParam.model);
      final result = await datasource.update(bagParam);
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.repository,
          message:
              'Erro:  $e   no repositorio MasterContaCorrenteRepositoryImpl - Método: UPDATE'));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(bagParam) async {
    try {
      final result = await datasource.delete(bagParam);
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.repository,
          message:
              'Erro:  $e   no repositorio MasterContaCorrenteRepositoryImpl - Método: DELETE'));
    }
  }

  @override
  Future<Either<Failure, List<IDomain>>> getMany(bagParam) async {
    try {
      // mapper => Mapeia as entidades (Banco Dados) para o dominio (Usecases)
      var mapper =
          GeneralMapperImpl(entidade: bagParam.entity, modelo: bagParam.model);
      var result = await datasource.selectMany(bagParam);
      return result.fold((l) => Left(l),
          (r) => Right(mapper.getListModelMapper(bagParam.listEntities)));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.repository,
          message:
              'Erro:  $e   no repositorio GeneralGetRepository - Método: GETBYID'));
    }
  }

  @override
  Future<Either<Failure, IDomain>> getOne(bagParam) async {
    try {
      var mapper =
          GeneralMapperImpl(entidade: bagParam.entity, modelo: bagParam.model);
      var result = await datasource.selectOne(bagParam);

      return result.fold((l) => Left(l),
          (r) => Right(mapper.getModelMapper(bagParam.listEntities.first)));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.repository,
          message:
              'Erro:  $e   no repositorio MasterContaCorrenteRepositoryImpl - Método: GETBYID'));
    }
  }
}
