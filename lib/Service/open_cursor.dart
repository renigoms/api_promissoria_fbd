import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Modules/Produto/DAO.dart';
import 'package:sistema_promissorias/Service/connectDB.dart';

class Cursor {
  static const Map _dataMap = {
    "database": "promissorias_fbd",
    "username": "postgres",
    "password": "rngazrcb"
  };

  /// Apenas faz execuções que não retornam informações
  static Future<bool> execute(String sqlComand) async {
    try {
      final cursor =
          await ConnectDataBase.connectionMap(_dataMap).getConnection();
      await cursor!.execute(sqlComand);
      return true;
    }on PgException{
      rethrow;
    } catch (e) {
      print("Erro ao executa a query solicitada, ${e.toString()}");
      return false;
    }
  }

  /// Faz execuções com retorno de informações
  static Future<Result?> query(String sqlComand) async {
    try {
      final cursor =
          await ConnectDataBase.connectionMap(_dataMap).getConnection();
      return await cursor!.execute(sqlComand);
    } catch (e) {
      print("Erro ao executa a query solicitada, ${e.toString()}");
      return null;
    }
  }

  /// Cria todas as tabelas do banco caso não existam
  static Future<bool> initTables() async {
    try {
     return await execute(DAOClientes().createTable())&&
      await execute(DAOProduto().createTable())&&
      await execute(DAOContrato().createTable())&&
      await execute(DAOParcela().createTable());
    } catch (e) {
      print('Falha ao iniciar tabelas, ${e.toString()}');
      return false;
    }
  }
}
