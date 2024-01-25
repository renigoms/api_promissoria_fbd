

import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/model.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../Service/exceptions.dart';

class DAOProduto implements DAOUtilsI {
  /// Acesso a Query que cria a tabela
  @override
  String createTable() => SQLProduto.CREATE_TABLE;

  // Métodos GET
  /// Todos os produtos
  @override
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapProduto(SQLProduto.SELECT_ALL);

  /// produtos por id
  @override
  Future<List<Map<String, dynamic>>> getByID(String id) =>
      UtilsGeral.getSelectMapProduto(sprintf(SQLProduto.SELECT_BY_ID, [id]));
  /// produtos por nome
  Future<List<Map<String, dynamic>>> getByName(String name) {
    final name_replace = name.replaceAll("%20", " ");
    return UtilsGeral.getSelectMapProduto(
        sprintf(SQLProduto.SELECT_BY_NAME, [name_replace]));
  }

  /// Método post
  Future<bool> postCreate(Produto produto) async {
    try {
      if(produto.nome == null || produto.unid_medida == null
      || produto.valor_unit == null)throw NullException();
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
    } on PgException catch (e) {
      if (e.message
          .contains("duplicar valor da chave viola a restrição de unicidade")) {
        rethrow;
      }
      return false;
    }on NullException{
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }
  /// Método de update
  Future<bool> putUpdate(Produto produto, String id) async {
    try {
      // ignore: unnecessary_null_comparison
      if (id == null || id.isEmpty) throw IDException();
      List oldProduto = await getByID(id);

      if(produto.id!=null)throw NoAlterException();

      String nome =
              UtilsGeral.getValUpdate(oldProduto[0]['nome'], produto.nome),
          unid_medida = UtilsGeral.getValUpdate(
              oldProduto[0]['unid_medida'], produto.unid_medida),
          valor_unit = UtilsGeral.getValUpdate(
                  oldProduto[0]['valor_unit'], produto.valor_unit)
              .toString(),
          porc_lucro = UtilsGeral.getValUpdate(
                  oldProduto[0]['porc_lucro'], produto.porc_lucro)
              .toString();

      return await Cursor.execute(sprintf(
          SQLProduto.UPDATE, [nome, unid_medida, valor_unit, porc_lucro, id]));
    } on IDException {
      rethrow;
    }on NoAlterException{
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }

  /// Método de delete
  Future<bool> deleteProduto(String id) async {
    try {
      return await UtilsGeral.executeDelete(SQLProduto.DELETE, id);
    } on IDException {
      rethrow;
    }on PgException{
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
