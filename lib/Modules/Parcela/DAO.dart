import 'package:intl/intl.dart';
import 'package:sistema_promissorias/Modules/Parcela/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

class DAOParcela {
  String createTable() => SQLParcela.CREATE_TABLE;

  Future<List<Map<String, dynamic>>> getByIdContrato(String id) =>
      UtilsGeral.getSelectMapPacela(
          sprintf(SQLParcela.SELECT_BY_ID_CONTRATO, [id]));

  Future<bool> postCreate(String idContrato) async{
    try{
      if(idContrato.isEmpty) throw IDException();

      final contratoMap = await UtilsGeral.getSelectMapContrato(
          sprintf(SQLParcela.SELECT_CONTRATO, [idContrato])
      );

      int contSucess = 0;

      DateTime dateToday = DateTime(DateTime.now().year,DateTime.now().month+1,
          DateTime.now().day);

      double valor = contratoMap[0]['valor'] / contratoMap[0]['num_parcelas'];

      for(int i = 0; i<contratoMap[0]['num_parcelas'];i++){
        if(await Cursor.execute(sprintf(SQLParcela.CREATE, [
          idContrato, valor.toString(),
          DateFormat("dd-MM-yyyy").format(dateToday)
        ]))) contSucess++;
        dateToday = DateTime(dateToday.year, dateToday.month+1, dateToday.year);
      }
      return contSucess == contratoMap[0]['num_parcelas'];
    } on IDException{
      rethrow;
    }catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }

  }
}
