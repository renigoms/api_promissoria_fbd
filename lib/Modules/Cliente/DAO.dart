import 'package:postgres/postgres.dart';
import 'package:sistema_promissorias/Modules/Cliente/SQL.dart';
import 'package:sistema_promissorias/Service/exceptions.dart';
import 'package:sistema_promissorias/Service/open_cursor.dart';
import 'package:sistema_promissorias/Utils/DAOUtils.dart';
import 'package:sprintf/sprintf.dart';

import 'model.dart';

class DAOCliente implements DAOUtilsI {
  // Acesso a Query de criacao da tabela
  @override
  String createTable() => SQLCliente.CREATE_TABLE;
  // Métodos GET:
  /// Todos os clientes
  @override
  Future<List<Map<String, dynamic>>> getAll() =>
      UtilsGeral.getSelectMapCliente(SQLCliente.SELECT_ALL);

  /// Clientes por id
  @override
  Future<List<Map<String, dynamic>>> getByID(String id) =>
      UtilsGeral.getSelectMapCliente(sprintf(SQLCliente.SELECT_BY_ID, [id]));

  /// Clientes por cpf
  Future<List<Map<String, dynamic>>> getByCPF(String cpf) =>
      UtilsGeral.getSelectMapCliente(sprintf(SQLCliente.SELECT_BY_CPF, [cpf]));

  @override
  List<String> requeredItens() => SQLCliente.requeredItens;

  /// Adiciona um novo registro de cliente ao banco
  Future<bool> postCreate(Cliente cliente) async {
    try {
      if (cliente.id != null) throw IDException();
      if (cliente.nome_completo == null ||
          cliente.cpf == null ||
          cliente.email == null ||
          cliente.telefone == null) {
        throw NullException();
      }
      return await Cursor.execute(sprintf(SQLCliente.CREATE, [
        cliente.nome_completo,
        cliente.cpf,
        cliente.email,
        cliente.telefone
      ]));
    } on PgException catch (e) {
      if (e.message
          .contains("duplicar valor da chave viola a restrição de unicidade")) {
        rethrow;
      }
      return false;
    } on NullException {
      rethrow;
    } on IDException {
      rethrow;
    } catch (e) {
      print("Erro $e ao salvar, tente novamente!");
      return false;
    }
  }

  /// Faz o update de um cliente passando um objeto cliente com as alterações
  /// e o id do cliente que será alterado
  Future<bool> putUpdate(Cliente cliente, String id) async {
    try {
      // ignore: unnecessary_null_comparison
      if (id == null || id.isEmpty) throw IDException();

      if (cliente.id != null) return throw NoAlterException();

      if (await UtilsGeral.isClientExists(id)) throw ClientException();

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
    } on NoAlterException {
      rethrow;
    } on ClientException {
      rethrow;
    } catch (e, s) {
      print("Erro durante o update, $e");
      print(s);
      return false;
    }
  }

  /// Deleta um cliente por id
  Future<bool> delete(String id) async {
    try {
      if (await UtilsGeral.isClientExists(id)) throw ClientException();
      return await UtilsGeral.executeDelete(SQLCliente.DELETE, id);
    } on IDException {
      rethrow;
    } on PgException {
      rethrow;
    } on ClientException {
      rethrow;
    } catch (e) {
      print("Erro ao deletar, $e");
      return false;
    }
  }
}
