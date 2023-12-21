import 'package:sistema_promissorias/Modules/Produto/SQL.dart';
import 'package:sistema_promissorias/Modules/Produto/model.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

class DAOProduto implements DAOUtilsI {
  @override
  String createTable() => SQLProduto.CREATE_TABLE;

  /// Método estático que tem como objetivo transformar o retorno de querys
  /// do tipo SELECT em uma lista de maps
  Future<List<Map<String, dynamic>>> _getSelectMap(String query) async {
    final dados = await Cursor.query(query);
    final listMapDados =
        dados!.map((element) => element.toColumnMap()).toList();
    return [
      for (Map<String, dynamic> map in listMapDados) Produto.bymap(map).toMap()
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    String query = SQLProduto.SELECTALL;
    return _getSelectMap(query);
  }

  @override
  Future<List<Map<String, dynamic>>> getByID(String id) {
    String query = sprintf(SQLProduto.SELECTBYID, [id]);
    return _getSelectMap(query);
  }

  Future<List<Map<String, dynamic>>> getByName(String name) {
    final name_replace = name.replaceAll("%20", " ");
    String query = sprintf(SQLProduto.SELECTBYNAME, [name_replace]);
    return _getSelectMap(query);
  }
}
