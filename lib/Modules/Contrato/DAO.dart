// ignore_for_file: file_names

import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Modules/Item_Produto/DAO.dart';
import 'package:sistema_promissorias/Modules/Parcela/DAO.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../Item_Produto/SQL.dart';
import '../Parcela/SQL.dart';

class DAOContrato implements DAOUtilsI {
  // Acesso a Query de criacao da tabela
  @override
  @override
  String createTable() => SQLContrato.CREATE_TABLE;
  // Métodos GET:
  /// Todos os contratos
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapContrato(SQLContrato.SELECT_ALL);

  /// Contratos por search
  @override
  Future<List<Map<String, dynamic>>> getBySearch(String search) {
    int isIdNum = int.tryParse(search) ?? 0;

    return UtilsGeral.getSelectMapContrato(
        sprintf(SQLContrato.SELECT_BY_SEARCH, [isIdNum, search]));
  }

  @override
  List<String> requeredItens() => SQLContrato.requeredItens;

  List<String> autoItens() => SQLContrato.autoItens;

  Future<double> _calcValorTotalContrato(
      {required List idsProduto, double somatorio = 0, int cont = 0}) async {
    try {
      somatorio += await UtilsGeral.getValorVendaPoduto(idProduto: idsProduto[cont]);
      cont++;
    } on RangeError {
      return somatorio;
    }

    return await _calcValorTotalContrato(
        idsProduto: idsProduto, somatorio: somatorio, cont: cont);
  }

  /// método post
  Future<bool> postCreate(Contrato contrato) async {
    try {
      if (await UtilsGeral.isNotClientExists(contrato.id_cliente.toString())) {
        throw ClientException();
      }

      for (int idProdut in contrato.itens_produto!) {
        if (await UtilsGeral.isNotProductExists(idProdut.toString())) {
          throw ProductException();
        }
      }

      final valorContrato =
          await _calcValorTotalContrato(idsProduto: contrato.itens_produto!);

      // Criação do contrato
      bool createContrato = await Cursor.execute(sprintf(SQLContrato.CREATE, [
        contrato.id_cliente.toString(),
        contrato.num_parcelas.toString(),
        valorContrato.toString(),
        contrato.descricao
      ]));

      /**
       * AREA DO ITEM PRODUTO
       */

      if (createContrato) {
        List<Map<String, dynamic>> client =
                await DAOCliente().getBySearch(contrato.id_cliente.toString()),
            listContrato = await getBySearch(client[0]['cpf']);

        late Map contratoMap;

        for (Map contrato in listContrato) {
          if (!contrato['parcelas_definidas']) {
            contratoMap = contrato;
            break;
          }
        }

        int contSucessItensProdut = await DAOItemProduto().createItemProduto(
            contrato.id_cliente!, contrato.itens_produto!, contratoMap);

        int contSucessParcels = await DAOParcela().create_parcela(
            valorContrato, contrato.num_parcelas!, contratoMap['id']);

        if (contSucessParcels == contrato.num_parcelas &&
            contSucessItensProdut == contrato.itens_produto!.length) {
          return await Cursor.execute(sprintf(
              SQLContrato.DEFINIR_PARCELAS, [contratoMap['id'].toString()]
          ));
        }
      }

      return false;
    } on ProductException {
      rethrow;
    } on ClientException {
      rethrow;
    } catch (e, s) {
      print("Erro $e ao salvar, tente novamente!");
      print(s);
      return false;
    }
  }

  /// Verificas se existe alguma parcela que esta nesse contrato que ainda esteja
  /// em aberto
  Future<bool> _isFullParcelasPagas(String id) async {
    final listStatusParcela = await UtilsGeral.getSelectMapPacela(
        sprintf(SQLContrato.SELECT_STATUS_PACELAS, [id]));

    for (Map<String, dynamic> map in listStatusParcela) {
      if (!map['paga']) return false;
    }
    return true;
  }

  /// deleta um contrato por id caso não haja parcelas em aberto
  Future<bool> delete(String idContrato) async {
    try {
      if (await UtilsGeral.isNotContractExists(idContrato)) {
        throw ContractException();
      }

      if (await _isFullParcelasPagas(idContrato)) {
        if (await UtilsGeral.executeDelete(
                SQLParcela.DESATIVAR_PARCELAS, idContrato) &&
            await UtilsGeral.executeDelete(
                SQLItemProduto.DESTATIVA_ITEM_PRODUTO, idContrato)) {
          return await UtilsGeral.executeDelete(SQLContrato.DELETE, idContrato);
        }
        throw ForeingKeyException();
      }
      throw OpenInstallmentsException();
    } on ForeingKeyException {
      rethrow;
    } on OpenInstallmentsException {
      rethrow;
    } on IDException {
      rethrow;
    } on ContractException {
      rethrow;
    } catch (e, s) {
      print("Erro ao deletar, $e");
      print(s);
      return false;
    }
  }
}
