// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Modules/Contrato/model.dart';
import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'model.dart';

class DAOParcela {
  // Acesso a Query que cria a tabela
  String createTable() => SQLParcela.CREATE_TABLE;

  // Método GET:

  /// Parcelas por id do contrato
  Future<List<Map<String, dynamic>>> getByIdContrato(String idContrato) =>
      UtilsGeral.getSelectMapPacela(
          sprintf(SQLParcela.SELECT_BY_ID_CONTRATO, [idContrato]));

  Future<List<Map<String, dynamic>>> getByDataPag(
          String idContrato, String dataPag) =>
      UtilsGeral.getSelectMapPacela(sprintf(
          SQLParcela.SELECT_BY_ID_CONTRATO_AND__DATA_PAG,
          [idContrato, dataPag]));

  static List<String> autoItens() => SQLParcela.autoItens;

  Future<int> create_parcela(double valorContrato, int num_parcelas, int id_contrato) async{
    /**
     * Criação das parcelas
     */

    int contSucessParcels = 0;

    // data atual com salto de um mês
    DateTime dateToday = DateTime(
        DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);

    // calculo do valor de cada parcela
    double valorParcela = valorContrato / num_parcelas;

    // Definição das parcelas de acordo com a quantidade definida no contrato
    for (int i = 0; i < num_parcelas; i++) {
      if (await Cursor.execute(sprintf(SQLParcela.CREATE, [
          id_contrato.toString(),
        valorParcela.toString(),
        DateFormat("dd-MM-yyyy").format(dateToday)
        ]))) contSucessParcels++;
        dateToday = DateTime(dateToday.year, dateToday.month + 1, dateToday.day);
    }

    return contSucessParcels;
  }

  /// verifica a inexistência de atributos nulos em parcela exeto status
  bool _isPagaOnly(Parcela parcela) =>
      UtilsGeral.isAutoItensNotNull(parcela.toMap(), autoItens()) ||
      parcela.paga == null;

  /// Apenas paga pode ser alterado na parcela
  Future<bool> putUpdate(
      Parcela parcela, String idContrato, String dataPag) async {
    try {
      if (idContrato == null ||
          idContrato.isEmpty ||
          dataPag == null ||
          dataPag.isEmpty) {
        throw IDException();
      }
      if (_isPagaOnly(parcela)) throw NoAlterException();

      if (await UtilsGeral.isNotContractExists(idContrato)) {
        throw ContractException();
      }

      if (await UtilsGeral.isNotParcelaExists(idContrato, dataPag)) {
        throw ParcelaException();
      }

      final oldParcela = await getByDataPag(idContrato, dataPag);

      bool paga =
          UtilsGeral.getValUpdate(oldParcela[0]['paga'], parcela.paga);

      return await Cursor.execute(
          sprintf(SQLParcela.UPDATE, [paga, idContrato, dataPag]));
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
