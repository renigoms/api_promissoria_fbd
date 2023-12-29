import 'package:postgres/legacy.dart';
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'model.dart';

class DAOClientes implements DAOUtilsI {
  @override
  String createTable() => SQLCliente.CREATE_TABLE;

  @override
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapCliente(SQLCliente.SELECT_ALL);

  @override
  Future<List<Map<String, dynamic>>> getByID(String id) =>
      UtilsGeral.getSelectMapCliente(sprintf(SQLCliente.SELECT_BY_ID, [id]));

  Future<List<Map<String, dynamic>>> getByName(String cpf) =>
      UtilsGeral.getSelectMapCliente(
          sprintf(SQLCliente.SELECT_BY_CPF, ["'$cpf'"]));

  Future<bool> postCreate(Cliente cliente) async {
    try {
      if (cliente.nome_completo == null || cliente.cpf == null
          || cliente.email == null || cliente.telefone==null) {
        throw NullException();
      }
      return await Cursor.execute(sprintf(SQLCliente.CREATE, [
        cliente.nome_completo,
        cliente.cpf,
        cliente.email,
        cliente.telefone
      ]));
    } on PostgreSQLException catch (e) {
      if (e.message
          .contains("duplicate key value violates unique constraint")) {
        rethrow;
      }
      return false;
    }on NullException{
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  Future<bool> putUpdate(Cliente cliente, String id) async {
    try {
      // ignore: unnecessary_null_comparison
      if (id == null || id.isEmpty) throw IDException();

      if(cliente.id != null) return throw NoAlterException();
      List oldCliente = await getByID(id);

      String nomeCompleto = UtilsGeral.getValUpdate(
              oldCliente[0]['nome_completo'], cliente.nome_completo),
          cpf = UtilsGeral.getValUpdate(oldCliente[0]['cpf'], cliente.cpf),
          email =
              UtilsGeral.getValUpdate(oldCliente[0]['email'], cliente.email),
          telefone = UtilsGeral.getValUpdate(
              oldCliente[0]['telefone'], cliente.telefone);

      final query =
          sprintf(SQLCliente.UPDATE, [nomeCompleto, cpf, email, telefone, id]);
      return await Cursor.execute(query);
    } on IDException {
      rethrow;
    }on NoAlterException{
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      return await UtilsGeral.executeDelete(SQLCliente.DELETE, id);
    } on IDException {
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
