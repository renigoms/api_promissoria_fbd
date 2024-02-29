
// ignore_for_file: file_names

import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../Service/open_cursor.dart';
import 'SQL.dart';

class DAOItemProduto{

  String createTable() => SQLItemProduto.CREATE_TABLE;

  Future<List<Map<String, dynamic>>> getById(String idContrato)=>
      UtilsGeral.getSelectMapItemProduto(
        sprintf(SQLItemProduto.SELECT_BY_ID_CONTRATO, [idContrato])
      );

  Future<int> createItemProduto(int idCliente, List itensProduto, Map contratoMap) async{

    int contSucessItensProdut = 0;
    /**
     * Criação dos itens produto
     */

    for (int idProduto in itensProduto) {
      double valorVenda = await UtilsGeral.getValorVendaPoduto(idProduto: idProduto);

      if (await Cursor.execute(sprintf(SQLItemProduto.CREATE, [
        contratoMap['id'].toString(),
        idProduto.toString(),
        valorVenda.toString()
      ]))) contSucessItensProdut++;
    }

    return contSucessItensProdut;
  }
}