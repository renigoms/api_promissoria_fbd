import 'dart:async';

import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Modules/Cliente/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import '../../Utils/SQLGeral.dart';
import '../Item_Produto/SQL.dart';
import '../Parcela/SQL.dart';

class DAOContrato implements DAOUtilsI {
  // Acesso a Query de criacao da tabela
  @override
  String createTable() => SQLContrato.CREATE_TABLE;
  // Métodos GET:
  /// Todos os contratos
  @override
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapContrato(SQLContrato.SELECT_ALL);

  /// Contratos por id
  @override
  Future<List<Map<String, dynamic>>> getByID(String id) =>
      UtilsGeral.getSelectMapContrato(sprintf(SQLContrato.SELECT_BY_ID, [id]));

  /// contratos pelo cpf do cliente
  Future<List<Map<String, dynamic>>> getByClienteCPF(String cpf) {
    return UtilsGeral.getSelectMapContrato(
        sprintf(SQLContrato.SELECT_BY_CPF_CLIENTE, [cpf]));
  }

  @override
  List<String> requeredItens() => SQLContrato.requeredItens;

  List<String> autoItens() => SQLContrato.autoItens;

  Future<double> _getValorVendaPoduto({int? idProduto}) async {
    if (idProduto != null) {
      final map = await UtilsGeral.getSelectMapProduto(sprintf(
          SQLContrato.SELECT_VAL_PORC_LUCRO_PRODUTO, [idProduto.toString()]));

      double valorVenda =
          (map[0]['valor_unit'] * map[0]['porc_lucro'] + map[0]['valor_unit']);

      return valorVenda;
    }
    return 0;
  }

  Future<double> _calcValorTotalContrato(
      {required List idsProduto, double somatorio = 0, int cont = 0}) async {
    try {
      somatorio += await _getValorVendaPoduto(idProduto: idsProduto[cont]);
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
      if (await UtilsGeral.isClientExists(contrato.id_cliente.toString())) {
        throw ClientException();
      }

      for (int idProdut in contrato.itens_produto!) {
        if (await UtilsGeral.isProductExists(idProdut.toString())) {
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
                await DAOCliente().getByID(contrato.id_cliente.toString()),
            listContrato = await getByClienteCPF(client[0]['cpf']);

        late Map contratoMap;

        for (Map contrato in listContrato) {
          if (!contrato['parcelas_definidas']) {
            contratoMap = contrato;
            break;
          }
        }

        int contSucessParcels = 0, contSucessItensProdut = 0;
        /**
         * Criação dos itens produto
         */

        for (int idProduto in contrato.itens_produto!) {
          double valorVenda = await _getValorVendaPoduto(idProduto: idProduto);

          if (await Cursor.execute(sprintf(SQLItemProduto.CREATE, [
            contratoMap['id'].toString(),
            idProduto.toString(),
            valorVenda.toString()
          ]))) contSucessItensProdut++;
        }

        /**
         * Criação das parcelas
         */

        // data atual com salto de um mês
        DateTime dateToday = DateTime(
            DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);

        // calculo do valor de cada parcela
        double valorParcela = valorContrato / contrato.num_parcelas!;

        // Definição das parcelas de acordo com a quantidade definida no contrato
        for (int i = 0; i < contrato.num_parcelas!; i++) {
          if (await Cursor.execute(sprintf(SQLParcela.CREATE, [
            contratoMap['id'].toString(),
            valorParcela.toString(),
            DateFormat("dd-MM-yyyy").format(dateToday)
          ]))) contSucessParcels++;
          dateToday =
              DateTime(dateToday.year, dateToday.month + 1, dateToday.day);
        }

        if (contSucessParcels == contrato.num_parcelas &&
            contSucessItensProdut == contrato.itens_produto!.length) {
          return await Cursor.execute(sprintf(
              "UPDATE ${SQLContrato.NAME_TABLE} SET parcelas_definidas = TRUE "
              "WHERE ${SQLGeral.ID}=%s;",
              [contratoMap['id'].toString()]));
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
      if (map['status'] == "EM ABERTO") return false;
    }
    return true;
  }

  /// deleta um contrato por id caso não haja parcelas em aberto
  Future<bool> delete(String idContrato) async {
    try {
      if (await UtilsGeral.isContractExists(idContrato)) {
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
