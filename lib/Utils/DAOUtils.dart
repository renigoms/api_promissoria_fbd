import 'package:sistema_promissorias/Modules/Cliente/model.dart';
import 'package:sistema_promissorias/Modules/Parcela/model.dart';
import 'package:sprintf/sprintf.dart';

import '../Modules/Cliente/DAO.dart';
import '../Modules/Contrato/DAO.dart';
import '../Modules/Contrato/model.dart';
import '../Modules/Produto/DAO.dart';
import '../Modules/Produto/model.dart';
import '../Service/exceptions.dart';
import '../Service/open_cursor.dart';

abstract interface class DAOUtilsI {
  String createTable();
  Future<List<Map<String, dynamic>>> getAll();
  Future<List<Map<String, dynamic>>> getByID(String id);
  List<String> requeredItens();
}

abstract class UtilsGeral {
  // Verifica se uma determinada chave existe em Map
  static bool isKeysExists(String key, Map map) {
    for (String isKey in map.keys) {
      if (isKey == key) return true;
    }
    return false;
  }

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  static Future<List<Map<String, dynamic>>> _getSelectMap(String query) async {
    final dados = await Cursor.query(query);
    return dados!.map((element) => element.toColumnMap()).toList();
  }

  ///ListMap Clinte
  static Future<List<Map<String, dynamic>>> getSelectMapCliente(
          String query) async =>
      [
        for (Map<String, dynamic> map in await UtilsGeral._getSelectMap(query))
          Cliente.byMap(map).toMap()
      ];

  ///ListMap Produto
  static Future<List<Map<String, dynamic>>> getSelectMapProduto(
          String query) async =>
      [
        for (Map<String, dynamic> map in await UtilsGeral._getSelectMap(query))
          Produto.byMap(map).toMap()
      ];

  ///ListMap Contrato
  static Future<List<Map<String, dynamic>>> getSelectMapContrato(
          String query) async =>
      [
        for (Map<String, dynamic> map in await UtilsGeral._getSelectMap(query))
          Contrato.byMap(map).toMap()
      ];

  ///ListMap Parcela
  static Future<List<Map<String, dynamic>>> getSelectMapPacela(
          String query) async =>
      [
        for (Map<String, dynamic> map in await UtilsGeral._getSelectMap(query))
          Parcela.byMap(map).toMap()
      ];

  // Recebe dois valores, oldValue e newValue, se newValue não for nulo ele
  // será retornado se não oldValue será retornado
  static dynamic getValUpdate(var oldValue, var newValue) =>
      newValue ?? oldValue;

  // ação de delete em um BD
  static Future<bool> executeDelete(String sqlDelete, String index) async {
    try {
      if (index.isEmpty) throw IDException();
      final query = sprintf(sqlDelete, [index]);
      return await Cursor.execute(query);
    } on IDException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isProductExists(String idProduct) async {
    final getProduct = await DAOProduto().getByID(idProduct);
    return getProduct.isEmpty;
  }

  static Future<bool> isClientExists(String idClient) async {
    final getClient = await DAOCliente().getByID(idClient);
    return getClient.isEmpty;
  }

  ///Verifica se o contrato existe na base
  static Future<bool> isContractExists(String idContrato) async {
    final getContrato = await DAOContrato().getByID(idContrato);
    return getContrato.isEmpty;
  }
}
