// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Modules/Contrato/DAO.dart';
import 'package:sistema_promissorias/Modules/Contrato/SQL.dart';
import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sistema_promissorias/Utils/SQLGeral.dart';
import 'package:sprintf/sprintf.dart';

import '../Contrato/model.dart';
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

  /// verifica a inexistência de atributos nulos no contrato
  bool _isNoAlterContrato(Contrato contrato) =>
      UtilsGeral.isNullKeyMap(contrato.toMap(), DAOContrato().idOnly())||
      contrato.qnt_produto > 1 ||
      contrato.parcelas_definidas == true;

  /// Método post
  Future<bool> postCreate(Contrato contrato) async {
    try {
      if (_isNoAlterContrato(contrato)) throw IDException();

      if (await UtilsGeral.isContractExists(contrato.id.toString())) {
        throw ContractException();
      }

      // mapa do contrato que receberar as parcelas
      final contratoMap = await UtilsGeral.getSelectMapContrato(
          sprintf(SQLParcela.SELECT_CONTRATO, [contrato.id.toString()]));

      // verfica se esse contrato já tem parcelas definidas
      if (contratoMap[0]['parcelas_definidas']) {
        throw ParcelasDefinidasException();
      }

      int contSucess = 0;

      // data atual com salto de um mês
      DateTime dateToday = DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);

      // calculo do valor de cada parcela
      double valor = contratoMap[0]['valor'] / contratoMap[0]['num_parcelas'];

      // Definição das parcelas de acordo com a quantidade definida no contrato
      for (int i = 0; i < contratoMap[0]['num_parcelas']; i++) {
        if (await Cursor.execute(sprintf(SQLParcela.CREATE, [
          contrato.id.toString(),
          valor.toString(),
          DateFormat("dd-MM-yyyy").format(dateToday)
        ]))) contSucess++;
        dateToday =
            DateTime(dateToday.year, dateToday.month + 1, dateToday.day);
      }

      // Se tudo deu certo o status de parcelas definidas em contrato fica true
      return contSucess == contratoMap[0]['num_parcelas']
          ? await Cursor.execute(sprintf(
              "UPDATE ${SQLContrato.NAME_TABLE} SET parcelas_definidas = TRUE "
              "WHERE ${SQLGeral.ID}=%s;",
              [contrato.id.toString()]))
          : false;
    } on IDException {
      rethrow;
    } on ParcelasDefinidasException {
      rethrow;
    } on ContractException {
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  static List<String> autoItens() => SQLParcela.autoItens;

  /// verifica a inexistência de atributos nulos em parcela exeto status
  bool _isStatusOnly(Parcela parcela) =>
      UtilsGeral.isNullKeyMap(parcela.toMap(), autoItens()) ||
      parcela.status == null;

  Future<bool> _isInstallmentDateExists(String dataPag) async {
    final query = sprintf(SQLParcela.SELECT_BY_DATA_PAG, [dataPag]),
        getParcela = await UtilsGeral.getSelectMapPacela(query);
    return getParcela.isEmpty;
  }

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

      if (await _isInstallmentDateExists(dataPag)) {
        throw InstallmentDateException();
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
    } on InstallmentDateException {
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }
}
