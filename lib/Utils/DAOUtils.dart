import 'package:sistema_promissorias/Modules/Cliente/model.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/model.dart';
import 'package:sprintf/sprintf.dart';

import '../Modules/Cliente/DAO.dart';
import '../Modules/Contrato/DAO.dart';
import '../Modules/Contrato/SQL.dart';
import '../Modules/Contrato/model.dart';
import '../Modules/Item_Produto/model.dart';
import '../Modules/Produto/DAO.dart';
import '../Modules/Produto/model.dart';
import '../Service/exceptions.dart';
import '../Service/open_cursor.dart';

abstract interface class DAOUtilsI {
  String createTable();
  Future<List<Map<String, dynamic>>> getAll();
  Future<List<Map<String, dynamic>>> getBySearch(String search);
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
    final listMap = dados!.map((element) => element.toColumnMap()).toList();
    for (Map element in List.from(listMap)) {
      if (element['ativo'] != null) {
        if (!element['ativo']) {
          listMap.remove(element);
        }
      }
    }
    return listMap;
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

  /// ListMap ItemProduto
  static Future<List<Map<String, dynamic>>> getSelectMapItemProduto(
          String query) async =>
      [
        for (Map<String, dynamic> map in await UtilsGeral._getSelectMap(query))
          ItemProduto.byMap(map).toMap()
      ];

  /// Recebe dois valores, oldValue e newValue, se newValue não for nulo ele
  /// será retornado se não oldValue será retornado
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

  static Future<bool> isNotProductExists(String idProduct) async {
    final getProduct = await DAOProduto().getBySearch(idProduct);
    return getProduct.isEmpty;
  }

  static Future<bool> isNotClientExists(String idClient) async {
    final getClient = await DAOCliente().getBySearch(idClient);
    return getClient.isEmpty;
  }

  ///Verifica se o contrato existe na base
  static Future<bool> isNotContractExists(String idContrato) async {
    final getContrato = await DAOContrato().getBySearch(idContrato);
    return getContrato.isEmpty;
  }

  static Future<bool> isNotParcelaExists(
      String idContrato, String dataPag) async {
    final getParcelela = await DAOParcela().getByDataPag(idContrato, dataPag);
    return getParcelela.isEmpty;
  }

  static bool isRequeredItensNull(
      Map<String, dynamic> map, List<String> listRequeredElements) {
    List itens = [null, "", 0, 0.0];
    for (var camp in listRequeredElements) {
      if (itens.contains(map[camp])) return true;
    }
    return false;
  }

  static bool isAutoItensNotNull(
      Map<String, dynamic> map, List<String> listAutoElements) {
    for (String camp in listAutoElements) {
      if (map[camp] != null) return true;
    }
    return false;
  }

  /// Adiciona % dos lados de %s
  static String addSides(
          {required addItem, required String textBase, ambosLados = true}) =>
                ambosLados ? addItem + textBase + addItem: textBase + addItem;

  static Future<double> getValorVendaPoduto({int? idProduto}) async {
    if (idProduto != null) {
      final map = await UtilsGeral.getSelectMapProduto(sprintf(
          SQLContrato.SELECT_VAL_PORC_LUCRO_PRODUTO, [idProduto.toString()]));

      double valorVenda =
          (map[0]['valor_unit'] * map[0]['porc_lucro'] + map[0]['valor_unit']);

      return valorVenda;
    }
    return 0;
  }
}
