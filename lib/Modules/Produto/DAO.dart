import 'package:postgres/legacy.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/model.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../Service/exceptions.dart';

class DAOProduto implements DAOUtilsI {
  @override
  String createTable() => SQLProduto.CREATE_TABLE;



  @override
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapProduto(SQLProduto.SELECT_ALL);


  @override
  Future<List<Map<String, dynamic>>> getByID(String id) =>
      UtilsGeral.getSelectMapProduto(sprintf(SQLProduto.SELECT_BY_ID, [id]));


  Future<List<Map<String, dynamic>>> getByName(String name) {
    final name_replace = name.replaceAll("%20", " ");
    return UtilsGeral.getSelectMapProduto(sprintf(SQLProduto.SELECT_BY_NAME, [name_replace]));
  }

  Future<bool> postCreateProduto(Produto produto) async {
    try {
      String query = produto.porc_lucro == null
          ? sprintf(SQLProduto.CREATE_WITH_PORC_LUCRO_DEFAULT, [
              produto.nome,
              produto.unid_medida,
              produto.valor_unit.toString()
            ])
          : sprintf(SQLProduto.CREATE_WITH_PORC_LUCRO, [
              produto.nome,
              produto.unid_medida,
              produto.valor_unit.toString(),
              produto.porc_lucro.toString()
            ]);
      return await Cursor.execute(query);
    } on PostgreSQLException catch (e) {
      if (e.message
          .contains("duplicate key value violates unique constraint")) {
        rethrow;
      }
      return false;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  Future<bool> putUpdateProduto(Produto produto) async{
    try{

      List oldProduto = await getByID(produto.id.toString());

      String id = produto.id.toString(),
      nome = UtilsGeral.getValUpdate(oldProduto[0]['nome'],
          produto.nome),
      unid_medida = UtilsGeral.getValUpdate(oldProduto[0]['unid_medida'],
          produto.unid_medida),
      valor_unit = UtilsGeral.getValUpdate(oldProduto[0]['valor_unit'],
          produto.valor_unit).toString(),
      porc_lucro = UtilsGeral.getValUpdate(oldProduto[0]['porc_lucro'],
          produto.porc_lucro).toString();

      String query = sprintf(SQLProduto.UPDATE,
      [
        nome, unid_medida, valor_unit, porc_lucro, id
      ]);

      return await Cursor.execute(query);
    }on IDException {
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }

  Future<bool> deleteProduto(String id) async{
    try{
      return await UtilsGeral.executeDelete(SQLProduto.DELETE, id);
    }on IDException{
      rethrow;
    }catch(e){
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
