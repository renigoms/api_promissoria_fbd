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
  /// método post
  Future<bool> postCreate(Contrato contrato) async {
    try {
      if (contrato.id_cliente == null ||
          contrato.id_produto == null ||
          contrato.num_parcelas == null ||
          contrato.descricao == null) {
        throw NullException();
      }
      final valor_unit_and_porc_lucro = sprintf(
          SQLContrato.SELECT_VAL_PORC_LUCRO_PRODUTO, [contrato.id_produto]);

      final map =
          await UtilsGeral.getSelectMapProduto(valor_unit_and_porc_lucro);

      final qnt_produto = contrato.qnt_produto;

      final valor =
          (map[0]['valor_unit'] * map[0]['porc_lucro'] + map[0]['valor_unit']) *
              qnt_produto;

      return await Cursor.execute(sprintf(SQLContrato.CREATE, [
        contrato.id_cliente.toString(),
        contrato.id_produto.toString(),
        contrato.num_parcelas.toString(),
        contrato.qnt_produto.toString(),
        valor.toString(),
        contrato.descricao
      ]));
    } on NullException {
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
  Future<bool> delete(String id) async {
    try {
      if (await _isFullParcelasPagas(id)) {
        return await UtilsGeral.executeDelete(SQLContrato.DELETE, id);
      }
      throw ParcelasEmAbertoExcerption();
    } on ParcelasEmAbertoExcerption {
      rethrow;
    } on IDException {
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
