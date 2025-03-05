import 'package:dartz/dartz.dart';
import 'package:postgres/postgres.dart';
import 'package:wra_core/wra_core.dart';
import 'package:wra_core_data/wra_core_data.dart';
import 'package:wra_entity_interface/wra_entity_interface.dart';

import '../../DB/pgsql/postgresdb.dart';
import '../interface/general_sql_datasource_interface.dart';

class CRUDGeneralSQLDatasource implements IGeneralSQLDatasource {
  PostgresDB datasource;

  CRUDGeneralSQLDatasource({required this.datasource});

  @override
  Future<Either<Failure, int>> save(bagParam) async {
    try {
      var entity = bagParam.entity;
      var params = entity.values();

      params.removeAt(0);
      if (bagParam.sentence.isEmpty) {
        bagParam.sentence = insertSQL(bagParam);
      }
      String sentenca = bagParam.sentence;
      Connection conn = await datasource.conexao();
      var result = await conn.execute(
        sentenca,
        parameters: params,
      );
      List ultimoId = result.toList();
      conn.close();
      return (result.affectedRows > 0)
          ? Right(ultimoId[0][0])
          : Left(Failure(
              key: ReturnErrors.datasource,
              message:
                  "Erro na gravação do Registro - Metodo: SAVE em CRUDGeneralSQLDatasource."));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.datasource,
          message: "CATCH $e - Metodo: SAVE em CRUDGeneralSQLDatasource."));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(bagParam) async {
    try {
      if (bagParam.sentence.isEmpty) {
        bagParam.sentence = deleteSQL(bagParam);
      }
      String sentenca = bagParam.sentence;
      List params = bagParam.whereSQLValues.toList();
      Connection conn = await datasource.conexao();
      var result = await conn.execute(
        sentenca,
        parameters: params,
      );

      return (result.affectedRows > 0)
          ? Right(true)
          : Left(Failure(
              key: ReturnErrors.datasource,
              message:
                  "Erro na exclusão  do Registro - Metodo: DELETE em CRUDGeneralSQLDatasource. "));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.datasource,
          message:
              "Erro na exclusao do Registro: $e - Metodo: DELETE em CRUDGeneralSQLDatasource "));
    }
  }

  @override
  Future<Either<Failure, bool>> update(bagParam) async {
    try {
      if (bagParam.sentence.isEmpty) {
        bagParam.sentence = updateSQL(bagParam);
      }
      String sentenca = bagParam.sentence;
      List params = bagParam.paramSQL.values.toList();
      params.addAll(bagParam.whereSQLValues.toList());
      Connection conn = await datasource.conexao();
      var result = await conn.execute(
        sentenca,
        parameters: params,
      );

      return (result.affectedRows > 0)
          ? Right(true)
          : Left(Failure(
              key: ReturnErrors.datasource,
              message:
                  "Erro na atualização  do Registro - Metodo: UPDATE em CRUDGeneralSQLDatasource. "));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.datasource,
          message:
              "Erro na atualização do Registro - Metodo: UPDATE em CRUDGeneralSQLDatasource. "));
    }
  }

  // Retorna o primeiro elemento da lista de listMaps
  @override
  Future<Either<Failure, IEntity>> selectOne(bagParam) async {
    try {
      if (bagParam.sentence.isEmpty) {
        bagParam.sentence = selectSQL(bagParam);
      }
      String sentenca = bagParam.sentence;
      Map<String, dynamic> params =
          bagParam.where.isNotEmpty ? bagParam.where : {};
      Connection conn = await datasource.conexao();
      var result = await conn.execute(
        Sql.named(sentenca),
        parameters: params,
      );

      //List<String> field = bagParam.entity.fields()!;
      int tam = result.toList().length;
      List myList = result.toList();
      for (int i = 0; i < tam; i++) {
        bagParam.listValues2Map(myList[i]);
      }
      bagParam.listMap2Entity();
      return (bagParam.listMaps.isNotEmpty)
          ? Right(bagParam.listEntities.first)
          : Left(Failure(
              key: ReturnErrors.datasource,
              message:
                  "Erro na select do Registro - Metodo: SELECT em CRUDGeneralSQLDatasource. "));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.datasource,
          message:
              "Erro na select do Registro - Metodo: SELECT em CRUDGeneralSQLDatasource. "));
    }
  }

  // Retorna o primeiro elemento da lista de listMaps
  @override
  Future<Either<Failure, List<IEntity>>> selectMany(bagParam) async {
    try {
      if (bagParam.sentence.isEmpty) {
        bagParam.sentence = selectSQL(bagParam);
      }
      String sentenca = bagParam.sentence;
      Map<String, dynamic> params =
          bagParam.where.isNotEmpty ? bagParam.where : {};
      Connection conn = await datasource.conexao();
      var result = await conn.execute(
        Sql.named(sentenca),
        parameters: params,
      );

      int tam = result.toList().length;
      List myList = result.toList();
      for (int i = 0; i < tam; i++) {
        bagParam.listValues2Map(myList[i]);
      }
      bagParam.listMap2Entity();
      return (bagParam.listMaps.isNotEmpty)
          ? Right(bagParam.listEntities)
          : Left(Failure(
              key: ReturnErrors.datasource,
              message:
                  "Erro na select do Registro - Metodo: SELECT em CRUDGeneralSQLDatasource. "));
    } catch (e) {
      return Left(Failure(
          key: ReturnErrors.datasource,
          message:
              "Erro na select do Registro - Metodo: SELECT em CRUDGeneralSQLDatasource. "));
    }
  }

  Future<Either<Failure, int>> getCount() {
    throw UnimplementedError();
  }
}
