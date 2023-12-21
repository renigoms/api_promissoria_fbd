import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';

class DAOParcela implements DAOUtilsI{
  @override
  String createTable() {
    return SQLParcela.CREATE_TABLE;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getByID(String id) {
    // TODO: implement getByID
    throw UnimplementedError();
  }

}