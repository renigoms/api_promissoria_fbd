

import 'package:sistema_promissorias/Modules/Cliente/model.dart';

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

  static dynamic getValUpdate(var oldValue, var newValue) => newValue ?? oldValue;
}