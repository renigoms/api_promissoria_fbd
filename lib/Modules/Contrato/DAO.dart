import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

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
      if (UtilsGeral.isKeyMapNull(contrato.toMap(), autoItens())) {
        throw AutoValueException();
      }

      if (UtilsGeral.isKeyMapNotNull(contrato.toMap(), requeredItens())) {
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

      final valor =
          (map[0]['valor_unit'] * map[0]['porc_lucro'] + map[0]['valor_unit']);

      return await Cursor.execute(sprintf(SQLContrato.CREATE, [
        contrato.id_cliente.toString(),
        contrato.id_produto.toString(),
        contrato.num_parcelas.toString(),
        valor.toString(),
        contrato.descricao
      ]));
    } on NullException {
      rethrow;
    } on AutoValueException {
      rethrow;
    } on ProductException {
      rethrow;
    } on ClientException {
      rethrow;
    } on ParcelaDefinidaException {
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
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
        return await UtilsGeral.executeDelete(SQLContrato.DELETE, idContrato);
      }
      throw OpenInstallmentsException();
    } on OpenInstallmentsException {
      rethrow;
    } on IDException {
      rethrow;
    } on ContractException {
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
