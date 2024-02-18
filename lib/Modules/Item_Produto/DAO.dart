
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'SQL.dart';

class DAOItemProduto{

  String createTable() => SQLItemProduto.CREATE_TABLE;

  Future<List<Map<String, dynamic>>> getById(String id_contrato)=>
      UtilsGeral.getSelectMapItemProduto(
        sprintf(SQLItemProduto.SELECT_BY_ID_CONTRATO, [id_contrato])
      );
}