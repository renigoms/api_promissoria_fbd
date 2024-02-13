// ignore_for_file: unnecessary_null_comparison

import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'model.dart';

class DAOParcela {
  // Acesso a Query que cria a tabela
  String createTable() => SQLParcela.CREATE_TABLE;

  // Métodos GET:
  /// Parcelas por id do contrato
  Future<List<Map<String, dynamic>>> getByIdContrato(String id_contrato) =>
      UtilsGeral.getSelectMapPacela(
          sprintf(SQLParcela.SELECT_BY_ID_CONTRATO, [id_contrato]));

  Future<List<Map<String, dynamic>>> getByDataPag(
          String idContrato, String dataPag) =>
      UtilsGeral.getSelectMapPacela(sprintf(
          SQLParcela.SELECT_BYCONTRATO_AND__DATA_PAG, [idContrato, dataPag]));

  static List<String> autoItens() => SQLParcela.autoItens;

  /// verifica a inexistência de atributos nulos em parcela exeto status
  bool _isStatusOnly(Parcela parcela) =>
      UtilsGeral.isAutoItensNotNull(parcela.toMap(), autoItens()) ||
      parcela.status == null;

  /// Apenas o status pode ser alterado na parcela
  Future<bool> putUpdate(
      Parcela parcela, String idContrato, String dataPag) async {
    try {
      if (idContrato == null ||
          idContrato.isEmpty ||
          dataPag == null ||
          dataPag.isEmpty) {
        throw IDException();
      }
      if (_isStatusOnly(parcela)) throw NoAlterException();

      if (await UtilsGeral.isContractExists(idContrato)) {
        throw ContractException();
      }

      if (await UtilsGeral.isParcelaExists(idContrato, dataPag)) {
        throw ParcelaException();
      }

      final oldParcela = await getByDataPag(idContrato, dataPag);

      String status =
          UtilsGeral.getValUpdate(oldParcela[0]['status'], parcela.status);

      return await Cursor.execute(
          sprintf(SQLParcela.UPDATE, [status, idContrato, dataPag]));
    } on NoAlterException {
      rethrow;
    } on IDException {
      rethrow;
    } on ContractException {
      rethrow;
    } on ParcelaException {
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }
}
