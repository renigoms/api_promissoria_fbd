

import 'package:sistema_promissorias/Modules/Cliente/model.dart';
import 'package:sprintf/sprintf.dart';

import '../Modules/Contrato/model.dart';
import '../Modules/Produto/model.dart';
import '../Service/exceptions.dart';
import '../Service/open_cursor.dart';

abstract interface class DAOUtilsI{
  String createTable();

  Future<List<Map<String, dynamic>>>getAll();
  Future<List<Map<String, dynamic>>> getByID(String id);
}

abstract class UtilsGeral{
  static bool isKeysExists(String key, Map map) {
    for (String isKey in map.keys) {
      if (isKey == key) return true;
    }
    return false;
  }

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  static Future<List<Map<String, dynamic>>> getSelectMapCliente(String query) async {
    final dados = await Cursor.query(query);
    final listMapDados =
    dados!.map((element) => element.toColumnMap()).toList();
    return [
      for (Map<String, dynamic> map in listMapDados) Cliente.byMap(map).toMap()
    ];
  }

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  static Future<List<Map<String, dynamic>>> getSelectMapProduto(String query) async {
    final dados = await Cursor.query(query);
    final listMapDados =
    dados!.map((element) => element.toColumnMap()).toList();
    return [
      for (Map<String, dynamic> map in listMapDados) Produto.byMap(map).toMap()
    ];
  }

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  static Future<List<Map<String, dynamic>>> getSelectMapContrato(String query) async {
    final dados = await Cursor.query(query);
    final listMapDados =
    dados!.map((element) => element.toColumnMap()).toList();
    return [
      for (Map<String, dynamic> map in listMapDados) Contrato.byMap(map).toMap()
    ];
  }

  static dynamic getValUpdate(var oldValue, var newValue) => newValue ?? oldValue;

  static Future<bool> executeDelete(String sqlDelete, String index) async{
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
}