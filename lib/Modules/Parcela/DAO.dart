// ignore_for_file: unnecessary_null_comparison

import 'package:intl/intl.dart';
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
  String createTable() => SQLParcela.CREATE_TABLE;

  Future<List<Map<String, dynamic>>> getByIdContrato(String id) =>
      UtilsGeral.getSelectMapPacela(
          sprintf(SQLParcela.SELECT_BY_ID_CONTRATO, [id]));

  Future<List<Map<String, dynamic>>> getByDataPag(String id_contrato, String data_pag)=>
      UtilsGeral.getSelectMapPacela(sprintf(
          SQLParcela.SELECT_BY_DATA_PAG,[id_contrato, data_pag]));

  bool _IsNoAlterContrato(Contrato contrato) => 
      contrato.id_produto != null ||contrato.id_cliente != null 
      || contrato.num_parcelas != null ||
      contrato.data_criacao != null || contrato.valor != null ||
      contrato.qnt_produto > 1 || contrato.descricao != null||
      contrato.parcelas_definidas != null;

  Future<bool> postCreate(Contrato contrato) async {
    try {

      if(_IsNoAlterContrato(contrato)) throw IDException();

      final contratoMap = await UtilsGeral.getSelectMapContrato(
          sprintf(SQLParcela.SELECT_CONTRATO, [contrato.id.toString()]));

      if(contratoMap[0]['parcelas_definidas']) throw ParcelasDefinidasException();

      int contSucess = 0;

      DateTime dateToday = DateTime(
          DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);

      double valor = contratoMap[0]['valor'] / contratoMap[0]['num_parcelas'];

      for (int i = 0; i < contratoMap[0]['num_parcelas']; i++) {
        if (await Cursor.execute(sprintf(SQLParcela.CREATE, [
          contrato.id.toString(),
          valor.toString(),
          DateFormat("dd-MM-yyyy").format(dateToday)
        ]))) contSucess++;
        dateToday =
            DateTime(dateToday.year, dateToday.month + 1, dateToday.day);
      }
      
      return contSucess == contratoMap[0]['num_parcelas']?
      await Cursor.execute(sprintf(
          "UPDATE ${SQLContrato.NAME_TABLE} SET parcelas_definidas = TRUE "
              "WHERE ${SQLGeral.id}=%s;",[contrato.id.toString()])):false;
    } on IDException {
      rethrow;
    }on ParcelasDefinidasException{
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  bool _IsNoAlterParcela(Parcela parcela) =>
      parcela.id != null || parcela.id_contrato!=null ||
        parcela.valor != null || parcela.data_pag != null
        || parcela.status == null;

  Future<bool> putUpdate(Parcela parcela, String id_contrato, String data_pag) async{
    try {
      if (id_contrato==null || id_contrato.isEmpty || data_pag == null || data_pag.isEmpty) {
        throw IDException();
      }
      if(_IsNoAlterParcela(parcela)) throw NoAlterException();

      final oldParcela = await getByDataPag(id_contrato, data_pag);

      String status = UtilsGeral.getValUpdate(oldParcela, parcela.status);

      return await Cursor.execute(sprintf(SQLParcela.UPDATE, [status, id_contrato,data_pag]));
    }on NoAlterException{
      rethrow;
    } on IDException {
      rethrow;
    }catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }
}
