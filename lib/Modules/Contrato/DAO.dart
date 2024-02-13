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

  List<String> idOnly() => SQLContrato.idOnly;

  /// método post
  Future<bool> postCreate(Contrato contrato) async {
    try {
      if (UtilsGeral.isAutoItensNotNull(contrato.toMap(), autoItens())) {
        throw AutoValueException();
      }

      if (UtilsGeral.isRequeredItensNull(contrato.toMap(), requeredItens())) {
        throw NullException();
      }

      if (await UtilsGeral.isClientExists(contrato.id_cliente.toString())) {
        throw ClientException();
      }

      if (await UtilsGeral.isProductExists(contrato.id_produto.toString())) {
        throw ProductException();
      }

      final valorUnitAndPorcLucro = sprintf(
          SQLContrato.SELECT_VAL_PORC_LUCRO_PRODUTO, [contrato.id_produto]);

      final map = await UtilsGeral.getSelectMapProduto(valorUnitAndPorcLucro);

      double valorContrato =
          (map[0]['valor_unit'] * map[0]['porc_lucro'] + map[0]['valor_unit']);

      bool createContrato = await Cursor.execute(sprintf(SQLContrato.CREATE, [
        contrato.id_cliente.toString(),
        contrato.id_produto.toString(),
        contrato.num_parcelas.toString(),
        valorContrato.toString(),
        contrato.descricao
      ]));

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

        int contSucess = 0;

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
          ]))) contSucess++;
          dateToday =
              DateTime(dateToday.year, dateToday.month + 1, dateToday.day);
        }

        // Se tudo deu certo o status de parcelas definidas em contrato fica true
        return contSucess == contrato.num_parcelas
            ? await Cursor.execute(sprintf(
                "UPDATE ${SQLContrato.NAME_TABLE} SET parcelas_definidas = TRUE "
                "WHERE ${SQLGeral.ID}=%s;",
                [contratoMap['id'].toString()]))
            : false;
      }

      return false;
    } on NullException {
      rethrow;
    } on AutoValueException {
      rethrow;
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
        String query = sprintf(SQLContrato.DESATIVAR_PARCELAS, [idContrato]);
        if (await Cursor.execute(query)) {
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
