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
    final nameReplace = name.replaceAll("%20", " ");
    return UtilsGeral.getSelectMapProduto(sprintf(
        SQLProduto.SELECT_BY_NAME, [UtilsGeral.addSides("%", nameReplace)]));
  }

  @override
  List<String> requeredItens() => SQLProduto.requeredItens;

  /// Método post
  Future<bool> postCreate(Produto produto) async {
    try {
      if (produto.id != null) throw IDException();
      if (UtilsGeral.isRequeredItensNull(
          produto.toMap(), SQLProduto.requeredItens)) {
        throw NullException();
      }
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
        String query =
            sprintf(SQLProduto.SELECT_COL_ATIVO_PRODUTO, [produto.nome]);
        final listColAtivo = await Cursor.query(query);
        if (listColAtivo![0][0] != true) {
          if (await Cursor.execute(
              sprintf(SQLProduto.ACTIVE_PRODUTO, [produto.nome]))) {
            await putUpdate(produto, listColAtivo[0][1].toString());
            throw reactiveException();
          }
        }
        rethrow;
      }
      return false;
    } on reactiveException {
      rethrow;
    } on NullException {
      rethrow;
    } on IDException {
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

      if (await UtilsGeral.isProductExists(id)) throw ProductException();

      List oldProduto = await getByID(id);

      if (produto.id != null) throw NoAlterException();

      String nome =
              UtilsGeral.getValUpdate(oldProduto[0]['nome'], produto.nome),
          unidMedida = UtilsGeral.getValUpdate(
              oldProduto[0]['unid_medida'], produto.unid_medida),
          valorUnit = UtilsGeral.getValUpdate(
                  oldProduto[0]['valor_unit'], produto.valor_unit)
              .toString(),
          porcLucro = UtilsGeral.getValUpdate(
                  oldProduto[0]['porc_lucro'], produto.porc_lucro)
              .toString();

      return await Cursor.execute(sprintf(
          SQLProduto.UPDATE, [nome, unidMedida, valorUnit, porcLucro, id]));
    } on PgException {
      rethrow;
    } on IDException {
      rethrow;
    } on NoAlterException {
      rethrow;
    } on ProductException {
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
      if (await UtilsGeral.isProductExists(id)) throw ProductException();

      final produtoComContrato =
          await Cursor.query(SQLProduto.SELECT_ID_PRODUTO_IN_CONTRATO);

      for (List idProdutoList in produtoComContrato!) {
        if (idProdutoList[0] == int.parse(id)) {
          String query =
              sprintf(SQLProduto.SELECT_ATIVO_CONTRATO_BY_ID_PRODUTO, [id]);

          final isContratoAtivo = await Cursor.query(query);

          for (List ativoList in isContratoAtivo!) {
            if (ativoList[0]) {
              throw ForeingKeyException();
            }
          }
        }
      }
      return await UtilsGeral.executeDelete(SQLProduto.DELETE, id);
    } on IDException {
      rethrow;
    } on ForeingKeyException {
      rethrow;
    } on ProductException {
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
